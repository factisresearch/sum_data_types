export 'package:meta/meta.dart' show immutable, required;

/// Annotation to use to generate a data-class
class DataClass {
  final bool genToString;
  final bool genEqHashCode;

  const DataClass({bool? toString, bool? eqHashCode})
      : genToString = toString ?? true,
        genEqHashCode = eqHashCode ?? true;
}

/// Annotation to use to generate a sum-type
class SumType {
  final bool genToString;
  final bool genEqHashCode;

  const SumType({bool? toString, bool? eqHashCode})
      : genToString = toString ?? true,
        genEqHashCode = eqHashCode ?? true;
}

/// Used for alternatives in sum-types that don't take a parameter.
class Unit {
  const Unit();

  @override
  bool operator ==(Object other) => other.runtimeType == runtimeType;

  @override
  int get hashCode => 1;
}
