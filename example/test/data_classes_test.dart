// ignore_for_file: library_private_types_in_public_api

import 'package:kt_dart/collection.dart';
import 'package:quiver/core.dart';
import 'package:sum_data_types/sum_data_types.dart';
import 'package:test/test.dart';

import 'nnbd.dart';
import 'types.dart' as ty;

part 'data_classes_test.g.dart';

void main() {
  final userBob = UserFactory.make(
    name: 'Bob',
    friends: const KtList.empty(),
    address: ty.Address(),
    age: 31,
    friendsAddresses: const KtList.empty(),
    foo: EitherFactory.left('foo'),
  );
  final userPaul = UserFactory.make(
    name: 'Paul',
    friends: KtList.of(userBob),
    address: ty.Address(),
    friendsAddresses: const KtList.empty(),
    foo: EitherFactory.right(42),
  );
  final userSarah = userPaul.copyWith(name: 'Sarah');
  final userSarah2 = UserFactory.make(
    name: 'Sarah',
    friends: KtList.of(userBob),
    address: ty.Address(),
    friendsAddresses: const KtList.empty(),
    foo: EitherFactory.right(42),
  );

  test('equals', () {
    expect(userSarah == userPaul, isFalse);
    expect(userSarah, equals(userSarah));
    expect(userSarah == userSarah2, isTrue);
  });

  test('hashCode', () {
    expect(userSarah.hashCode == userPaul.hashCode, isFalse);
    expect(userSarah.hashCode, equals(userSarah2.hashCode));
  });

  test('toString', () {
    expect(userSarah.toString(), equals(userSarah2.toString()));
    expect(
        userSarah.toString(),
        equals('User(name: Sarah, age: Optional { absent }, friends: '
            '[User(name: Bob, age: Optional { value: 31 }, friends: [], address: SomeAddress, '
            'workAddress: Optional { absent }, friendsAddresses: [], foo: Either.left(foo))], '
            'address: SomeAddress, workAddress: Optional { absent }, friendsAddresses: [], '
            'foo: Either.right(42))'));
  });

  test('extra getters', () {
    expect(userSarah.fooDisplay, equals('42'));
  });

  test('container', () {
    final c = ContainerFactory.make(payload: 'foo', id: 'blub');
    expect(c.toString(), 'Container(id: blub, payload: foo)');
  });

  test('customToString', () {
    final c = CustomToStringFactory.make(bar: '1', foo: '2');
    expect(c.toString(), equals('custom'));
  });

  test('customEq', () {
    final c = CustomEqFactory.make(bar: '1', foo: '2');
    expect(c == c, equals(false));
    expect(c.hashCode, equals(42));
  });
}

@DataClass()
mixin User on _UserBase {
  String get name;
  Optional<int> get age;
  KtList<User> get friends;
  ty.Address get address;
  Optional<ty.Address> get workAddress;
  KtList<ty.Address> get friendsAddresses;
  Either<String, int> get foo;

  int numerOfFriends() {
    return this.friendsAddresses.size;
  }

  String get fooDisplay => foo.iswitch(
        left: (x) => x,
        right: (x) => x.toString(),
      );
}

@DataClass()
mixin NullaryType {}

@DataClass(toString: false)
mixin CustomToString on _CustomToStringBase {
  String get foo;
  String get bar;

  @override
  String toString() {
    return 'custom';
  }
}

@DataClass(eqHashCode: false)
mixin CustomEq on _CustomEqBase {
  String get foo;
  String get bar;

  @override
  bool operator ==(Object other) {
    return false;
  }

  @override
  int get hashCode {
    return 42;
  }
}
