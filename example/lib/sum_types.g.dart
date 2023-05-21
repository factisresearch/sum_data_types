// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'sum_types.dart';

// **************************************************************************
// SumTypeGenerator
// **************************************************************************

/// This data class has been generated from WithUnknown
abstract class WithUnknownFactory {
  static WithUnknown known(String x$) => _WithUnknown(known: x$);
  static WithUnknown unknown(dynamic x$) => _WithUnknown(unknown: x$);
}

abstract class _WithUnknownBase {
  const _WithUnknownBase();
  quiv.Optional<String> get known;
  quiv.Optional<dynamic> get unknown;
  __T$ iswitch<__T$>(
      {required __T$ Function(String) known,
      required __T$ Function(dynamic) unknown});
  __T$ iswitcho<__T$>({
    __T$ Function(String)? known,
    __T$ Function(dynamic)? unknown,
    required __T$ Function() otherwise,
  });
}

@immutable
class _WithUnknown extends _WithUnknownBase with WithUnknown {
  @override
  final String? _known;
  @override
  final dynamic _unknown;

  @override
  quiv.Optional<String> get known =>
      quiv.Optional<String>.fromNullable(this._known);
  @override
  quiv.Optional<dynamic> get unknown =>
      quiv.Optional<dynamic>.fromNullable(this._unknown);

  const _WithUnknown({
    String? known,
    dynamic unknown,
  })  : assert((known != null && unknown == null) ||
            (known == null && unknown != null)),
        this._known = known,
        this._unknown = unknown;

  @override
  __T$ iswitch<__T$>({
    required __T$ Function(String) known,
    required __T$ Function(dynamic) unknown,
  }) {
    final known$ = this._known;
    final unknown$ = this._unknown;
    if (known$ != null) {
      return known(known$);
    } else if (unknown$ != null) {
      return unknown(unknown$);
    } else {
      throw StateError('an instance of WithUnknown has no case selected');
    }
  }

  @override
  __T$ iswitcho<__T$>({
    __T$ Function(String)? known,
    __T$ Function(dynamic)? unknown,
    required __T$ Function() otherwise,
  }) {
    return iswitch(
      known: known ?? (String _) => otherwise(),
      unknown: unknown ?? (dynamic _) => otherwise(),
    );
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    if (this.runtimeType != other.runtimeType) return false;
    return other is _WithUnknown &&
        this._known == other._known &&
        this._unknown == other._unknown;
  }

  @override
  int get hashCode {
    var result = 17;
    result = 37 * result + this._known.hashCode;
    result = 37 * result + this._unknown.hashCode;
    return result;
  }

  @override
  String toString() {
    final x$ = iswitch(
      known: (String x$) => 'known(${x$})',
      unknown: (dynamic x$) => 'unknown(${x$})',
    );
    return 'WithUnknown.${x$}';
  }
}

/// This data class has been generated from Something
abstract class SomethingFactory {
  static Something<T> nothing<T>() => _Something(nothing: const Unit());
  static Something<T> user<T>(User x$) => _Something(user: x$);
  static Something<T> address<T>(quiv.Optional<ty.Address> x$) =>
      _Something(address: x$);
  static Something<T> something<T>(Something<T> x$) =>
      _Something(something: x$);
  static Something<T> param<T>(T x$) => _Something(param: x$);
}

abstract class _SomethingBase<T> {
  const _SomethingBase();
  quiv.Optional<Unit> get nothing;
  quiv.Optional<User> get user;
  quiv.Optional<quiv.Optional<ty.Address>> get address;
  quiv.Optional<Something<T>> get something;
  quiv.Optional<T> get param;
  __T$ iswitch<__T$>(
      {required __T$ Function() nothing,
      required __T$ Function(User) user,
      required __T$ Function(quiv.Optional<ty.Address>) address,
      required __T$ Function(Something<T>) something,
      required __T$ Function(T) param});
  __T$ iswitcho<__T$>({
    __T$ Function()? nothing,
    __T$ Function(User)? user,
    __T$ Function(quiv.Optional<ty.Address>)? address,
    __T$ Function(Something<T>)? something,
    __T$ Function(T)? param,
    required __T$ Function() otherwise,
  });
}

@immutable
class _Something<T> extends _SomethingBase<T> with Something<T> {
  @override
  final Unit? _nothing;
  @override
  final User? _user;
  @override
  final quiv.Optional<ty.Address>? _address;
  @override
  final Something<T>? _something;
  @override
  final T? _param;

  @override
  quiv.Optional<Unit> get nothing =>
      quiv.Optional<Unit>.fromNullable(this._nothing);
  @override
  quiv.Optional<User> get user => quiv.Optional<User>.fromNullable(this._user);
  @override
  quiv.Optional<quiv.Optional<ty.Address>> get address =>
      quiv.Optional<quiv.Optional<ty.Address>>.fromNullable(this._address);
  @override
  quiv.Optional<Something<T>> get something =>
      quiv.Optional<Something<T>>.fromNullable(this._something);
  @override
  quiv.Optional<T> get param => quiv.Optional<T>.fromNullable(this._param);

