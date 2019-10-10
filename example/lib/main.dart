import 'package:data_classes/data_classes.dart';
import 'package:example/types.dart' as ty;
import 'package:quiver/core.dart';

//part 'main.g.dart';

void main() {
  var userBob = User$(
    name: "Bob", friends: List(), address: new ty.Address(), age: 31, friendsAddresses: [],
  );
  var userPaul = User$(
    name: "Paul", friends: [userBob], address: new ty.Address(), friendsAddresses: [],
  );
  var userSarah = userPaul.copyWith(name: "Sarah");
  print(userSarah);
}

@DataClass()
mixin User on _UserBase {
  String get name;
  Optional<int> get age;
  List<User> get friends; // FIXME: would like to use User here, but then the type becomes dynamic
  ty.Address get address;
  Optional<ty.Address> get workAddress;
  List<ty.Address> get friendsAddresses;

  int foo() {
    return this.name.length;
  }
}

// START generated code
User User$({
  @required String name,
  int age,
  @required List<User> friends,
  @required ty.Address address,
  ty.Address workAddress,
  @required List<ty.Address> friendsAddresses,
}) {
  return _UserImpl(
    name: name,
    age: age,
    friends: friends,
    address: address,
    workAddress: workAddress,
    friendsAddresses: friendsAddresses,
  );
}

abstract class _UserBase {
 _UserImpl copyWith({
    String name,
    Optional<int> age,
    List<_UserImpl> friends,
    ty.Address address
 });
}

class _UserImpl extends _UserBase with User {
  final String name;
  final Optional<int> age;
  final List<_UserImpl> friends;
  final ty.Address address;
  final Optional<ty.Address> workAddress;
  final List<ty.Address> friendsAddresses;

  factory _UserImpl({
    @required String name,
    int age,
    @required List<_UserImpl> friends,
    @required ty.Address address,
    ty.Address workAddress,
    @required List<ty.Address> friendsAddresses,
  })  {
    return _UserImpl.make(
      name: name,
      age: age == null ? Optional.absent() : Optional.of(age),
      friends: friends,
      address: address,
      workAddress: workAddress == null ? Optional.absent() : Optional.of(workAddress),
      friendsAddresses: friendsAddresses
    );
  }

  // We cannot have a const constructor because of https://github.com/dart-lang/sdk/issues/37810
  _UserImpl.make({
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

  _UserImpl copyWith({
    String name,
    Optional<int> age,
    List<_UserImpl> friends,
    ty.Address address,
    ty.Address workAddress,
    List<ty.Address> friendsAddresses,
  }) {
    return _UserImpl.make(
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
      other is _UserImpl &&
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
