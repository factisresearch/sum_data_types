import 'package:analyzer/dart/element/element.dart';
import 'package:analyzer/dart/element/type.dart';
import 'package:build/build.dart';
import 'package:build/src/builder/build_step.dart';
import 'package:source_gen/source_gen.dart';
import 'package:sum_data_types/main.dart';

Builder generateDataClass(BuilderOptions options) =>
    SharedPartBuilder([DataClassGenerator()], 'sum_data_types');

final quiverPackageUri = "package:quiver/core.dart";

class DataClassCodegenException with Exception {
  String className;
  String fieldName;
  final String message;
  DataClassCodegenException(this.message);
  String toString() {
    var loc = "";
    if (className != null && fieldName != null) {
      loc = " for mixin ${className} and field ${fieldName}";
    } else if (className != null) {
      loc = " for mixin ${className}";
    }
    return "Error generating @DataClass() code${loc}: $message";
  }
}

class OptionalType {
  final String baseType;
  final String optionalImportPrefix;
  OptionalType({
    @required this.baseType,
    @required this.optionalImportPrefix
  });

  String get optional {
    return optionalImportPrefix + "Optional";
  }
}

bool isQuiverOptional(DartType ty, ImportModel imports) {
  final tyLib = ty.element.library;
  return ty.name == "Optional" && imports.importUri(tyLib) == quiverPackageUri;
}

// Returns a potential qualified access string for the type, without type arguments
String qualifyType(DartType ty, ImportModel imports) {
    final tyLib = ty.element.library;
    final prefixOrNull = imports.importPrefixOrNull(tyLib);
    final prefix = (prefixOrNull != null) ? (prefixOrNull + ".") : "";
    return "${prefix}${ty.name}";
}

String computeTypeRepr(DartType ty, ImportModel imports) {
  if (ty is FunctionType) {
    throw DataClassCodegenException("function types are not supported");
  } else if (ty.isDynamic) {
    return "dynamic";
  } else if (ty is ParameterizedType && ty.typeArguments.length > 0) {
    final base = qualifyType(ty, imports);
    final args = ty.typeArguments.map((tyArg) => computeTypeRepr(tyArg, imports));
    return "${base}<${args.join(", ")}>";
  } else {
    return qualifyType(ty, imports);
  }
}

class ImportModel {

  final Map<String, String> _moduleIdToPrefix = Map();
  final Map<String, String> _moduleIdToUri = Map();

  String importPrefixOrNull(LibraryElement lib) {
    return _moduleIdToPrefix[lib.identifier];
  }

  String importUri(LibraryElement lib) {
    return _moduleIdToUri[lib.identifier];
  }

  void addImportElement(ImportElement imp) {
    final modId = imp.importedLibrary.identifier;
    this._moduleIdToUri[modId] = imp.uri;
    if (imp.prefix != null) {
      this._moduleIdToPrefix[modId] = imp.prefix.name;
    }
  }
}

class TypeModel {
  final String typeRepr;
  final String typeReprForFactory;
  final String optionalType;
  bool get isOptional {
    return optionalType != null;
  }

  TypeModel._({
    @required this.typeRepr,
    @required this.typeReprForFactory,
    @required this.optionalType,
  });

  factory TypeModel({
    @required DartType ty,
    @required ImportModel imports,
  }) {
    final typeRepr = computeTypeRepr(ty, imports);
    var optionalType = null;
    var typeReprForFactory = typeRepr;
    if (ty is ParameterizedType && ty.typeArguments.length == 1 && isQuiverOptional(ty, imports)) {
      optionalType = qualifyType(ty, imports);
      typeReprForFactory = computeTypeRepr(ty.typeArguments[0], imports);
    }
    return TypeModel._(
      typeRepr: typeRepr,
      typeReprForFactory: typeReprForFactory,
      optionalType: optionalType
    );
  }
}

class FieldModel {

  final String name;
  final TypeModel type;

  factory FieldModel({
    @required FieldElement field,
    @required ImportModel imports,
  }) {
    try {
      final ty = TypeModel(
        imports: imports,
        ty: field.type,
      );
      return FieldModel._(
        name: field.name,
        type: ty,
      );
    } on DataClassCodegenException catch (e) {
      e.fieldName = field.name;
      throw e;
    }
  }

  FieldModel._({
    @required this.name,
    @required this.type,
  });

  String get declaration {
    return "final ${this.type.typeRepr} ${this.name};";
  }

  String get factoryParam {
    String prefix = this.type.isOptional ? "" : "@required ";
    return "${prefix}${this.type.typeReprForFactory} ${name}";
  }

  // Parameter of the constructor
  String get constructorParam {
    return "@required this.${name}";
  }

  // Argument for calling the constructor from the factory
  String get constructorArgFromFactory {
    final optionalType = this.type.optionalType;
    if (optionalType != null) {
      return "${name}: ${optionalType}.fromNullable(${name})";
    } else {
      return "${name}: ${name}";
    }
  }

  String get constructorArgFromCopyWith {
    return "${name}: ${name} ?? this.${name}";
  }

