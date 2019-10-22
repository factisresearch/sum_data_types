export 'package:meta/meta.dart' show immutable, required;

import 'package:meta/meta.dart';

//
// Data classes
//
@immutable
class DataClass {
  const DataClass();
}

//
// Sum types
//
@immutable
class SumType {
  const SumType();
}

@immutable
class Unit {
  const Unit();

  @override
  bool operator ==(dynamic other) => other.runtimeType == runtimeType;

  @override
  int get hashCode => 1;
}