  const _Something({
    Unit? nothing,
    User? user,
    quiv.Optional<ty.Address>? address,
    Something<T>? something,
    T? param,
  })  : assert((nothing != null &&
                user == null &&
                address == null &&
                something == null &&
                param == null) ||
            (nothing == null &&
                user != null &&
                address == null &&
                something == null &&
                param == null) ||
            (nothing == null &&
                user == null &&
                address != null &&
                something == null &&
                param == null) ||
            (nothing == null &&
                user == null &&
                address == null &&
                something != null &&
                param == null) ||
            (nothing == null &&
                user == null &&
                address == null &&
                something == null &&
                param != null)),
        this._nothing = nothing,
        this._user = user,
        this._address = address,
        this._something = something,
        this._param = param;

  @override
  __T$ iswitch<__T$>({
    required __T$ Function() nothing,
    required __T$ Function(User) user,
    required __T$ Function(quiv.Optional<ty.Address>) address,
    required __T$ Function(Something<T>) something,
    required __T$ Function(T) param,
  }) {
    final nothing$ = this._nothing;
    final user$ = this._user;
    final address$ = this._address;
    final something$ = this._something;
    final param$ = this._param;
    if (nothing$ != null) {
      return nothing();
    } else if (user$ != null) {
      return user(user$);
    } else if (address$ != null) {
      return address(address$);
    } else if (something$ != null) {
      return something(something$);
    } else if (param$ != null) {
      return param(param$);
    } else {
      throw StateError('an instance of Something has no case selected');
    }
  }

  @override
  __T$ iswitcho<__T$>({
    __T$ Function()? nothing,
    __T$ Function(User)? user,
    __T$ Function(quiv.Optional<ty.Address>)? address,
    __T$ Function(Something<T>)? something,
    __T$ Function(T)? param,
    required __T$ Function() otherwise,
  }) {
    return iswitch(
      nothing: nothing ?? otherwise,
      user: user ?? (User _) => otherwise(),
      address: address ?? (quiv.Optional<ty.Address> _) => otherwise(),
      something: something ?? (Something<T> _) => otherwise(),
      param: param ?? (T _) => otherwise(),
    );
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    if (this.runtimeType != other.runtimeType) return false;
    return other is _Something &&
        this._nothing == other._nothing &&
        this._user == other._user &&
        this._address == other._address &&
        this._something == other._something &&
        this._param == other._param;
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
    final x$ = iswitch(
      nothing: () => 'nothing',
      user: (User x$) => 'user(${x$})',
      address: (quiv.Optional<ty.Address> x$) => 'address(${x$})',
      something: (Something<T> x$) => 'something(${x$})',
      param: (T x$) => 'param(${x$})',
    );
    return 'Something.${x$}';
  }
}

/// This data class has been generated from CustomToString
abstract class CustomToStringFactory {
  static CustomToString foo(String x$) => _CustomToString(foo: x$);
}

abstract class _CustomToStringBase {
  const _CustomToStringBase();
  quiv.Optional<String> get foo;
  __T$ iswitch<__T$>({required __T$ Function(String) foo});
  __T$ iswitcho<__T$>({
    __T$ Function(String)? foo,
    required __T$ Function() otherwise,
  });
}

@immutable
class _CustomToString extends _CustomToStringBase with CustomToString {
  @override
  final String? _foo;

  @override
  quiv.Optional<String> get foo =>
      quiv.Optional<String>.fromNullable(this._foo);

  const _CustomToString({
    String? foo,
  })  : assert((foo != null)),
        this._foo = foo;

  @override
  __T$ iswitch<__T$>({
    required __T$ Function(String) foo,
  }) {
    final foo$ = this._foo;
    if (foo$ != null) {
      return foo(foo$);
    } else {
      throw StateError('an instance of CustomToString has no case selected');
    }
  }

  @override
  __T$ iswitcho<__T$>({
    __T$ Function(String)? foo,
    required __T$ Function() otherwise,
  }) {
    return iswitch(
      foo: foo ?? (String _) => otherwise(),
    );
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    if (this.runtimeType != other.runtimeType) return false;
    return other is _CustomToString && this._foo == other._foo;
  }

  @override
  int get hashCode {
    var result = 17;
    result = 37 * result + this._foo.hashCode;
    return result;
  }
}

/// This data class has been generated from CustomEq
abstract class CustomEqFactory {
  static CustomEq foo(String x$) => _CustomEq(foo: x$);
}

abstract class _CustomEqBase {
  const _CustomEqBase();
  quiv.Optional<String> get foo;
  __T$ iswitch<__T$>({required __T$ Function(String) foo});
  __T$ iswitcho<__T$>({
    __T$ Function(String)? foo,
    required __T$ Function() otherwise,
  });
}

@immutable
class _CustomEq extends _CustomEqBase with CustomEq {
  @override
  final String? _foo;

  @override
  quiv.Optional<String> get foo =>
      quiv.Optional<String>.fromNullable(this._foo);

  const _CustomEq({
    String? foo,
  })  : assert((foo != null)),
        this._foo = foo;

  @override
  __T$ iswitch<__T$>({
    required __T$ Function(String) foo,
  }) {
    final foo$ = this._foo;
    if (foo$ != null) {
      return foo(foo$);
    } else {
      throw StateError('an instance of CustomEq has no case selected');
    }
  }

  @override
  __T$ iswitcho<__T$>({
    __T$ Function(String)? foo,
    required __T$ Function() otherwise,
  }) {
    return iswitch(
      foo: foo ?? (String _) => otherwise(),
    );
  }

  @override
  String toString() {
    final x$ = iswitch(
      foo: (String x$) => 'foo(${x$})',
    );
    return 'CustomEq.${x$}';
  }
}
