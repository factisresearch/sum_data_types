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
      loc = " for mixin ${className} and field ${fieldName}";
    } else if (className != null) {
      loc = " for mixin ${className}";
    }
    var genName = "";
    if (generatorName != null) {
      genName = " @${generatorName}";
    }
    return "Error generating${genName} code${loc}: $message";
  }
}

// Returns a potential qualified access string for the type, without type arguments
String qualifyType(DartType ty, ImportModel imports) {
    final tyLib = ty.element.library;
    final prefixOrNull = imports.importPrefixOrNull(tyLib);
    final prefix = (prefixOrNull != null) ? (prefixOrNull + ".") : "";
    return "${prefix}${ty.name}";
}

// Returns a textual representation of the given type, including generic types
// and import prefixes.
String computeTypeRepr(DartType ty, ImportModel imports) {
  if (ty is FunctionType) {
    throw CodegenException("function types are not supported");
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

typedef MkType<T> = T Function(DartType ty);

class CommonFieldModel<TypeModel> {

  final String name;
  final TypeModel type;

  CommonFieldModel._({
    @required this.name,
    @required this.type,
  });

  factory CommonFieldModel(FieldElement field, MkType mkType) {
    try {
      final ty = mkType(field.type);
      return CommonFieldModel._(
        name: field.name,
        type: ty,
      );
    } on CodegenException catch (e) {
      e.fieldName = field.name;
      throw e;
    }
  }
}

typedef MkField<T> = T Function(FieldElement f, ImportModel imports);

class CommonClassModel<FieldModel> {

  final String mixinName;
  final String className;
  final String baseClassName;
  final List<FieldModel> fields;

  String get factoryName {
    return mixinName + "Factory";
  }

  CommonClassModel.mk({
    @required this.mixinName,
    @required this.className,
    @required this.baseClassName,
    @required this.fields,
  });

  factory CommonClassModel(ClassElement clazz, MkField<FieldModel> mkField) {
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
          fields.add(mkField(field, imports));
        }
      }

      return CommonClassModel.mk(
        mixinName: mixinName,
        baseClassName: baseName,
        className: className,
        fields: fields
      );
    } on CodegenException catch (e) {
      e.className = clazz.name;
      throw e;
    }
  }
}
