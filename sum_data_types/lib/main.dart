import 'package:meta/meta.dart';

export 'package:meta/meta.dart' show immutable, required;

//
// Data classes
//
@immutable
class DataClass {
  final bool genToString;
  final bool genEqHashCode;

  const DataClass({bool? toString, bool? eqHashCode})
      : genToString = toString ?? true,
        genEqHashCode = eqHashCode ?? true;
}

//
// Sum types
//
@immutable
class SumType {
  final bool genToString;
  final bool genEqHashCode;

  const SumType({bool? toString, bool? eqHashCode})
      : genToString = toString ?? true,
        genEqHashCode = eqHashCode ?? true;
}

@immutable
class Unit {
  const Unit();

  @override
  bool operator ==(dynamic other) => other.runtimeType == runtimeType;

  @override
  int get hashCode => 1;
}
