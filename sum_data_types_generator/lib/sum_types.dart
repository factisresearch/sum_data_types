import 'dart:async';

import 'package:analyzer/dart/element/element.dart';
import 'package:analyzer/dart/element/type.dart';
import 'package:build/build.dart';
import 'package:source_gen/source_gen.dart';
import 'package:sum_data_types/main.dart';
import './common.dart';

class TypeModel {
  final bool isUnit;
  final String typeRepr;

  TypeModel._({
    @required this.typeRepr,
    @required this.isUnit,
  });

  factory TypeModel(
      DartType ty,
      ImportModel imports,
  ) {
    final typeRepr = computeTypeRepr(ty, imports);
    final isUnit = isType(ty, "Unit", 'package:sum_data_types/main.dart', imports);
    return TypeModel._(isUnit: isUnit, typeRepr: typeRepr);
  }
}

enum SwitchMode {
  Required, Optional
}

class FieldModel {
  final CommonFieldModel<TypeModel> _commonModel;
  final ImportModel _imports;
  TypeModel get type => _commonModel.type;
  String get name => _commonModel.name;
  String get internalName => _commonModel.internalName;

  FieldModel(FieldElement fld, ImportModel imports) :
      this._commonModel = CommonFieldModel(
        fld, (DartType ty) => TypeModel(ty, imports), FieldNameConfig.Private
      ),
      this._imports = imports;

  String factoryMethod(String resultType, String tyArgs, String constructor) {
    String mkFun(String arg, String result) {
      return '''static $resultType $name$tyArgs($arg) {
        return $constructor($name: $result);
      }''';
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
    final prefix = (mode == SwitchMode.Required) ? '@required ' : '';
    return '$prefix$tyArg Function($switchArg) $name';
  }

  String get fieldDecl {
    return 'final ${type.typeRepr} $internalName;';
  }

  String get getterImpl {
    final optional = _imports.lookupOptionalType();
    return '''@override
      $getterDecl {
        return $optional<${type.typeRepr}>.fromNullable(this.$internalName);
      }''';
  }

  String get constructorParam {
    return '${type.typeRepr} $name';
  }

  String get constructorAssignment {
    return 'this.$internalName = $name';
  }

  String get iswitchIf {
    final funArg = this.type.isUnit ? '' : 'this.$internalName';
    return '''if (this.$internalName != null) {
      if ($name != null) {
        return $name($funArg);
      } else {
        throw new ArgumentError.notNull("$name");
      }
    }
    ''';
  }

  String iswitchArgFromOtherwise(String otherwise) {
    final _otherwise = this.type.isUnit ? otherwise : '(Object _) => $otherwise()';
    return '$name: $name ?? $_otherwise';
  }

  String get toStringSwitch {
    if (type.isUnit) {
      return '$name: () => "$name"';
    } else {
      return '$name: (${type.typeRepr} __value\$) => "$name(" + __value\$.toString() + ")"';
    }
  }
}

class ClassModel {

  final CommonClassModel<FieldModel> _commonModel;

  ClassModel(ClassElement clazz) :
      this._commonModel =
          CommonClassModel(
            clazz,
            (FieldElement fld, ImportModel imports) => FieldModel(fld, imports),
          );

  List<FieldModel> get fields => _commonModel.fields;
  String get className => _commonModel.className;
  String get baseClassName => _commonModel.baseClassName;
  String get mixinName => _commonModel.mixinName;
  String get factoryName => _commonModel.factoryName;
  List<String> get typeArgs => _commonModel.typeArgs;
  List<String> get fieldNames => fields.map((f) => f.name).toList();
  String get mixinType => _commonModel.mixinType;
  String get typeArgsWithParens => _commonModel.typeArgsWithParens;

  String get factoryMethods {
    final resultType = this.mixinType;
    return this.fields.map((field) => field.factoryMethod(
      resultType, this.typeArgsWithParens, this.className
    )).join("\n");
  }

