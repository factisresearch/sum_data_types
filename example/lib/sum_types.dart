import 'package:sum_data_types/main.dart';
import 'package:example/types.dart' as ty;
import 'package:example/data_classes.dart';
import 'package:quiver/core.dart';
import 'package:kt_dart/collection.dart';
import 'package:test/test.dart';

part 'sum_types.g.dart';

void main() {
  final nothing = SomethingFactory.nothing();
  final userPaul = UserFactory.make(
    name: "Paul",
    friends: KtList.empty(),
    address: new ty.Address(),
    friendsAddresses: KtList.empty(),
    foo: EitherFactory.makeRight(42),
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
        'address: SomeAddress, workAddress: Optional { absent }, friendsAddresses: [], '
        'foo: Right(42)))'
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

/* FIXME: we need this test!
@SumType()
mixin Empty implements _EmptyBase {

}
*/

@SumType()
mixin Something<T> implements _SomethingBase<T> {
  Unit get _nothing;
  User get _user;
  Optional<ty.Address> get _address;
  Something get _something;
  T get _param;
}

/*
// generated code
abstract class SomethingFactory {
  static Something<T> nothing<T>() {
    return _Something(nothing: const Unit());
  }
  static Something<T> user<T>(User x) {
    return _Something(user: x);
  }
  static Something<T> address<T>(Optional<ty.Address> x) {
    return _Something(address: x);
  }
  static Something<T> something<T>(Something x) {
    return _Something(something: x);
  }
  static Something<T> param<T>(T x) {
    return _Something(param: x);
  }
}

abstract class _SomethingBase<T> {
  Optional<Unit> get nothing;
  Optional<User> get user;
  Optional<Optional<ty.Address>> get address;
  Optional<Something> get something;
  Optional<T> get param;

  __T iswitch<__T>({
    @required __T Function() nothing,
    @required __T Function(User) user,
    @required __T Function(Optional<ty.Address>) address,
    @required __T Function(Something) something,
    @required __T Function(T) param,
  });
  __T iswitcho<__T>({
    __T Function() nothing,
    __T Function(User) user,
    __T Function(Optional<ty.Address>) address,
    __T Function(Something) something,
    __T Function(T) param,
    @required __T Function() otherwise,
  });

  const _SomethingBase();
}

class _Something<T> extends _SomethingBase<T> with Something<T> {

  final Unit _nothing;
  final User _user;
  final Optional<ty.Address> _address;
  final Something _something;
  final T _param;

  Optional<Unit> get nothing {
    return Optional.fromNullable(this._nothing);
  }

  Optional<User> get user {
    return Optional.fromNullable(this._user);
  }

  Optional<Optional<ty.Address>> get address {
    return Optional.fromNullable(this._address);
  }
  Optional<Something> get something {
    return Optional.fromNullable(this._something);
  }
  Optional<T> get param {
    return Optional.fromNullable(this._param);
  }

  _Something({
    Unit nothing,
    User user,
    Optional<ty.Address> address,
    Something something,
    T param,
  }) : assert(
         (nothing != null && user == null && address == null && something == null) ||
         (nothing == null && user != null && address == null && something == null) ||
         (nothing == null && user == null && address != null && something == null) ||
         (nothing == null && user == null && address == null && something != null)
       ),
       this._nothing = nothing,
       this._user = user,
       this._address = address,
       this._something = something,
       this._param = param;

  @override
  __T iswitch<__T>({
    @required __T Function() nothing,
    @required __T Function(User) user,
    @required __T Function(Optional<ty.Address>) address,
    @required __T Function(Something) something,
    @required __T Function(T) param,
  }) {
    if (this._nothing != null) {
      if (nothing != null) {
        return nothing();
      } else {
        throw new ArgumentError.notNull("nothing");
      }
    } else if (this._user != null) {
      if (user != null) {
        return user(this._user);
      } else {
        throw new ArgumentError.notNull("user");
      }
    } else if (this._address != null) {
      if (address != null) {
        return address(this._address);
      } else {
        throw new ArgumentError.notNull("address");
      }
    } else if (this._something != null) {
      if (something != null) {
        return something(this._something);
      } else {
        throw new ArgumentError.notNull("something");
      }
    } else if (this._param != null) {
      if (param != null) {
        return param(this._param);
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
    __T Function(T) param,
    @required __T Function() otherwise,
  }) {
    return iswitch(
      nothing: nothing ?? otherwise,
      user: user ?? (Object _) => otherwise(),
      address: address ?? (Object _) => otherwise(),
      something: something ?? (Object _) => otherwise(),
      param: param ?? (Object _) => otherwise(),
    );
  }

  @override
  bool operator ==(
    dynamic other,
  ) {
    return other.runtimeType == runtimeType &&
        other._nothing == this._nothing &&
        other._user == this._user &&
        other._address == this._address &&
        other._something == this._something &&
        other._param == this._param;
  }

  @override
  int get hashCode {
    var result = 17;
    result = 37 * result + this._nothing.hashCode;
    result = 37 * result + this._user.hashCode;
    result = 37 * result + this._address.hashCode;
    result = 37 * result + this._something.hashCode;
    result = 37 * result + this._param.hashCode;
    return result;
  }

  @override
  String toString() {
    final ctor = iswitch(
      nothing: () => "nothing()",
      user: (value) => "user($value)",
      address: (value) => "address($value)",
      something: (value) => "something($value)",
      param: (value) => "param($value)",
    );
    return "Something.$ctor";
  }
}
*/
