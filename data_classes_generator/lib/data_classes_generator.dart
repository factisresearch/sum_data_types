import 'package:analyzer/dart/element/element.dart';
import 'package:analyzer/dart/element/type.dart';
import 'package:build/build.dart';
import 'package:build/src/builder/build_step.dart';
import 'package:source_gen/source_gen.dart';
import 'package:data_classes/data_classes.dart';

Builder generateDataClass(BuilderOptions options) =>
    SharedPartBuilder([DataClassGenerator()], 'data_classes');

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

bool isQuiverOptional(DartType ty) {
  return ty.name == "Optional"; // FIXME: resolve module and check that it is quiver/core.dart
}

// Returns a potential qualified access string for the type, without type arguments
String qualifyType(DartType ty, Map<String, String> qualifiedImports) {
    final tyLib = ty.element.library;
    final prefixOrNull = qualifiedImports[tyLib.identifier];
    final prefix = (prefixOrNull != null) ? (prefixOrNull + ".") : "";
    return "${prefix}${ty.name}";
}

String computeTypeRepr(DartType ty, Map<String, String> qualifiedImports) {
  if (ty is FunctionType) {
    // FIXME: support function types
    throw DataClassCodegenException("function types are not supported");
  } else if (ty.isDynamic && ty.isUndefined) {
    throw DataClassCodegenException(
      "detected unresolvable type, you probably used the class being generated as type. "
      "Use the name of the mixin instead."
    );
  } else if (ty is ParameterizedType && ty.typeArguments.length > 0) {
    final base = qualifyType(ty, qualifiedImports);
    final args = ty.typeArguments.map((tyArg) => computeTypeRepr(tyArg, qualifiedImports));
    return "${base}<${args.join(", ")}>";
  } else {
    return qualifyType(ty, qualifiedImports);
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
    @required Map<String, String> qualifiedImports
  }) {
    final typeRepr = computeTypeRepr(ty, qualifiedImports);
    var optionalType = null;
    var typeReprForFactory = typeRepr;
    if (ty is ParameterizedType && ty.typeArguments.length == 1 && isQuiverOptional(ty)) {
      optionalType = qualifyType(ty, qualifiedImports);
      typeReprForFactory = computeTypeRepr(ty.typeArguments[0], qualifiedImports);
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
    @required Map<String, String> qualifiedImports
  }) {
    try {
      final ty = TypeModel(
        qualifiedImports: qualifiedImports,
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
      return
        "${name}: (${name} == null) ? "
        "${optionalType}.absent() : "
        "${optionalType}.of(${name})";
    } else {
      return "${name}: ${name}";
    }
  }

  String get constructorArgFromCopyWith {
    return "${name}: (${name} == null) ? this.${name} : ${name}";
  }

  String get assertNotNull {
    return "assert(${name} != null);";
  }

  String fieldEq(String otherVar) {
    return "${name} == ${otherVar}.${name}";
  }

  String get toStringField {
    return "${this.name}: " + r"${this.name}";
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
      if (!clazz.name.endsWith(r"$")) {
        throw DataClassCodegenException(r"the name of the mixin must end with a $");
      }

      // build a map of the qualified imports, mapping module identifiers to import prefixes
      var lib = clazz.library;
      Map<String, String> qualifiedImports = new Map();
      lib.imports.forEach((imp) {
        if (imp.prefix != null) {
          var modId = imp.importedLibrary.identifier;
          qualifiedImports[modId] = imp.prefix.name;
        }
      });

      final mixinName = clazz.name;
      final className = mixinName.substring(0, mixinName.length - 1);
      final fields = <FieldModel>[];

      for (var field in clazz.fields) {
        var msgPrefix = "Invalid getter '${field.name}' for data class '${mixinName}'";
        if (field.getter == null) {
          throw "${msgPrefix}: field must have a getter";
        } else if (!field.isFinal) {
          throw "${msgPrefix}: field must be final";
        } else if (field.setter != null) {
          throw "${msgPrefix}: field must not have a setter";
        } else {
          fields.add(FieldModel(
            field: field,
            qualifiedImports: qualifiedImports,
          ));
        }
      }

      final baseName = "_" + className + "Base";
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
    final params = this.fields.map((field) => field.copyWithParam).join(",");
    return "User copyWith({${params}})";
  }

  String get fieldList {
    return "[" + this.fields.map((field) => field.name + ",").join() + "]";
  }

  String get fieldDeclarations {
    return this.fields.map((field) => field.declaration).join();
  }

  String get factoryParams {
    return this.fields.map((field) => field.factoryParam + ",").join();
  }

  String get constructorParams {
    return this.fields.map((field) => field.constructorParam + ",").join();
  }

  String get constructorArgs {
    return this.fields.map((field) => field.constructorArgFromFactory + ",").join();
  }

  String get constructorBody {
    return this.fields.map((field) => field.assertNotNull).join();
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
      abstract class ${clazz.baseClassName} {
        ${clazz.copyWithSignature};
      }
      @immutable
      class ${clazz.className} extends ${clazz.baseClassName} with ${clazz.mixinName} {
        ${clazz.fieldDeclarations}

        factory ${clazz.className}({
          ${clazz.factoryParams}
        }) {
          return ${clazz.className}.make(
            ${clazz.constructorArgs}
          );
        }

        ${clazz.className}.make({
          ${clazz.constructorParams}
        }) {
          ${clazz.constructorBody}
        }

        ${clazz.copyWithSignature} {
          return ${clazz.className}.make(
            ${clazz.copyWithArgs}
          );
        }

        bool operator ==(Object other) {
          if (other == null) {
            return false;
          }
          if (identical(this, other)) {
            return true;
          }
          return (
            other is ${clazz.className} &&
            runtimeType == other.runtimeType &&
            ${clazz.fieldsEq("other")}
          );
        }

        int get hashCode {
          return hashList(${clazz.fieldList});
        }

        String toString() {
          return "${clazz.className}(${clazz.toStringFields})";
        }
      }''';
    // print(code);
    return code;
  }
}
