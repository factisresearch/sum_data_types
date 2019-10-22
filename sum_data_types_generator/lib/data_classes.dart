import 'package:analyzer/dart/element/element.dart';
import 'package:analyzer/dart/element/type.dart';
import 'package:build/build.dart';
import 'package:build/src/builder/build_step.dart';
import 'package:source_gen/source_gen.dart';
import 'package:sum_data_types/main.dart';
import './common.dart';

Builder generateDataClass(BuilderOptions options) =>
    SharedPartBuilder([DataClassGenerator()], 'sum_data_types');

final quiverPackageUri = "package:quiver/core.dart";

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
  return isType(ty, "Optional", quiverPackageUri, imports);
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

  factory TypeModel(
    DartType ty,
    ImportModel imports,
  ) {
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

  final CommonFieldModel<TypeModel> _commonModel;
  TypeModel get type => _commonModel.type;
  String get name => _commonModel.name;

  FieldModel(FieldElement fld, ImportModel imports) :
      this._commonModel = CommonFieldModel(
        fld, (DartType ty) => TypeModel(ty, imports), FieldNameConfig.Public
      );

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

  final CommonClassModel<FieldModel> _commonModel;

  List<FieldModel> get fields => _commonModel.fields;
  String get className => _commonModel.className;
  String get baseClassName => _commonModel.baseClassName;
  String get mixinName => _commonModel.mixinName;
  String get factoryName => _commonModel.factoryName;

  ClassModel(ClassElement clazz) :
      this._commonModel =
          CommonClassModel(
            clazz,
            (FieldElement fld, ImportModel imports) => FieldModel(fld, imports),
          );

  String get copyWithSignature {
    final params =
        (this.fields.isNotEmpty)
        ? "{" + this.fields.map((field) => field.copyWithParam).join(",") + "}"
        : "";
    return "${this.className} copyWith(${params})";
  }

  String get hashUpdates {
    return this.fields.map((field) =>
        "result = 37 * result + this.${field.name}.hashCode;").join("\n");
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
    try {
      var clazz = ClassModel(element as ClassElement);
      var code = '''
        /// This data class has been generated from ${clazz.mixinName}
        abstract class ${clazz.factoryName} {
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
    } on CodegenException catch (e) {
      e.generatorName = "DataClass";
      throw e;
    }
  }
}
