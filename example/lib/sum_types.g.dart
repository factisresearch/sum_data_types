// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'sum_types.dart';

// **************************************************************************
// SumTypeGenerator
// **************************************************************************

/// This data class has been generated from WithUnknown
abstract class WithUnknownFactory {
  static WithUnknown known(String __x$) => _WithUnknown(known: __x$);
  static WithUnknown unknown(dynamic __x$) => _WithUnknown(unknown: __x$);
}

extension WithUnknownMethods on WithUnknown {
  __T$ iswitch<__T$>({
    @required __T$ Function(String) known,
    @required __T$ Function(dynamic) unknown,
  }) {
    if (this._known != null) {
      if (known == null) throw ArgumentError.notNull("known");
      return known(this._known);
    } else if (this._unknown != null) {
      if (unknown == null) throw ArgumentError.notNull("unknown");
      return unknown(this._unknown);
    } else {
      throw StateError("an instance of WithUnknown has no case selected");
    }
  }

  __T$ iswitcho<__T$>({
    __T$ Function(String) known,
    __T$ Function(dynamic) unknown,
    @required __T$ Function() otherwise,
  }) {
    return iswitch(
      known: known ?? (Object _) => otherwise(),
      unknown: unknown ?? (Object _) => otherwise(),
    );
  }
}

class _WithUnknown with WithUnknown {
  final String _known;
  final dynamic _unknown;

  quiv.Optional<String> get known =>
      quiv.Optional<String>.fromNullable(this._known);
  quiv.Optional<dynamic> get unknown =>
      quiv.Optional<dynamic>.fromNullable(this._unknown);

  _WithUnknown({
    String known,
    dynamic unknown,
  })  : assert((known != null && unknown == null) ||
            (known == null && unknown != null)),
        this._known = known,
        this._unknown = unknown;

  @override
  bool operator ==(Object __other$) {
    if (identical(this, __other$)) return true;
    if (this.runtimeType != __other$.runtimeType) return false;
    return __other$ is _WithUnknown &&
        this.known == __other$.known &&
        this.unknown == __other$.unknown;
  }

  @override
  int get hashCode {
    var __result$ = 17;
    __result$ = 37 * __result$ + this.known.hashCode;
    __result$ = 37 * __result$ + this.unknown.hashCode;
    return __result$;
  }

  @override
  toString() {
    final __x$ = iswitch(
        known: (String __value$) => "known(${__value$})",
        unknown: (dynamic __value$) => "unknown(${__value$})");
    return "WithUnknown.${__x$}";
  }
}

/// This data class has been generated from Something
abstract class SomethingFactory {
  static Something<T> nothing<T>() => _Something(nothing: const Unit());
  static Something<T> user<T>(User __x$) => _Something(user: __x$);
  static Something<T> address<T>(quiv.Optional<ty.Address> __x$) =>
      _Something(address: __x$);
  static Something<T> something<T>(Something<dynamic> __x$) =>
      _Something(something: __x$);
  static Something<T> param<T>(T __x$) => _Something(param: __x$);
}

extension SomethingMethods<T> on Something<T> {
  __T$ iswitch<__T$>({
    @required __T$ Function() nothing,
    @required __T$ Function(User) user,
    @required __T$ Function(quiv.Optional<ty.Address>) address,
    @required __T$ Function(Something<dynamic>) something,
    @required __T$ Function(T) param,
  }) {
    if (this._nothing != null) {
      if (nothing == null) throw ArgumentError.notNull("nothing");
      return nothing();
    } else if (this._user != null) {
      if (user == null) throw ArgumentError.notNull("user");
      return user(this._user);
    } else if (this._address != null) {
      if (address == null) throw ArgumentError.notNull("address");
      return address(this._address);
    } else if (this._something != null) {
      if (something == null) throw ArgumentError.notNull("something");
      return something(this._something);
    } else if (this._param != null) {
      if (param == null) throw ArgumentError.notNull("param");
      return param(this._param);
    } else {
      throw StateError("an instance of Something has no case selected");
    }
  }

  __T$ iswitcho<__T$>({
    __T$ Function() nothing,
    __T$ Function(User) user,
    __T$ Function(quiv.Optional<ty.Address>) address,
    __T$ Function(Something<dynamic>) something,
    __T$ Function(T) param,
    @required __T$ Function() otherwise,
  }) {
    return iswitch(
      nothing: nothing ?? otherwise,
      user: user ?? (Object _) => otherwise(),
      address: address ?? (Object _) => otherwise(),
      something: something ?? (Object _) => otherwise(),
      param: param ?? (Object _) => otherwise(),
    );
  }
}