  String get assertNotNull {
    return "assert(${name} != null)";
  }

  String fieldEq(String otherVar) {
    return "this.${name} == ${otherVar}.${name}";
  }

  String get toStringField {
    return "${this.name}: " + r"${this." + name + "}";
  }

  String get copyWithParam {
    return "${this.type.typeRepr} ${this.name}";
  }
}

class ClassModel {
  final String mixinName;
  final String className;
  final String baseClassName;
  final List<FieldModel> fields;

  ClassModel._({
    @required this.mixinName,
    @required this.className,
    @required this.baseClassName,
    @required this.fields,
  });

  factory ClassModel(ClassElement clazz) {
    try {
      // build a map of the qualified imports, mapping module identifiers to import prefixes
      var lib = clazz.library;
      final imports = ImportModel();
      lib.imports.forEach((imp) {
        imports.addImportElement(imp);
      });

      final mixinName = clazz.name;
      final className = "_" + mixinName;
      final baseName = className + "Base";
      final fields = <FieldModel>[];

      for (var field in clazz.fields) {
        var msgPrefix = "Invalid getter '${field.name}' for data class '${mixinName}'";
        if (field.getter == null && !field.isFinal) {
          throw "${msgPrefix}: field must have a getter";
        } else if (field.setter != null) {
          throw "${msgPrefix}: field must not have a setter";
        } else {
          fields.add(FieldModel(
            field: field,
            imports: imports,
          ));
        }
      }

      return ClassModel._(
        mixinName: mixinName,
        baseClassName: baseName,
        className: className,
        fields: fields
      );
    } on DataClassCodegenException catch (e) {
      e.className = clazz.name;
      throw e;
    }
  }

  String get copyWithSignature {
    final params =
        (this.fields.isNotEmpty)
        ? "{" + this.fields.map((field) => field.copyWithParam).join(",") + "}"
        : "";
    return "${this.className} copyWith(${params})";
  }

  String get hashUpdates {
    return this.fields.map((field) => "result = 37 * result + this.${field.name}.hashCode;").join("\n");
  }

  String get fieldDeclarations {
    return this.fields.map((field) => field.declaration).join();
  }

  String get factoryParams {
    return
        this.fields.isNotEmpty
        ? "{" + this.fields.map((field) => field.factoryParam + ",").join() + "}"
        : "";
  }

  String get constructorParams {
    return
        this.fields.isNotEmpty
        ? "{" + this.fields.map((field) => field.constructorParam + ",").join() + "}"
        : "";
  }

  String get constructorArgs {
    return this.fields.map((field) => field.constructorArgFromFactory + ",").join();
  }

  String get constructorAsserts {
    if (this.fields.isEmpty) {
      return ";";
    } else {
      return " : " + this.fields.map((field) => field.assertNotNull).join(", ") + ";";
    }
  }

  String get copyWithArgs {
    return this.fields.map((field) => field.constructorArgFromCopyWith + ",").join();
  }

  String fieldsEq(String otherVar) {
    if (this.fields.length == 0) {
      return "true";
    } else {
      return this.fields.map((field) => field.fieldEq(otherVar)).join(" && ");
    }
  }

  String get toStringFields {
    return this.fields.map((field) => field.toStringField).join(", ");
  }
}

class DataClassGenerator extends GeneratorForAnnotation<DataClass> {

  @override
  generateForAnnotatedElement(
      Element element, ConstantReader annotation, BuildStep _) {
    if (element == null) {
      throw "@DataClass() applied to something that is null";
    }
    if (!(element is ClassElement)) {
      throw 'Only annotate mixins with `@DataClass()`.';
    }
    var clazz = ClassModel(element as ClassElement);

    var code = '''
      /// This data class has been generated from ${clazz.mixinName}
      abstract class ${clazz.mixinName}Factory {
        static ${clazz.mixinName} make(
          ${clazz.factoryParams}
        ) {
          return ${clazz.className}.make(
            ${clazz.constructorArgs}
          );
        }
      }
      abstract class ${clazz.baseClassName} {
        ${clazz.copyWithSignature};
      }
      @immutable
      class ${clazz.className} extends ${clazz.baseClassName} with ${clazz.mixinName} {
        ${clazz.fieldDeclarations}

        // We cannot have a const constructor because of https://github.com/dart-lang/sdk/issues/37810
        ${clazz.className}.make(
          ${clazz.constructorParams}
        ) ${clazz.constructorAsserts}

        ${clazz.copyWithSignature} {
          return ${clazz.className}.make(
            ${clazz.copyWithArgs}
          );
        }

        bool operator ==(Object other) {
          if (identical(this, other)) {
            return true;
          }
          return (
            other is ${clazz.className} &&
            this.runtimeType == other.runtimeType &&
            ${clazz.fieldsEq("other")}
          );
        }

        int get hashCode {
          var result = 17;
          ${clazz.hashUpdates}
          return result;
        }

        String toString() {
          return "${clazz.mixinName}(${clazz.toStringFields})";
        }
      }''';
    // print(code);
    return code;
  }
}
