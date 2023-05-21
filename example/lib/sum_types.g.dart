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
    final String? _known = this._known;
    final dynamic? _unknown = this._unknown;
    if (_known != null) {
      return known(_known);
    } else if (_unknown != null) {
      return unknown(_unknown);
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
  bool operator ==(Object __other$) {
    if (identical(this, __other$)) return true;
    if (this.runtimeType != __other$.runtimeType) return false;
    return __other$ is _WithUnknown &&
        this._known == __other$._known &&
        this._unknown == __other$._unknown;
  }

  @override
  int get hashCode {
    var __result$ = 17;
    __result$ = 37 * __result$ + this._known.hashCode;
    __result$ = 37 * __result$ + this._unknown.hashCode;
    return __result$;
  }

  @override
  String toString() {
    final __x$ = iswitch(
      known: (String __value$) => 'known(${__value$})',
      unknown: (dynamic __value$) => 'unknown(${__value$})',
    );
    return 'WithUnknown.${__x$}';
  }
}

/// This data class has been generated from Something
abstract class SomethingFactory {
  static Something<T> nothing<T>() => _Something(nothing: const Unit());
  static Something<T> user<T>(User __x$) => _Something(user: __x$);
  static Something<T> address<T>(quiv.Optional<ty.Address> __x$) =>
      _Something(address: __x$);
  static Something<T> something<T>(Something<T> __x$) =>
      _Something(something: __x$);
  static Something<T> param<T>(T __x$) => _Something(param: __x$);
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
    final Unit? _nothing = this._nothing;
    final User? _user = this._user;
    final quiv.Optional<ty.Address>? _address = this._address;
    final Something<T>? _something = this._something;
    final T? _param = this._param;
    if (_nothing != null) {
      return nothing();
    } else if (_user != null) {
      return user(_user);
    } else if (_address != null) {
      return address(_address);
    } else if (_something != null) {
      return something(_something);
    } else if (_param != null) {
      return param(_param);
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
  bool operator ==(Object __other$) {
    if (identical(this, __other$)) return true;
    if (this.runtimeType != __other$.runtimeType) return false;
    return __other$ is _Something &&
        this._nothing == __other$._nothing &&
        this._user == __other$._user &&
        this._address == __other$._address &&
        this._something == __other$._something &&
        this._param == __other$._param;
  }

  @override
  int get hashCode {
    var __result$ = 17;
    __result$ = 37 * __result$ + this._nothing.hashCode;
    __result$ = 37 * __result$ + this._user.hashCode;
    __result$ = 37 * __result$ + this._address.hashCode;
    __result$ = 37 * __result$ + this._something.hashCode;
    __result$ = 37 * __result$ + this._param.hashCode;
    return __result$;
  }

  @override
  String toString() {
    final __x$ = iswitch(
      nothing: () => 'nothing',
      user: (User __value$) => 'user(${__value$})',
      address: (quiv.Optional<ty.Address> __value$) => 'address(${__value$})',
      something: (Something<T> __value$) => 'something(${__value$})',
      param: (T __value$) => 'param(${__value$})',
    );
    return 'Something.${__x$}';
  }
}

/// This data class has been generated from CustomToString
abstract class CustomToStringFactory {
  static CustomToString foo(String __x$) => _CustomToString(foo: __x$);
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
    final String? _foo = this._foo;
    if (_foo != null) {
      return foo(_foo);
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
  bool operator ==(Object __other$) {
    if (identical(this, __other$)) return true;
    if (this.runtimeType != __other$.runtimeType) return false;
    return __other$ is _CustomToString && this._foo == __other$._foo;
  }

  @override
  int get hashCode {
    var __result$ = 17;
    __result$ = 37 * __result$ + this._foo.hashCode;
    return __result$;
  }
}

/// This data class has been generated from CustomEq
abstract class CustomEqFactory {
  static CustomEq foo(String __x$) => _CustomEq(foo: __x$);
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
    final String? _foo = this._foo;
    if (_foo != null) {
      return foo(_foo);
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
    final __x$ = iswitch(
      foo: (String __value$) => 'foo(${__value$})',
    );
    return 'CustomEq.${__x$}';
  }
}
