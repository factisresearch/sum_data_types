import 'package:sum_data_types/main.dart';
import 'package:example/types.dart' as ty;
import 'package:quiver/core.dart';
import 'package:kt_dart/collection.dart';
import "package:test/test.dart";

part 'data_classes.g.dart';

void main() {
  final userBob = UserFactory.make(
    name: "Bob",
    friends: KtList.empty(),
    address: ty.Address(),
    age: 31,
    friendsAddresses: KtList.empty(),
    foo: EitherFactory.left("foo"),
  );
  final userPaul = UserFactory.make(
    name: "Paul",
    friends: KtList.of(userBob),
    address: ty.Address(),
    friendsAddresses: KtList.empty(),
    foo: EitherFactory.right(42),
  );
  final userSarah = userPaul.copyWith(name: "Sarah");
  final userSarah2 = UserFactory.make(
    name: "Sarah",
    friends: KtList.of(userBob),
    address: ty.Address(),
    friendsAddresses: KtList.empty(),
    foo: EitherFactory.right(42),
  );

  test("equals", () {
    expect(userSarah == null, isFalse);
    expect(userSarah == userPaul, isFalse);
    expect(userSarah, equals(userSarah));
    expect(userSarah == userSarah2, isTrue);
  });

  test("hashCode", () {
    expect(userSarah.hashCode == userPaul.hashCode, isFalse);
    expect(userSarah.hashCode, equals(userSarah2.hashCode));
  });

  test("toString", () {
    expect(userSarah.toString(), equals(userSarah2.toString()));
    expect(
        userSarah.toString(),
        equals('User(name: Sarah, age: Optional { absent }, friends: '
            '[User(name: Bob, age: Optional { value: 31 }, friends: [], address: SomeAddress, '
            'workAddress: Optional { absent }, friendsAddresses: [], foo: Either.left(foo))], '
            'address: SomeAddress, workAddress: Optional { absent }, friendsAddresses: [], '
            'foo: Either.right(42))'));
  });

  test("container", () {
    final c = ContainerFactory.make(payload: "foo", id: "blub");
    expect(c.toString(), "Container(id: blub, payload: foo)");
  });

  test("customToString", () {
    final c = CustomToStringFactory.make(bar: "1", foo: "2");
    expect(c.toString(), equals("custom"));
  });

  test("customEq", () {
    final c = CustomEqFactory.make(bar: "1", foo: "2");
    expect(c == c, equals(false));
    expect(c.hashCode, equals(42));
  });
}

@DataClass()
mixin Container<T> {
  String get id;
  T get payload;
}

@SumType()
mixin Either<A, B> {
  A get _left;
  B get _right;
}

void foo(Either<String, int> x) {
  x.iswitch(left: (s) => print("String: " + s), right: (i) => print("int: " + i.toString()));
}

@DataClass()
mixin User {
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
}

@DataClass()
mixin NullaryType {}

@DataClass(toString: false)
mixin CustomToString {
  String get foo;
  String get bar;

  String toString() {
    return "custom";
  }
}

@DataClass(eqHashCode: false)
mixin CustomEq {
  String get foo;
  String get bar;

  @override
  bool operator ==(Object other) {
    return false;
  }

  int get hashCode {
    return 42;
  }
}
