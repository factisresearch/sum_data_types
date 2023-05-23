// GENERATED CODE - DO NOT MODIFY BY HAND
// @dart=2.12

part of 'nnbd.dart';

// **************************************************************************
// SumTypeGenerator
// **************************************************************************

/// This data class has been generated from Either
abstract class EitherFactory {
  static Either<A, B> left<A, B>(A x$) => _Either(left: x$);
  static Either<A, B> right<A, B>(B x$) => _Either(right: x$);
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
    final left$ = this._left;
    final right$ = this._right;
    if (left$ != null) {
      return left(left$);
    } else if (right$ != null) {
      return right(right$);
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
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    if (this.runtimeType != other.runtimeType) return false;
    return other is _Either &&
        this._left == other._left &&
        this._right == other._right;
  }

  @override
  int get hashCode {
    var result = 17;
    result = 37 * result + this._left.hashCode;
    result = 37 * result + this._right.hashCode;
    return result;
  }

  @override
  String toString() {
    final x$ = iswitch(
      left: (A x$) => 'left(${x$})',
      right: (B x$) => 'right(${x$})',
    );
    return 'Either.${x$}';
  }
}

/// This data class has been generated from Something
abstract class SomethingFactory {
  static Something string(String x$) => _Something(string: x$);
  static Something unknown(dynamic x$) => _Something(unknown: x$);
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
    final string$ = this._string;
    final unknown$ = this._unknown;
    if (string$ != null) {
      return string(string$);
    } else if (unknown$ != null) {
      return unknown(unknown$);
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
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    if (this.runtimeType != other.runtimeType) return false;
    return other is _Something &&
        this._string == other._string &&
        this._unknown == other._unknown;
  }

  @override
  int get hashCode {
    var result = 17;
    result = 37 * result + this._string.hashCode;
    result = 37 * result + this._unknown.hashCode;
    return result;
  }

  @override
  String toString() {
    final x$ = iswitch(
      string: (String x$) => 'string(${x$})',
      unknown: (dynamic x$) => 'unknown(${x$})',
    );
    return 'Something.${x$}';
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
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    if (this.runtimeType != other.runtimeType) return false;
    return other is _Container &&
        this.id == other.id &&
        this.payload == other.payload;
  }

  @override
  int get hashCode {
    var result = 17;
    result = 37 * result + this.id.hashCode;
    result = 37 * result + this.payload.hashCode;
    return result;
  }

  @override
  String toString() {
    return 'Container(id: ${this.id}, payload: ${this.payload})';
  }
}
