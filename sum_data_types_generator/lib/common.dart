import 'package:analyzer/dart/analysis/features.dart';
import 'package:analyzer/dart/element/element.dart';
import 'package:analyzer/dart/element/type.dart';
import 'package:meta/meta.dart';
import 'package:source_gen/source_gen.dart';
import 'package:sum_data_types/main.dart';

class CodegenException with Exception {
  String className;
  String fieldName;
  String generatorName;
  final String message;
  CodegenException(this.message);

  @override
  String toString() {
    var loc = '';
    if (className != null && fieldName != null) {
      loc = " for mixin '$className' and field '$fieldName'";
    } else if (className != null) {
      loc = " for mixin '$className'";
    }
    var genName = '';
    if (generatorName != null) {
      genName = ' @$generatorName';
    }
    return 'Error generating$genName code$loc: $message';
  }
}

bool isType(DartType ty, String name, String packageUri, ImportModel imports) {
  final tyLib = ty.element.librarySource?.uri;
  return ty.element.name == name && tyLib.toString() == packageUri;
}

const quiverPackageUris = [
  'package:quiver/src/core/optional.dart',
  'package:quiver/core.dart',
];

bool isQuiverOptional(DartType ty, ImportModel imports) {
  return quiverPackageUris.any((packageUri) => isType(ty, 'Optional', packageUri, imports));
}

// Returns a potential qualified access string for the type, without type arguments
String qualifyType(DartType ty, ImportModel imports) {
  final prefixOrNull = imports._fullNameToPrefix[fullName(ty.element)];
  final prefix = (prefixOrNull != null) ? (prefixOrNull + '.') : '';
  return '$prefix${ty.element.name}';
}

// Returns a textual representation of the given type, including generic types
// and import prefixes.
String computeTypeRepr(DartType ty, ImportModel imports) {
  if (ty is FunctionType) {
    throw CodegenException('function types are not supported');
  } else if (ty.isDynamic) {
    return 'dynamic';
  } else if (ty is ParameterizedType && ty.typeArguments.isNotEmpty) {
    final base = qualifyType(ty, imports);
    final args = ty.typeArguments.map((tyArg) => computeTypeRepr(tyArg, imports));
    return '$base<${args.join(', ')}>';
  } else {
    return qualifyType(ty, imports);
  }
}

String fullName(Element element) {
  return element.librarySource.uri.toString() + ':' + element.toString();
}

class ImportModel {
  final Map<String, String> _moduleIdToPrefix = {};
  final Map<String, String> _fullNameToPrefix = {};
  final Map<String, String> _moduleIdToUri = {};
  final Map<String, String> _uriToModuleId = {};

  void addImportElement(ImportElement imp) {
    if (imp.importedLibrary == null) {
      return;
    }
    final modId = imp.importedLibrary.identifier;
    this._moduleIdToUri[modId] = imp.uri;
    this._uriToModuleId[imp.uri] = modId;
    if (imp.prefix != null) {
      this._moduleIdToPrefix[modId] = imp.prefix.name;
      imp.namespace.definedNames.forEach((key, value) {
        _fullNameToPrefix[fullName(value)] = imp.prefix.name;
      });
    }
  }

  String lookupOptionalType() {
    final modIdCandidates =
        quiverPackageUris.where((packageUri) => _uriToModuleId[packageUri] != null);
    if (modIdCandidates.isEmpty) {
      throw CodegenException(
          "Cannot reference type 'Optional'. Please import the package '${quiverPackageUris[0]}', "
          'either unqualified or qualified.');
    } else {
      final modId = modIdCandidates.first;
      final prefix = _moduleIdToPrefix[modId];
      if (prefix == null) {
        return 'Optional';
      } else {
        return prefix + '.Optional';
      }
    }
  }
}

typedef MkType<T> = T Function(DartType ty);

enum FieldNameConfig { Public, Private }

class CommonFieldModel<TypeModel> {
  final String name;
  final String internalName;
  final TypeModel type;

  CommonFieldModel._({
    @required this.name,
    @required this.type,
    @required this.internalName,
  });

