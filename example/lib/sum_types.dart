import 'package:sum_data_types/main.dart';
import 'package:example/types.dart' as ty;
import 'package:example/data_types.dart';
import 'package:quiver/core.dart';
import 'package:kt_dart/collection.dart';
import 'package:test/test.dart';

void main() {
  final nothing = SomethingFactory.nothing();
  final userPaul = UserFactory.make(
    name: "Paul",
    friends: KtList.empty(),
    address: new ty.Address(),
    friendsAddresses: KtList.empty(),
  );
  final user = SomethingFactory.user(userPaul);
  final address = SomethingFactory.address(Optional.of(new ty.Address()));
  final address2 = SomethingFactory.address(Optional.of(new ty.Address()));
  final something = SomethingFactory.something(user);

  test("equals", () {
    expect(address == null, isFalse);
    expect(address == something, isFalse);
    expect(address, equals(address));
    expect(address == address2, isTrue);
    expect(nothing == user, isFalse);
    expect(nothing == address, isFalse);
    expect(nothing == something, isFalse);
  });

  test("hashCode", () {
    expect(address.hashCode == something.hashCode, isFalse);
    expect(address.hashCode, equals(address2.hashCode));
  });

  test("toString", () {
    expect(address.toString(), equals(address2.toString()));
    expect(
      nothing.toString(),
      equals(
        'Something.nothing()'
      )
    );
    expect(
      user.toString(),
      equals(
        'Something.user(User(name: Paul, age: Optional { absent }, friends: [], '
        'address: SomeAddress, workAddress: Optional { absent }, friendsAddresses: []))'
      )
    );
    expect(
      address.toString(),
      equals(
        'Something.address(Optional { value: SomeAddress })'
      )
    );
    expect(
      something.toString(),
      equals(
        'Something.something(${user.toString()})'
      )
    );
  });

  test("no strange error", () {
    final nothing = SomethingFactory.nothing();
    expect(() => nothing.iswitcho(), throwsA(TypeMatcher<ArgumentError>()));
  });
}

@SumType([
  Case<void>(name: "nothing"),
  Case<User>(name: "user"),
  Case<Optional<ty.Address>>(name: "address"),
  Case<Something>(name: "something"),
])
mixin Something implements _SomethingBase {

}

// generated code
abstract class SomethingFactory {
  static Something nothing() {
    return _Something(nothing: const Unit());
  }

  static Something user(User x) {
    return _Something(user: x);
  }
  static Something address(Optional<ty.Address> x) {
    return _Something(address: x);
  }
  static Something something(Something x) {
    return _Something(something: x);
  }
}

abstract class _SomethingBase {
  __T iswitch<__T>({
    @required __T Function() nothing,
    @required __T Function(User) user,
    @required __T Function(Optional<ty.Address>) address,
    @required __T Function(Something) something,
  });
  __T iswitcho<__T>({
    __T Function() nothing,
    __T Function(User) user,
    __T Function(Optional<ty.Address>) address,
    __T Function(Something) something,
    @required __T Function() otherwise,
  });

  const _SomethingBase();
}

class _Something extends _SomethingBase with Something {

  final Unit nothing;
  final User user;
  final Optional<ty.Address> address;
  final Something something;

  const _Something({
    this.nothing,
    this.user,
    this.address,
    this.something
  }) : assert(
         (nothing != null && user == null && address == null && something == null) ||
         (nothing == null && user != null && address == null && something == null) ||
         (nothing == null && user == null && address != null && something == null) ||
         (nothing == null && user == null && address == null && something != null)
       );

  @override
  __T iswitch<__T>({
    @required __T Function() nothing,
    @required __T Function(User) user,
    @required __T Function(Optional<ty.Address>) address,
    @required __T Function(Something) something,
  }) {
    if (this.nothing != null) {
      if (nothing != null) {
        return nothing();
      } else {
        throw new ArgumentError.notNull("nothing");
      }
    } else if (this.user != null) {
      if (user != null) {
        return user(this.user);
      } else {
        throw new ArgumentError.notNull("user");
      }
    } else if (this.address != null) {
      if (address != null) {
        return address(this.address);
      } else {
        throw new ArgumentError.notNull("address");
      }
    } else if (this.something != null) {
      if (something != null) {
        return something(this.something);
      } else {
        throw new ArgumentError.notNull("something");
      }
    } else {
      throw StateError("an instance of Something has no case selected");
    }
  }

  @override
  __T iswitcho<__T>({
    __T Function() nothing,
    __T Function(User) user,
    __T Function(Optional<ty.Address>) address,
    __T Function(Something) something,
    @required __T Function() otherwise,
  }) {
    __T _otherwise(Object _) => otherwise();
    return iswitch(
      nothing: nothing ?? otherwise,
      user: user ?? _otherwise,
      address: address ?? _otherwise,
      something: something ?? _otherwise,
    );
  }

  @override
  bool operator ==(
    dynamic other,
  ) {
    return other.runtimeType == runtimeType &&
        other.nothing == nothing &&
        other.user == user &&
        other.address == address &&
        other.something == something;
  }

  @override
  int get hashCode {
    var result = 17;
    result = 37 * result + nothing.hashCode;
    result = 37 * result + user.hashCode;
    result = 37 * result + address.hashCode;
    result = 37 * result + something.hashCode;
    return result;
  }

  @override
  String toString() {
    final ctor = iswitch(
      nothing: () => "nothing()",
      user: (value) => "user($value)",
      address: (value) => "address($value)",
      something: (value) => "something($value)",
    );
    return "Something.$ctor";
  }
}
