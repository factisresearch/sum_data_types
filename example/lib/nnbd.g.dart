// GENERATED CODE - DO NOT MODIFY BY HAND
// @dart=2.12

part of 'nnbd.dart';

// **************************************************************************
// SumTypeGenerator
// **************************************************************************

/// This data class has been generated from Either
abstract class EitherFactory {
  static Either<A, B> left<A, B>(A __x$) => _Either(left: __x$);
  static Either<A, B> right<A, B>(B __x$) => _Either(right: __x$);
}

abstract class _EitherBase<A, B> {
  const _EitherBase();
  Optional<A> get left;
  Optional<B> get right;
  __T$ iswitch<__T$>(
      {required __T$ Function(A) left, required __T$ Function(B) right});
  __T$ iswitcho<__T$>({
    __T$ Function(A)? left,
    __T$ Function(B)? right,
    required __T$ Function() otherwise,
  });
}

@immutable
class _Either<A, B> extends _EitherBase<A, B> with Either<A, B> {
  @override
  final A? _left;
  @override
  final B? _right;

  @override
  Optional<A> get left => Optional<A>.fromNullable(this._left);
  @override
  Optional<B> get right => Optional<B>.fromNullable(this._right);

  const _Either({
    A? left,
    B? right,
  })  : assert(
            (left != null && right == null) || (left == null && right != null)),
        this._left = left,
        this._right = right;

  @override
  __T$ iswitch<__T$>({
    required __T$ Function(A) left,
    required __T$ Function(B) right,
  }) {
    final A? _left = this._left;
    final B? _right = this._right;
    if (_left != null) {
      return left(_left);
    } else if (_right != null) {
      return right(_right);
    } else {
      throw StateError('an instance of Either has no case selected');
    }
  }

  @override
  __T$ iswitcho<__T$>({
    __T$ Function(A)? left,
    __T$ Function(B)? right,
    required __T$ Function() otherwise,
  }) {
    return iswitch(
      left: left ?? (A _) => otherwise(),
      right: right ?? (B _) => otherwise(),
    );
  }

  @override
  bool operator ==(Object __other$) {
    if (identical(this, __other$)) return true;
    if (this.runtimeType != __other$.runtimeType) return false;
    return __other$ is _Either &&
        this._left == __other$._left &&
        this._right == __other$._right;
  }

  @override
  int get hashCode {
    var __result$ = 17;
    __result$ = 37 * __result$ + this._left.hashCode;
    __result$ = 37 * __result$ + this._right.hashCode;
    return __result$;
  }

  @override
  String toString() {
    final __x$ = iswitch(
      left: (A __value$) => 'left(${__value$})',
      right: (B __value$) => 'right(${__value$})',
    );
    return 'Either.${__x$}';
  }
}

/// This data class has been generated from Something
abstract class SomethingFactory {
  static Something string(String __x$) => _Something(string: __x$);
  static Something unknown(dynamic __x$) => _Something(unknown: __x$);
}

abstract class _SomethingBase {
  const _SomethingBase();
  Optional<String> get string;
  Optional<dynamic> get unknown;
  __T$ iswitch<__T$>(
      {required __T$ Function(String) string,
      required __T$ Function(dynamic) unknown});
  __T$ iswitcho<__T$>({
    __T$ Function(String)? string,
    __T$ Function(dynamic)? unknown,
    required __T$ Function() otherwise,
  });
}

@immutable
class _Something extends _SomethingBase with Something {
  @override
  final String? _string;
  @override
  final dynamic _unknown;

  @override
  Optional<String> get string => Optional<String>.fromNullable(this._string);
  @override
  Optional<dynamic> get unknown =>
      Optional<dynamic>.fromNullable(this._unknown);

  const _Something({
    String? string,
    dynamic unknown,
  })  : assert((string != null && unknown == null) ||
            (string == null && unknown != null)),
        this._string = string,
        this._unknown = unknown;

  @override
  __T$ iswitch<__T$>({
    required __T$ Function(String) string,
    required __T$ Function(dynamic) unknown,
  }) {
    final String? _string = this._string;
    final dynamic? _unknown = this._unknown;
    if (_string != null) {
      return string(_string);
    } else if (_unknown != null) {
      return unknown(_unknown);
    } else {
      throw StateError('an instance of Something has no case selected');
    }
  }

  @override
  __T$ iswitcho<__T$>({
    __T$ Function(String)? string,
    __T$ Function(dynamic)? unknown,
    required __T$ Function() otherwise,
  }) {
    return iswitch(
      string: string ?? (String _) => otherwise(),
      unknown: unknown ?? (dynamic _) => otherwise(),
    );
  }

  @override
  bool operator ==(Object __other$) {
    if (identical(this, __other$)) return true;
    if (this.runtimeType != __other$.runtimeType) return false;
    return __other$ is _Something &&
        this._string == __other$._string &&
        this._unknown == __other$._unknown;
  }

  @override
  int get hashCode {
    var __result$ = 17;
    __result$ = 37 * __result$ + this._string.hashCode;
    __result$ = 37 * __result$ + this._unknown.hashCode;
    return __result$;
  }

  @override
  String toString() {
    final __x$ = iswitch(
      string: (String __value$) => 'string(${__value$})',
      unknown: (dynamic __value$) => 'unknown(${__value$})',
    );
    return 'Something.${__x$}';
  }
}

// **************************************************************************
// DataClassGenerator
// **************************************************************************

/// This data class has been generated from Container
abstract class ContainerFactory {
  static Container<T> make<T>({
    required String id,
    required T payload,
  }) {
    return _Container.make(
      id: id,
      payload: payload,
    );
  }
}

abstract class _ContainerBase<T> {
  const _ContainerBase();

  Container<T> copyWith({
    String? id,
    T? payload,
  });
}

@immutable
class _Container<T> extends _ContainerBase<T> with Container<T> {
  @override
  final String id;
  @override
  final T payload;

  const _Container.make({
    required this.id,
    required this.payload,
  });

  @override
  Container<T> copyWith({
    String? id,
    T? payload,
  }) {
    return _Container.make(
      id: id ?? this.id,
      payload: payload ?? this.payload,
    );
  }

  @override
  bool operator ==(Object __other$) {
    if (identical(this, __other$)) return true;
    if (this.runtimeType != __other$.runtimeType) return false;
    return __other$ is _Container &&
        this.id == __other$.id &&
        this.payload == __other$.payload;
  }

  @override
  int get hashCode {
    var __result$ = 17;
    __result$ = 37 * __result$ + this.id.hashCode;
    __result$ = 37 * __result$ + this.payload.hashCode;
    return __result$;
  }

  @override
  String toString() {
    return 'Container(id: ${this.id}, payload: ${this.payload})';
  }
}