  factory CommonFieldModel(FieldElement field, MkType<TypeModel> mkType, FieldNameConfig fieldCfg) {
    try {
      final ty = mkType(field.type);
      String name, internalName;
      switch (fieldCfg) {
        case FieldNameConfig.Public:
          {
            if (field.name.startsWith('_')) {
              throw CodegenException('fieldname must not start with an underscore');
            }
            name = field.name;
            internalName = '_' + name;
            break;
          }
        case FieldNameConfig.Private:
          {
            if (!field.name.startsWith('_')) {
              throw CodegenException('fieldname must start with an underscore');
            }
            name = field.name.substring(1);
            internalName = field.name;
            break;
          }
      }
      return CommonFieldModel._(
        name: name,
        internalName: internalName,
        type: ty,
      );
    } on CodegenException catch (e) {
      e.fieldName = field.name;
      rethrow;
    }
  }
}

typedef MkField<T> = T Function(FieldElement f, ImportModel imports);

@immutable
class CodgenConfig {
  final bool genToString;
  final bool genEqHashCode;

  const CodgenConfig({bool toString, bool eqHashCode})
      : genToString = toString ?? true,
        genEqHashCode = eqHashCode ?? true;
}

class CommonClassModel<FieldModel> {
  final String mixinName;
  final String className;
  final String baseClassName;
  final List<FieldModel> fields;
  final List<String> typeArgs;
  final CodgenConfig config;

  String get factoryName {
    return mixinName + 'Factory';
  }

  CommonClassModel.mk({
    @required this.mixinName,
    @required this.className,
    @required this.baseClassName,
    @required this.fields,
    @required this.typeArgs,
    @required this.config,
  });

  factory CommonClassModel(
    ClassElement clazz,
    MkField<FieldModel> mkField,
    ConstantReader reader,
  ) {
    try {
      // build a map of the qualified imports, mapping module identifiers to import prefixes
      final lib = clazz.library;
      final imports = ImportModel();
      lib.imports.forEach((imp) {
        imports.addImportElement(imp);
      });

      final mixinName = clazz.name;
      final List<String> typeArgs = clazz.typeParameters.map((param) => param.name).toList();
      final className = '_' + mixinName;
      final baseName = className + 'Base';
      final fields = <FieldModel>[];

      for (var field in clazz.fields) {
        if (field.name != 'hashCode' && !field.isStatic) {
          final msgPrefix = "Invalid getter '${field.name}' for data class '$mixinName'";
          if (field.getter == null) {
            throw Exception('$msgPrefix: field must have a getter');
          } else if (field.setter != null) {
            throw Exception('$msgPrefix: field must not have a setter');
          } else {
            if (field.getter.isAbstract) {
              fields.add(mkField(field, imports));
            }
          }
        }
      }

      // The fields are from the SumDataType class.
      final genToString = reader.objectValue.getField('genToString').toBoolValue();
      final genEqHashCode = reader.objectValue.getField('genEqHashCode').toBoolValue();
      final annotation = CodgenConfig(toString: genToString, eqHashCode: genEqHashCode);
      return CommonClassModel.mk(
        mixinName: mixinName,
        baseClassName: baseName,
        className: className,
        fields: fields,
        typeArgs: typeArgs,
        config: annotation,
      );
    } on CodegenException catch (e) {
      e.className = clazz.name;
      rethrow;
    }
  }

  String get mixinType {
    return this.mixinName + this.typeArgsWithParens;
  }

  String get typeArgsWithParens {
    if (this.typeArgs.isNotEmpty) {
      return '<' + this.typeArgs.join(',') + '>';
    } else {
      return '';
    }
  }
}

String eqImpl(String className, List<String> fieldNames) {
  const other = r'__other$';
  var fieldsEq = 'true';
  if (fieldNames.isNotEmpty) {
    fieldsEq = fieldNames.map((name) => 'this.$name == $other.$name').join(' && ');
  }
  return '''@override
    bool operator ==(Object $other) {
      if (identical(this, $other)) return true;
      if (this.runtimeType != $other.runtimeType) return false;
      return $other is $className && $fieldsEq;
    }''';
}

String hashCodeImpl(List<String> fieldNames) {
  if (fieldNames.isEmpty) {
    return '''@override
      int get hashCode => 0;
    ''';
  }
  const result = r'__result$';
  final updates =
      fieldNames.map((name) => '$result = 37 * $result + this.$name.hashCode;').join('\n');
  return '''@override
    int get hashCode {
      var $result = 17;
      $updates
      return $result;
    }''';
}
