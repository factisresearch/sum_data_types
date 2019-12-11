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

/*
// START generated code
abstract class UserFactory {
  static User make({
    @required String name,
    int age,
    @required KtList<User> friends,
    @required ty.Address address,
    ty.Address workAddress,
    @required KtList<ty.Address> friendsAddresses,
  }) {
    return _User.make(
      name: name,
      age: Optional.of(age),
      friends: friends,
      address: address,
      workAddress: Optional.of(workAddress),
      friendsAddresses: friendsAddresses,
    );
  }
}

abstract class _UserBase {
  _User copyWith(
      {String name,
      Optional<int> age,
      KtList<User> friends,
      ty.Address address,
      Optional<ty.Address> workAddress,
      KtList<ty.Address> friendsAddresses});
}

@immutable
class _User extends _UserBase with User {
  final String name;
  final Optional<int> age;
  final KtList<User> friends;
  final ty.Address address;
  final Optional<ty.Address> workAddress;
  final KtList<ty.Address> friendsAddresses;

  // We cannot have a const constructor because of https://github.com/dart-lang/sdk/issues/37810
  _User.make({
    @required this.name,
    @required this.age,
    @required this.friends,
    @required this.address,
    @required this.workAddress,
    @required this.friendsAddresses,
  })  : assert(name != null),
        assert(age != null),
        assert(friends != null),
        assert(address != null),
        assert(workAddress != null),
        assert(friendsAddresses != null);

  _User copyWith(
      {String name,
      Optional<int> age,
      KtList<User> friends,
      ty.Address address,
      Optional<ty.Address> workAddress,
      KtList<ty.Address> friendsAddresses}) {
    return _User.make(
      name: name ?? this.name,
      age: age ?? this.age,
      friends: friends ?? this.friends,
      address: address ?? this.address,
      workAddress: workAddress ?? this.workAddress,
      friendsAddresses: friendsAddresses ?? this.friendsAddresses,
    );
  }

  bool operator ==(Object other) {
    if (identical(this, other)) {
      return true;
    }
    return (other is _User &&
        this.runtimeType == other.runtimeType &&
        this.name == other.name &&
        this.age == other.age &&
        this.friends == other.friends &&
        this.address == other.address &&
        this.workAddress == other.workAddress &&
        this.friendsAddresses == other.friendsAddresses);
  }

  int get hashCode {
    var result = 17;
    result = 37 * result + this.name.hashCode;
    result = 37 * result + this.age.hashCode;
    result = 37 * result + this.friends.hashCode;
    result = 37 * result + this.address.hashCode;
    result = 37 * result + this.workAddress.hashCode;
    result = 37 * result + this.friendsAddresses.hashCode;
    return result;
  }

  String toString() {
    return "User(name: ${this.name}, age: ${this.age}, friends: ${this.friends}, address: ${this.address}, workAddress: ${this.workAddress}, friendsAddresses: ${this.friendsAddresses})";
  }
}

/// This data class has been generated from NullaryType
abstract class NullaryTypeFactory {
  static NullaryType make() {
    return _NullaryType.make();
  }
}

abstract class _NullaryTypeBase {
  _NullaryType copyWith();
}

@immutable
class _NullaryType extends _NullaryTypeBase with NullaryType {
  // We cannot have a const constructor because of https://github.com/dart-lang/sdk/issues/37810
  _NullaryType.make();

  _NullaryType copyWith() {
    return _NullaryType.make();
  }

  bool operator ==(Object other) {
    if (identical(this, other)) {
      return true;
    }
    return (other is _NullaryType &&
        this.runtimeType == other.runtimeType &&
        true);
  }

  int get hashCode {
    var result = 17;

    return result;
  }

  String toString() {
    return "NullaryType()";
  }
}
// END generated code
*/