  String get getterDecls {
    return this.fields.map((field) => field.getterDecl + ";").join("\n");
  }

  String switchParams(String tyArg, SwitchMode mode) {
    return this.fields.map((field) => field.switchParam(tyArg, mode)).join(",\n");
  }

  String get fieldDecls {
    return this.fields.map((field) => field.fieldDecl).join("\n");
  }

  String get getterImpls {
    return this.fields.map((field) => field.getterImpl).join("\n");
  }

  String get constructorParams {
    return this.fields.map((field) => field.constructorParam).join(",\n");
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
      preds.add('(' + innerPreds.join(' && ') + ')');
    }
    final assertExpr = 'assert(${preds.join(" || ")})';
    final assigns = this.fields.map((field) => field.constructorAssignment).join(',\n');
    return '$assertExpr, $assigns';
  }

  String get iswitchBody {
    final ifElse = this.fields.map((field) => field.iswitchIf).join(' else ');
    return '''$ifElse else {
      throw StateError("an instance of $mixinName has no case selected");
    }''';
  }

  String iswitchArgsFromOtherwise(String otherwise) {
    return this.fields.map((field) => field.iswitchArgFromOtherwise(otherwise)).join(",\n");
  }

  String get toStringSwitch {
    return this.fields.map((field) => field.toStringSwitch).join(",\n");
  }
}

class SumTypeGenerator extends GeneratorForAnnotation<SumType> {

  @override
  FutureOr<String> generateForAnnotatedElement(
    Element element, ConstantReader annotation, BuildStep _
  ) {
    if (element == null) {
      throw Exception("@SumType() applied to something that is null");
    }
    if (!(element is ClassElement)) {
      throw Exception('Only annotate mixins with `@SumType()`.');
    }
    try {
      final clazz = ClassModel(element as ClassElement);
      if (clazz.fields.isEmpty) {
        throw CodegenException("no alternatives defined for ${clazz.mixinName}");
      }
      const tyArg = r'__T$';
      const otherwise = r'otherwise__$';
      final code = '''
        /// This data class has been generated from ${clazz.mixinName}
        abstract class ${clazz.factoryName} {
          ${clazz.factoryMethods}
        }
        abstract class ${clazz.baseClassName}${clazz.typeArgsWithParens} {
          const ${clazz.baseClassName}();
          ${clazz.getterDecls}
          $tyArg iswitch<$tyArg>({
            ${clazz.switchParams(tyArg, SwitchMode.Required)}
          });
          $tyArg iswitcho<$tyArg>({
            ${clazz.switchParams(tyArg, SwitchMode.Optional)},
            @required $tyArg Function() $otherwise,
          });
        }
        class ${clazz.className}${clazz.typeArgsWithParens}
            extends ${clazz.baseClassName}${clazz.typeArgsWithParens}
            with ${clazz.mixinName}${clazz.typeArgsWithParens}
        {
          ${clazz.fieldDecls}
          ${clazz.getterImpls}
          ${clazz.className}({
            ${clazz.constructorParams}
          }) : ${clazz.constructorInitializers};

          @override
          $tyArg iswitch<$tyArg>({
            ${clazz.switchParams(tyArg, SwitchMode.Required)}
          }) {
            ${clazz.iswitchBody}
          }

          @override
          $tyArg iswitcho<$tyArg>({
            ${clazz.switchParams(tyArg, SwitchMode.Optional)},
            @required $tyArg Function() $otherwise,
          }) {
            return iswitch(
              ${clazz.iswitchArgsFromOtherwise(otherwise)}
            );
          }

          ${eqImpl(clazz.className, clazz.fieldNames)}

          ${hashCodeImpl(clazz.fieldNames)}

          @override
          toString() {
            final __x\$ = iswitch(${clazz.toStringSwitch});
            return "${clazz.mixinName}." + __x\$;
          }
        }
        ''';
      //print(code);
      return code;
    } on CodegenException catch (e) {
      e.generatorName = "SumType";
      rethrow;
    }
  }
}
