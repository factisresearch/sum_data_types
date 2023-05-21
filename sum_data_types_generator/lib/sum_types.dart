import 'dart:async';

import 'package:analyzer/dart/element/element.dart';
import 'package:analyzer/dart/element/type.dart';
import 'package:build/build.dart';
import 'package:source_gen/source_gen.dart';
import 'package:sum_data_types/sum_data_types.dart';
import './common.dart';

class TypeModel {
  final bool isUnit;
  final bool isDynamic;
  final String typeRepr;

  TypeModel._({
    required this.typeRepr,
    required this.isUnit,
    required this.isDynamic,
  });

  factory TypeModel(
    DartType ty,
    ImportModel imports,
  ) {
    final typeRepr = computeTypeRepr(ty, imports);
    final isUnit = isType(ty, 'Unit', 'package:sum_data_types/sum_data_types.dart', imports);
    return TypeModel._(isUnit: isUnit, isDynamic: ty is DynamicType, typeRepr: typeRepr);
  }
}

enum SwitchMode { required, optional }

class FieldModel {
  final CommonFieldModel<TypeModel> _commonModel;
  final ImportModel _imports;
  final CodgenConfig cfg;
  TypeModel get type => _commonModel.type;
  String get name => _commonModel.name;
  String get internalName => _commonModel.internalName;

  FieldModel(FieldElement fld, ImportModel imports, this.cfg)
      : this._commonModel =
            CommonFieldModel(fld, (DartType ty) => TypeModel(ty, imports), FieldNameConfig.private),
        this._imports = imports;

  String factoryMethod(String resultType, String tyArgs, String constructor) {
    String mkFun(String arg, String result) {
      return '''static $resultType $name$tyArgs($arg) =>
          $constructor($name: $result);''';
    }

    if (this.type.isUnit) {
      return mkFun('', 'const ${type.typeRepr}()');
    } else {
      const x = r'__x$';
      return mkFun('${type.typeRepr} $x', x);
    }
  }

  String get getterDecl {
    final optional = _imports.lookupOptionalType();
    return '$optional<${type.typeRepr}> get $name';
  }

  String switchParam(String tyArg, SwitchMode mode) {
    final switchArg = this.type.isUnit ? '' : this.type.typeRepr;
    if (cfg.nnbd) {
      final prefix = (mode == SwitchMode.required) ? 'required ' : '';
      final typeModifier = (mode == SwitchMode.optional) ? '?' : '';
      return '$prefix$tyArg Function($switchArg)$typeModifier $name';
    } else {
      final prefix = (mode == SwitchMode.required) ? '@required ' : '';
      return '$prefix$tyArg Function($switchArg) $name';
    }
  }

  String get fieldDecl {
    if (cfg.nnbd && !type.isDynamic) {
      return '@override\nfinal ${type.typeRepr}? $internalName;';
    } else {
      return '@override\nfinal ${type.typeRepr} $internalName;';
    }
  }

  String get getterImpl {
    final optional = _imports.lookupOptionalType();
    return '@override\n$getterDecl => $optional<${type.typeRepr}>.fromNullable(this.$internalName);';
  }

  String get constructorParam {
    if (cfg.nnbd) {
      return '${type.typeRepr}${type.isDynamic ? '' : '?'} $name,';
    } else {
      return '${type.typeRepr} $name, // ignore: always_require_non_null_named_parameters';
    }
  }

  String get constructorAssignment {
    return 'this.$internalName = $name';
  }

  String get iswitchAssignment {
    return 'final ${type.typeRepr}? $internalName = this.$internalName;';
  }

  String get iswitchIf {
    final funArg = this.type.isUnit ? '' : internalName;
    if (cfg.nnbd) {
      return '''if ($internalName != null) {
        return $name($funArg);
      }
      ''';
    } else {
      return '''if ($internalName != null) {
        if ($name == null) { throw ArgumentError.notNull('$name'); }
        return $name($funArg);
      }
      ''';
    }
  }

  String iswitchArgFromOtherwise(String otherwise) {
    final otherwiseVal = this.type.isUnit ? otherwise : '(${this.type.typeRepr} _) => $otherwise()';
    return '$name: $name ?? $otherwiseVal,';
  }

  String get toStringSwitch {
    if (type.isUnit) {
      return '$name: () => \'$name\',';
    } else {
      return '$name: (${type.typeRepr} __value\$) => \'$name(\${__value\$})\',';
    }
  }
}

class ClassModel {
  final CommonClassModel<FieldModel> _commonModel;

  ClassModel(MixinElement clazz, ConstantReader reader)
      : this._commonModel = CommonClassModel(
          clazz,
          (FieldElement fld, ImportModel imports, cfg) => FieldModel(fld, imports, cfg),
          reader,
        );

  List<FieldModel> get fields => _commonModel.fields;
  String get className => _commonModel.className;
  String get baseClassName => _commonModel.baseClassName;
  String get mixinName => _commonModel.mixinName;
  String get factoryName => _commonModel.factoryName;
  List<String> get typeArgs => _commonModel.typeArgs;
  List<String> get fieldNames => fields.map((f) => f.name).toList();
  List<String> get internalFieldNames => fields.map((f) => f.internalName).toList();
  String get mixinType => _commonModel.mixinType;
  String get typeArgsWithParens => _commonModel.typeArgsWithParens;
  CodgenConfig get config => _commonModel.config;

