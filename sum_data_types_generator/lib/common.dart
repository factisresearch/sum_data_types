import 'package:analyzer/dart/element/element.dart';
import 'package:analyzer/dart/element/type.dart';
import 'package:meta/meta.dart';

class CodegenException with Exception {
  String className;
  String fieldName;
  String generatorName;
  final String message;
  CodegenException(this.message);
  String toString() {
    var loc = "";
    if (className != null && fieldName != null) {
      loc = " for mixin '$className' and field '$fieldName'";
    } else if (className != null) {
      loc = " for mixin '$className'";
    }
    var genName = "";
    if (generatorName != null) {
      genName = " @$generatorName";
    }
    return "Error generating$genName code$loc: $message";
  }
}

bool isType(DartType ty, String name, String packageUri, ImportModel imports) {
  final tyLib = ty.element.library;
  return ty.name == name && imports.importUri(tyLib) == packageUri;
}

const quiverPackageUri = "package:quiver/core.dart";

bool isQuiverOptional(DartType ty, ImportModel imports) {
  return isType(ty, "Optional", quiverPackageUri, imports);
}

// Returns a potential qualified access string for the type, without type arguments
String qualifyType(DartType ty, ImportModel imports) {
    final tyLib = ty.element.library;
    final prefixOrNull = imports.importPrefixOrNull(tyLib);
    final prefix = (prefixOrNull != null) ? (prefixOrNull + ".") : "";
    return "$prefix${ty.name}";
}

// Returns a textual representation of the given type, including generic types
// and import prefixes.
String computeTypeRepr(DartType ty, ImportModel imports) {
  if (ty is FunctionType) {
    throw CodegenException("function types are not supported");
  } else if (ty.isDynamic) {
    return "dynamic";
  } else if (ty is ParameterizedType && ty.typeArguments.isNotEmpty) {
    final base = qualifyType(ty, imports);
    final args = ty.typeArguments.map((tyArg) => computeTypeRepr(tyArg, imports));
    return "$base<${args.join(", ")}>";
  } else {
    return qualifyType(ty, imports);
  }
}

class ImportModel {

  final Map<String, String> _moduleIdToPrefix = Map();
  final Map<String, String> _moduleIdToUri = Map();
  final Map<String, String> _uriToModuleId = Map();

  String importPrefixOrNull(LibraryElement lib) {
    return _moduleIdToPrefix[lib.identifier];
  }

  String importUri(LibraryElement lib) {
    return _moduleIdToUri[lib.identifier];
  }

  void addImportElement(ImportElement imp) {
    final modId = imp.importedLibrary.identifier;
    this._moduleIdToUri[modId] = imp.uri;
    this._uriToModuleId[imp.uri] = modId;
    if (imp.prefix != null) {
      this._moduleIdToPrefix[modId] = imp.prefix.name;
    }
  }

  String lookupOptionalType() {
    final modId = _uriToModuleId[quiverPackageUri];
    if (modId == null) {
      throw CodegenException(
        "Cannot reference type 'Optional'. Please import the package '$quiverPackageUri', "
        "either unqualified or qualified."
      );
    } else {
      final prefix = _moduleIdToPrefix[modId];
      if (prefix == null) {
        return "Optional";
      } else {
        return prefix + ".Optional";
      }
    }
  }
}

typedef MkType<T> = T Function(DartType ty);


enum FieldNameConfig {
  Public, Private
}

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
        case FieldNameConfig.Public: {
          if (field.name.startsWith('_')) {
            throw CodegenException("fieldname must not start with an underscore");
          }
          name = field.name;
          internalName = '_' + name;
          break;
        }
        case FieldNameConfig.Private: {
          if (!field.name.startsWith('_')) {
            throw CodegenException("fieldname must start with an underscore");
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

class CommonClassModel<FieldModel> {

  final String mixinName;
  final String className;
  final String baseClassName;
  final List<FieldModel> fields;
  final List<String> typeArgs;

  String get factoryName {
    return mixinName + "Factory";
  }

  CommonClassModel.mk({
    @required this.mixinName,
    @required this.className,
    @required this.baseClassName,
    @required this.fields,
    @required this.typeArgs,
  });

  factory CommonClassModel(ClassElement clazz, MkField<FieldModel> mkField) {
    try {
      // build a map of the qualified imports, mapping module identifiers to import prefixes
      final lib = clazz.library;
      final imports = ImportModel();
      lib.imports.forEach((imp) {
        imports.addImportElement(imp);
      });

      final mixinName = clazz.name;
      // without the toList(), we get a runtime error
      // "type 'MappedListIterable<TypeParameterElement, String>'
      //  is not a subtype of type 'List<String>'"
      // Looks like darts type system is not sound!
      final List<String> typeArgs = clazz.typeParameters.map((param) => param.name).toList();
      final className = "_" + mixinName;
      final baseName = className + "Base";
      final fields = <FieldModel>[];

      for (var field in clazz.fields) {
        final msgPrefix = "Invalid getter '${field.name}' for data class '$mixinName'";
        if (field.getter == null && !field.isFinal) {
          throw Exception("$msgPrefix: field must have a getter");
        } else if (field.setter != null) {
          throw Exception("$msgPrefix: field must not have a setter");
        } else {
          fields.add(mkField(field, imports));
        }
      }

      return CommonClassModel.mk(
        mixinName: mixinName,
        baseClassName: baseName,
        className: className,
        fields: fields,
        typeArgs: typeArgs,
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
      return '<' + this.typeArgs.join(",") + '>';
    } else {
      return '';
    }
  }
}

String eqImpl(String className, List<String> fieldNames) {
  const other = r'__other$';
  var fieldsEq = "true";
  if (fieldNames.isNotEmpty) {
    fieldsEq = fieldNames.map((name) => 'this.$name == $other.$name').join(" && ");
  }
  return '''@override
    bool operator ==(Object $other) {
      if (identical(this, $other)) {
        return true;
      }
      return (
        $other is $className &&
        this.runtimeType == $other.runtimeType &&
        $fieldsEq
      );
    }''';
}

String hashCodeImpl(List<String> fieldNames) {
  const result = r'__result$';
  final updates = fieldNames.map((name) =>
      "$result = 37 * $result + this.$name.hashCode;").join("\n");
  return '''@override
    int get hashCode {
      var $result = 17;
      $updates
      return $result;
    }''';
}
