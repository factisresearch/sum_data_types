import 'package:analyzer/dart/element/element.dart';
import 'package:analyzer/dart/element/type.dart';

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
