// @dart=2.12
import 'package:sum_data_types/main.dart';
import 'package:quiver/core.dart';

part 'nnbd.g.dart';

void main() {}

@DataClass()
mixin Container<T> on _ContainerBase<T> {
  String get id;
  T get payload;
}

@SumType()
mixin Either<A, B> on _EitherBase<A, B> {
  A? get _left;
  B? get _right;
}

@SumType()
mixin Something on _SomethingBase {
  String? get _string;
  // dynamic is already nullable
  dynamic get _unknown;
}

void foo(Either<String, int> x) {
  x.iswitch(left: (s) => print('String: ' + s), right: (i) => print('int: ' + i.toString()));
}
