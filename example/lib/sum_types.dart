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

//@SumType()
mixin Something<T> implements _SomethingBase<T> {
  Unit get _nothing;
  User get _user;
  Optional<ty.Address> get _address;
  Something get _something;
  T get _param;
}

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
    if (this._nothing != null) {
      return Optional.of(this._nothing);
    } else {
      return Optional.absent();
    }
  }

  Optional<User> get user {
    if (this._user != null) {
      return Optional.of(this._user);
    } else {
      return Optional.absent();
    }
  }

  Optional<Optional<ty.Address>> get address {
    if (this._address != null) {
      return Optional.of(this._address);
    } else {
      return Optional.absent();
    }
  }
  Optional<Something> get something {
    if (this._something != null) {
      return Optional.of(this._something);
    } else {
      return Optional.absent();
    }
  }
  Optional<T> get param {
    if (this._param != null) {
      return Optional.of(this._param);
    } else {
      return Optional.absent();
    }
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
    __T _otherwise(Object _) => otherwise();
    return iswitch(
      nothing: nothing ?? otherwise,
      user: user ?? _otherwise,
      address: address ?? _otherwise,
      something: something ?? _otherwise,
      param: param ?? _otherwise,
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
        other.something == something &&
        other.param == param;
  }

  @override
  int get hashCode {
    var result = 17;
    result = 37 * result + nothing.hashCode;
    result = 37 * result + user.hashCode;
    result = 37 * result + address.hashCode;
    result = 37 * result + something.hashCode;
    result = 37 * result + param.hashCode;
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
