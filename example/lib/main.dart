import 'package:data_classes/data_classes.dart';
import 'package:example/types.dart' as ty;
import 'package:quiver/core.dart';
import 'package:kt_dart/collection.dart';
import "package:test/test.dart";

part 'main.g.dart';

void main() {
  final userBob = User(
    name: "Bob",
    friends: KtList.empty(),
    address: new ty.Address(),
    age: 31,
    friendsAddresses: KtList.empty(),
  );
  final userPaul = User(
    name: "Paul",
    friends: KtList.of(userBob),
    address: new ty.Address(),
    friendsAddresses: KtList.empty(),
  );
  final userSarah = userPaul.copyWith(name: "Sarah");
  final userSarah2 = User(
    name: "Sarah",
    friends: KtList.of(userBob),
    address: new ty.Address(),
    friendsAddresses: KtList.empty()
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
      equals(
        'User(name: Sarah, age: Optional { absent }, friends: '
        '[User(name: Bob, age: Optional { value: 31 }, friends: [], address: SomeAddress, '
        'workAddress: Optional { absent }, friendsAddresses: [])], '
        'address: SomeAddress, workAddress: Optional { absent }, friendsAddresses: [])'
      )
    );
  });
}

@DataClass()
mixin User$ on _UserBase {
  String get name;
  Optional<int> get age;
  KtList<User$> get friends;
  ty.Address get address;
  Optional<ty.Address> get workAddress;
  KtList<ty.Address> get friendsAddresses;

  int numerOfFriends() {
    return this.friendsAddresses.size;
  }
}

/*
// START generated code
abstract class _UserBase {
 User copyWith({
    String name,
    Optional<int> age,
    List<User> friends,
    ty.Address address
 });
}

class User extends _UserBase with User$ {
  final String name;
  final Optional<int> age;
  final List<User> friends;
  final ty.Address address;
  final Optional<ty.Address> workAddress;
  final List<ty.Address> friendsAddresses;

  factory User({
    @required String name,
    int age,
    @required List<User> friends,
    @required ty.Address address,
    ty.Address workAddress,
    @required List<ty.Address> friendsAddresses,
  })  {
    return User.make(
      name: name,
      age: age == null ? Optional.absent() : Optional.of(age),
      friends: friends,
      address: address,
      workAddress: workAddress == null ? Optional.absent() : Optional.of(workAddress),
      friendsAddresses: friendsAddresses
    );
  }

  // We cannot have a const constructor because of https://github.com/dart-lang/sdk/issues/37810
  User.make({
    @required this.name,
    @required this.age,
    @required this.friends,
    @required this.address,
    @required this.workAddress,
    @required this.friendsAddresses,
  }) {
    assert(name != null);
    assert(friends != null);
    assert(address != null);
    assert(age != null);
    assert(workAddress != null);
    assert(friendsAddresses != null);
  }

  User copyWith({
    String name,
    Optional<int> age,
    List<User> friends,
    ty.Address address,
    ty.Address workAddress,
    List<ty.Address> friendsAddresses,
  }) {
    return User.make(
      name: name == null ? this.name : name,
      age: age == null ? this.age : age,
      friends: friends == null ? this.friends : friends,
      address: address == null ? this.address : address,
      workAddress: workAddress == null ? this.workAddress : workAddress,
      friendsAddresses: friendsAddresses == null ? this.friendsAddresses : friendsAddresses,
    );
  }

  bool operator ==(Object other) {
    if (other == null) {
      return false;
    }
    if (identical(this, other)) {
      return true;
    }
    return (
      other is User &&
      runtimeType == other.runtimeType &&
        name == other.name &&
        age == other.age &&
        friends == other.friends &&
        address == other.address
    );
  }

  int get hashCode => hashList([
        name,
        age,
        friends,
        address,
      ]);

  String toString() {
    return 'User(\n'
        '  name: $name\n'
        '  age: $age\n'
        '  friends: $friends\n'
        '  adress: $address\n'
        ')';
  }
}
// END generated code
*/