  String get factoryMethods {
    final resultType = this.mixinType;
    return this
        .fields
        .map((field) => field.factoryMethod(resultType, this.typeArgsWithParens, this.className))
        .join('\n');
  }

  String get getterDecls {
    return this.fields.map((field) => '${field.getterDecl};').join('\n');
  }

  String switchParams(String tyArg, SwitchMode mode) {
    return this.fields.map((field) => field.switchParam(tyArg, mode)).join(',\n');
  }

  String get fieldDecls {
    return this.fields.map((field) => field.fieldDecl).join('\n');
  }

  String get getterImpls {
    return this.fields.map((field) => field.getterImpl).join('\n');
  }

  String get constructorParams {
    return this.fields.map((field) => field.constructorParam).join('\n');
  }

  String get constructorInitializers {
    if (this.fields.isEmpty) {
      return '';
    }
    final preds = <String>[];
    for (var i = 0; i < this.fields.length; i++) {
      final innerPreds = <String>[];
      for (var j = 0; j < this.fields.length; j++) {
        final inner = this.fields[j].name;
        if (i == j) {
          innerPreds.add('$inner != null');
        } else {
          innerPreds.add('$inner == null');
        }
      }
      preds.add('(${innerPreds.join(' && ')})');
    }
    final assertExpr = 'assert(${preds.join(' || ')})';
    final assigns = this.fields.map((field) => field.constructorAssignment).join(',\n');
    return '$assertExpr, $assigns';
  }

  String get iswitchBody {
    final iswitchAssignments = this.fields.map((field) => field.iswitchAssignment).join('\n');
    final ifElse = this.fields.map((field) => field.iswitchIf).join(' else ');
    return '''
      $iswitchAssignments
      $ifElse else {
      throw StateError('an instance of $mixinName has no case selected');
    }''';
  }

  String iswitchArgsFromOtherwise(String otherwise) {
    return this.fields.map((field) => field.iswitchArgFromOtherwise(otherwise)).join('\n');
  }

  String get toStringSwitch {
    return this.fields.map((field) => field.toStringSwitch).join('\n');
  }
}

class SumTypeGenerator extends GeneratorForAnnotation<SumType> {
  @override
  FutureOr<String> generateForAnnotatedElement(
      Element element, ConstantReader annotation, BuildStep buildStep) {
    if (element is! MixinElement) {
      throw Exception('Only annotate mixins with `@SumType()`.');
    }
    try {
      final clazz = ClassModel(element, annotation);
      if (clazz.fields.isEmpty) {
        throw CodegenException('no alternatives defined for ${clazz.mixinName}');
      }
      const tyArg = r'__T$';
      final otherwise = clazz.fieldNames.contains('otherwise') ? r'otherwise__$' : 'otherwise';
      final toStringMethod = '''
        @override
        String toString() {
          final __x\$ = iswitch(${clazz.toStringSwitch});
          return '${clazz.mixinName}.\${__x\$}';
        }
      ''';
      final code = '''
        /// This data class has been generated from ${clazz.mixinName}
        abstract class ${clazz.factoryName} {
          ${clazz.factoryMethods}
        }
        abstract class ${clazz.baseClassName}${clazz.typeArgsWithParens} {
          const ${clazz.baseClassName}();
          ${clazz.getterDecls}
          $tyArg iswitch<$tyArg>({
            ${clazz.switchParams(tyArg, SwitchMode.required)}
          });
          $tyArg iswitcho<$tyArg>({
            ${clazz.switchParams(tyArg, SwitchMode.optional)},
            ${clazz.config.nnbd ? 'required' : '@required'} $tyArg Function() $otherwise,
          });
        }

        @immutable
        class ${clazz.className}${clazz.typeArgsWithParens}
            extends ${clazz.baseClassName}${clazz.typeArgsWithParens}
            with ${clazz.mixinName}${clazz.typeArgsWithParens}
        {
          ${clazz.fieldDecls}

          ${clazz.getterImpls}

          const ${clazz.className}({
            ${clazz.constructorParams}
          }) : ${clazz.constructorInitializers};

          @override
          $tyArg iswitch<$tyArg>({
            ${clazz.switchParams(tyArg, SwitchMode.required)},
          }) {
            ${clazz.iswitchBody}
          }

          @override
          $tyArg iswitcho<$tyArg>({
            ${clazz.switchParams(tyArg, SwitchMode.optional)},
            ${clazz.config.nnbd ? 'required' : '@required'} $tyArg Function() $otherwise,
          }) {
            return iswitch(
              ${clazz.iswitchArgsFromOtherwise(otherwise)}
            );
          }

          ${clazz.config.genEqHashCode ? eqImpl(clazz.className, clazz.internalFieldNames) : ''}

          ${clazz.config.genEqHashCode ? hashCodeImpl(clazz.internalFieldNames) : ''}

          ${clazz.config.genToString ? toStringMethod : ''}
        }
        ''';
      return code;
    } on CodegenException catch (e) {
      e.generatorName = 'SumType';
      rethrow;
    }
  }
}
