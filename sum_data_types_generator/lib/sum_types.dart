import 'package:analyzer/dart/element/element.dart';
import 'package:analyzer/dart/element/type.dart';
import 'package:build/build.dart';
import 'package:build/src/builder/build_step.dart';
import 'package:source_gen/source_gen.dart';
import 'package:sum_data_types/main.dart';
import './common.dart';

class TypeModel {
  TypeModel._();

  factory TypeModel(
      DartType ty,
      ImportModel imports,
  ) {
    return TypeModel._();
  }
}

class FieldModel {
  final CommonFieldModel<TypeModel> _commonModel;
  TypeModel get type => _commonModel.type;
  String get name => _commonModel.name;

  FieldModel(FieldElement fld, ImportModel imports) :
      this._commonModel = CommonFieldModel(fld, (DartType ty) => TypeModel(ty, imports));
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
}

class DataClassGenerator extends GeneratorForAnnotation<SumType> {

  @override
  generateForAnnotatedElement(Element element, ConstantReader annotation, BuildStep _) {
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
        abstract class ${clazz.factoryName}
        ''';
      // print(code);
      return code;
    } on CodegenException catch (e) {
      e.generatorName = "SumType";
      throw e;
    }
  }
}
