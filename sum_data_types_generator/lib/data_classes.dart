import 'dart:async';

import 'package:analyzer/dart/element/element.dart';
import 'package:analyzer/dart/element/type.dart';
import 'package:build/build.dart';
import 'package:source_gen/source_gen.dart';
import 'package:sum_data_types/main.dart';
import './common.dart';

Builder generateDataClass(BuilderOptions options) =>
    SharedPartBuilder([DataClassGenerator()], 'sum_data_types');

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
    String optionalType;
    var typeReprForFactory = typeRepr;
    if (ty is ParameterizedType && ty.typeArguments.length == 1 && isQuiverOptional(ty, imports)) {
      optionalType = qualifyType(ty, imports);
      typeReprForFactory = computeTypeRepr(ty.typeArguments[0], imports);
    }
    return TypeModel._(
        typeRepr: typeRepr, typeReprForFactory: typeReprForFactory, optionalType: optionalType);
  }
}

class FieldModel {
  final CommonFieldModel<TypeModel> _commonModel;
  TypeModel get type => _commonModel.type;
  String get name => _commonModel.name;

  FieldModel(FieldElement fld, ImportModel imports)
      : this._commonModel =
            CommonFieldModel(fld, (DartType ty) => TypeModel(ty, imports), FieldNameConfig.Public);

  String get declaration {
    return '@override\nfinal ${this.type.typeRepr} ${this.name};';
  }

  String get factoryParam {
    final prefix = this.type.isOptional ? '' : '@required ';
    return '$prefix${this.type.typeReprForFactory} $name';
  }

  // Parameter of the constructor
  String get constructorParam {
    return '@required this.$name';
  }

  // Argument for calling the constructor from the factory
  String get constructorArgFromFactory {
    final optionalType = this.type.optionalType;
    if (optionalType != null) {
      return '$name: $optionalType.fromNullable($name)';
    } else {
      return '$name: $name';
    }
  }

  String get constructorArgFromCopyWith {
    return '$name: $name ?? this.$name';
  }

  String get assertNotNull {
    return 'assert($name != null)';
  }

  String get toStringField {
    return '${this.name}: \${this.$name}';
  }

  String get copyWithParam {
    return '${this.type.typeRepr} ${this.name},';
  }
}

class ClassModel {
  final CommonClassModel<FieldModel> _commonModel;

  List<FieldModel> get fields => _commonModel.fields;
  String get className => _commonModel.className;
  String get baseClassName => _commonModel.baseClassName;
  String get mixinName => _commonModel.mixinName;
  String get factoryName => _commonModel.factoryName;
  List<String> get fieldNames => fields.map((f) => f.name).toList();
  String get mixinType => _commonModel.mixinType;
  String get typeArgsWithParens => _commonModel.typeArgsWithParens;
  CodgenConfig get config => _commonModel.config;

  ClassModel(ClassElement clazz, ConstantReader reader)
      : this._commonModel = CommonClassModel(
          clazz,
          (FieldElement fld, ImportModel imports) => FieldModel(fld, imports),
          reader,
        );

  String get copyWithSignature {
    final params = (this.fields.isNotEmpty)
        ? '{' + this.fields.map((field) => field.copyWithParam).join('') + '}'
        : '';
    return '${this.mixinType} copyWith($params)';
  }

  String get fieldDeclarations {
    return this.fields.map((field) => field.declaration).join();
  }

  String get factoryParams {
    return this.fields.isNotEmpty
        ? '{' + this.fields.map((field) => field.factoryParam + ',').join() + '}'
        : '';
  }

  String get constructorParams {
    return this.fields.isNotEmpty
        ? '{' + this.fields.map((field) => field.constructorParam + ',').join() + '}'
        : '';
  }

  String get constructorArgs {
    return this.fields.map((field) => field.constructorArgFromFactory + ',').join();
  }

  String get constructorAsserts {
    if (this.fields.isEmpty) {
      return ';';
    } else {
      return ' : ' + this.fields.map((field) => field.assertNotNull).join(', ') + ';';
    }
  }

  String get copyWithArgs {
    return this.fields.map((field) => field.constructorArgFromCopyWith + ',').join();
  }

  String get toStringFields {
    return this.fields.map((field) => field.toStringField).join(', ');
  }
}

class DataClassGenerator extends GeneratorForAnnotation<DataClass> {
  @override
  FutureOr<String> generateForAnnotatedElement(
      Element element, ConstantReader annotation, BuildStep _) {
    if (element == null) {
      throw Exception('@DataClass() applied to something that is null');
    }
    if (!(element is ClassElement)) {
      throw Exception('Only annotate mixins with `@DataClass()`.');
    }
    try {
      final clazz = ClassModel(element as ClassElement, annotation);
      final toStringMethod = '''
        @override
        String toString() {
          return '${clazz.mixinName}(${clazz.toStringFields})';
        }
      ''';
      final code = '''
        /// This data class has been generated from ${clazz.mixinName}
        abstract class ${clazz.factoryName} {
          static ${clazz.mixinType} make${clazz.typeArgsWithParens}(
            ${clazz.factoryParams}
          ) {
            return ${clazz.className}.make(
              ${clazz.constructorArgs}
            );
          }
        }
        abstract class ${clazz.baseClassName}${clazz.typeArgsWithParens} {
          const ${clazz.baseClassName}();

          ${clazz.copyWithSignature};
        }
        @immutable
        class ${clazz.className}${clazz.typeArgsWithParens}
            extends ${clazz.baseClassName}${clazz.typeArgsWithParens}
            with ${clazz.mixinName}${clazz.typeArgsWithParens}
        {
          ${clazz.fieldDeclarations}

          const ${clazz.className}.make(
            ${clazz.constructorParams}
          ) ${clazz.constructorAsserts}

          @override
          ${clazz.copyWithSignature} {
            return ${clazz.className}.make(
              ${clazz.copyWithArgs}
            );
          }

          ${clazz.config.genEqHashCode ? eqImpl(clazz.className, clazz.fieldNames) : ''}

          ${clazz.config.genEqHashCode ? hashCodeImpl(clazz.fieldNames) : ''}

          ${clazz.config.genToString ? toStringMethod : ''}
        }''';
      // print(code);
      return code;
    } on CodegenException catch (e) {
      e.generatorName = 'DataClass';
      rethrow;
    }
  }
}
