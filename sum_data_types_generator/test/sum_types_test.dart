// ignore_for_file: library_private_types_in_public_api, unused_element

import 'package:kt_dart/collection.dart';
// Import quiver qualified to test wether the generated code uses the right prefix
import 'package:quiver/core.dart' as quiv;
import 'package:sum_data_types/sum_data_types.dart';
import 'package:test/test.dart';

import './data_classes_test.dart';
import './nnbd.dart';
import './types.dart' as ty;

part 'sum_types_test.g.dart';

void main() {
  final nothing = SomethingFactory.nothing<String>();
  final userPaul = UserFactory.make(
    name: 'Paul',
    friends: KtList.empty(),
    address: ty.Address(),
    friendsAddresses: KtList.empty(),
    foo: EitherFactory.right(42),
  );
  final user = SomethingFactory.user<String>(userPaul);
  final address = SomethingFactory.address<String>(quiv.Optional.of(ty.Address()));
  final address2 = SomethingFactory.address<String>(quiv.Optional.of(ty.Address()));
  final something = SomethingFactory.something<String>(user);

  test('equals', () {
    expect(address == something, isFalse);
    expect(address, equals(address));
    expect(address == address2, isTrue);
    expect(nothing == user, isFalse);
    expect(nothing == address, isFalse);
    expect(nothing == something, isFalse);
  });

  test('hashCode', () {
    expect(address.hashCode == something.hashCode, isFalse);
    expect(address.hashCode, equals(address2.hashCode));
  });

  test('toString', () {
    expect(
      address.toString(),
      equals(address2.toString()),
    );
    expect(
      nothing.toString(),
      equals('Something.nothing'),
    );
    expect(
      user.toString(),
      equals('Something.user(User(name: Paul, age: Optional { absent }, friends: [], '
          'address: SomeAddress, workAddress: Optional { absent }, friendsAddresses: [], '
          'foo: Either.right(42)))'),
    );
    expect(
      address.toString(),
      equals('Something.address(Optional { value: SomeAddress })'),
    );
    expect(
      something.toString(),
      equals('Something.something(${user.toString()})'),
    );
  });

  test('with unknown', () {
    final unknown = WithUnknownFactory.unknown(42);
    expect(
      unknown.toString(),
      equals('WithUnknown.unknown(42)'),
    );
    expect(
      unknown.iswitcho(
        known: (s) => 'known',
        otherwise: () => 'otherwise',
      ),
      equals('otherwise'),
    );
  });

  test('customToString', () {
    final c = CustomToStringFactory.foo('1');
    expect(c.toString(), equals('custom'));
  });

  test('customEq', () {
    final c = CustomEqFactory.foo('1');
    expect(c == c, equals(false));
    expect(c.hashCode, equals(42));
  });
}

@SumType()
mixin WithUnknown on _WithUnknownBase {
  String? get _known;
  // dynamic is already nullable
  dynamic get _unknown;
}

@SumType()
mixin Something<T> implements _SomethingBase<T> {
  Unit? get _nothing;
  User? get _user;
  quiv.Optional<ty.Address>? get _address;
  Something<T>? get _something;
  T? get _param;
}

@SumType(toString: false)
mixin CustomToString on _CustomToStringBase {
  String? get _foo;

  @override
  String toString() {
    return 'custom';
  }
}

@SumType(eqHashCode: false)
mixin CustomEq on _CustomEqBase {
  String? get _foo;

  @override
  bool operator ==(Object other) {
    return false;
  }

  @override
  int get hashCode {
    return 42;
  }
}