class _Something<T> with Something<T> {
  final Unit _nothing;
  final User _user;
  final quiv.Optional<ty.Address> _address;
  final Something<dynamic> _something;
  final T _param;

  quiv.Optional<Unit> get nothing =>
      quiv.Optional<Unit>.fromNullable(this._nothing);
  quiv.Optional<User> get user => quiv.Optional<User>.fromNullable(this._user);
  quiv.Optional<quiv.Optional<ty.Address>> get address =>
      quiv.Optional<quiv.Optional<ty.Address>>.fromNullable(this._address);
  quiv.Optional<Something<dynamic>> get something =>
      quiv.Optional<Something<dynamic>>.fromNullable(this._something);
  quiv.Optional<T> get param => quiv.Optional<T>.fromNullable(this._param);

  _Something({
    Unit nothing,
    User user,
    quiv.Optional<ty.Address> address,
    Something<dynamic> something,
    T param,
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
  bool operator ==(Object __other$) {
    if (identical(this, __other$)) return true;
    if (this.runtimeType != __other$.runtimeType) return false;
    return __other$ is _Something &&
        this.nothing == __other$.nothing &&
        this.user == __other$.user &&
        this.address == __other$.address &&
        this.something == __other$.something &&
        this.param == __other$.param;
  }

  @override
  int get hashCode {
    var __result$ = 17;
    __result$ = 37 * __result$ + this.nothing.hashCode;
    __result$ = 37 * __result$ + this.user.hashCode;
    __result$ = 37 * __result$ + this.address.hashCode;
    __result$ = 37 * __result$ + this.something.hashCode;
    __result$ = 37 * __result$ + this.param.hashCode;
    return __result$;
  }

  @override
  toString() {
    final __x$ = iswitch(
        nothing: () => "nothing",
        user: (User __value$) => "user(${__value$})",
        address: (quiv.Optional<ty.Address> __value$) => "address(${__value$})",
        something: (Something<dynamic> __value$) => "something(${__value$})",
        param: (T __value$) => "param(${__value$})");
    return "Something.${__x$}";
  }
}

/// This data class has been generated from CustomToString
abstract class CustomToStringFactory {
  static CustomToString foo(String __x$) => _CustomToString(foo: __x$);
}

extension CustomToStringMethods on CustomToString {
  __T$ iswitch<__T$>({
    @required __T$ Function(String) foo,
  }) {
    if (this._foo != null) {
      if (foo == null) throw ArgumentError.notNull("foo");
      return foo(this._foo);
    } else {
      throw StateError("an instance of CustomToString has no case selected");
    }
  }

  __T$ iswitcho<__T$>({
    __T$ Function(String) foo,
    @required __T$ Function() otherwise,
  }) {
    return iswitch(
      foo: foo ?? (Object _) => otherwise(),
    );
  }
}

class _CustomToString with CustomToString {
  final String _foo;

  quiv.Optional<String> get foo =>
      quiv.Optional<String>.fromNullable(this._foo);

  _CustomToString({
    String foo,
  })  : assert((foo != null)),
        this._foo = foo;

  @override
  bool operator ==(Object __other$) {
    if (identical(this, __other$)) return true;
    if (this.runtimeType != __other$.runtimeType) return false;
    return __other$ is _CustomToString && this.foo == __other$.foo;
  }

  @override
  int get hashCode {
    var __result$ = 17;
    __result$ = 37 * __result$ + this.foo.hashCode;
    return __result$;
  }
}

/// This data class has been generated from CustomEq
abstract class CustomEqFactory {
  static CustomEq foo(String __x$) => _CustomEq(foo: __x$);
}

extension CustomEqMethods on CustomEq {
  __T$ iswitch<__T$>({
    @required __T$ Function(String) foo,
  }) {
    if (this._foo != null) {
      if (foo == null) throw ArgumentError.notNull("foo");
      return foo(this._foo);
    } else {
      throw StateError("an instance of CustomEq has no case selected");
    }
  }

  __T$ iswitcho<__T$>({
    __T$ Function(String) foo,
    @required __T$ Function() otherwise,
  }) {
    return iswitch(
      foo: foo ?? (Object _) => otherwise(),
    );
  }
}

class _CustomEq with CustomEq {
  final String _foo;

  quiv.Optional<String> get foo =>
      quiv.Optional<String>.fromNullable(this._foo);

  _CustomEq({
    String foo,
  })  : assert((foo != null)),
        this._foo = foo;

  @override
  toString() {
    final __x$ = iswitch(foo: (String __value$) => "foo(${__value$})");
    return "CustomEq.${__x$}";
  }
}
