// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'data_classes.dart';

// **************************************************************************
// SumTypeGenerator
// **************************************************************************

/// This data class has been generated from Either
abstract class EitherFactory {
  static Either<A, B> left<A, B>(A __x$) => _Either(left: __x$);
  static Either<A, B> right<A, B>(B __x$) => _Either(right: __x$);
}

extension EitherMethods<A, B> on Either<A, B> {
  __T$ iswitch<__T$>({
    @required __T$ Function(A) left,
    @required __T$ Function(B) right,
  }) {
    if (this._left != null) {
      if (left == null) throw ArgumentError.notNull("left");
      return left(this._left);
    } else if (this._right != null) {
      if (right == null) throw ArgumentError.notNull("right");
      return right(this._right);
    } else {
      throw StateError("an instance of Either has no case selected");
    }
  }

  __T$ iswitcho<__T$>({
    __T$ Function(A) left,
    __T$ Function(B) right,
    @required __T$ Function() otherwise,
  }) {
    return iswitch(
      left: left ?? (Object _) => otherwise(),
      right: right ?? (Object _) => otherwise(),
    );
  }
}

class _Either<A, B> with Either<A, B> {
  final A _left;
  final B _right;

  Optional<A> get left => Optional<A>.fromNullable(this._left);
  Optional<B> get right => Optional<B>.fromNullable(this._right);

  _Either({
    A left,
    B right,
  })  : assert(
            (left != null && right == null) || (left == null && right != null)),
        this._left = left,
        this._right = right;

  @override
  bool operator ==(Object __other$) {
    if (identical(this, __other$)) return true;
    if (this.runtimeType != __other$.runtimeType) return false;
    return __other$ is _Either &&
        this.left == __other$.left &&
        this.right == __other$.right;
  }

  @override
  int get hashCode {
    var __result$ = 17;
    __result$ = 37 * __result$ + this.left.hashCode;
    __result$ = 37 * __result$ + this.right.hashCode;
    return __result$;
  }

  @override
  toString() {
    final __x$ = iswitch(
        left: (A __value$) => "left(${__value$})",
        right: (B __value$) => "right(${__value$})");
    return "Either.${__x$}";
  }
}

// **************************************************************************
// DataClassGenerator
// **************************************************************************

/// This data class has been generated from Container
abstract class ContainerFactory {
  static Container<T> make<T>({
    @required String id,
    @required T payload,
  }) {
    return _Container.make(
      id: id,
      payload: payload,
    );
  }
}

extension ContainerMethods<T> on Container<T> {
  Container<T> copyWith({
    String id,
    T payload,
  }) {
    return _Container.make(
      id: id ?? this.id,
      payload: payload ?? this.payload,
    );
  }
}

@immutable
class _Container<T> with Container<T> {
  final String id;
  final T payload;

  // We cannot have a const constructor because of https://github.com/dart-lang/sdk/issues/37810
  _Container.make({
    @required this.id,
    @required this.payload,
  })  : assert(id != null),
        assert(payload != null);

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
    return "Container(id: ${this.id}, payload: ${this.payload})";
  }
}

/// This data class has been generated from User
abstract class UserFactory {
  static User make({
    @required String name,
    int age,
    @required KtList<User> friends,
    @required ty.Address address,
    ty.Address workAddress,
    @required KtList<ty.Address> friendsAddresses,
    @required Either<String, int> foo,
  }) {
    return _User.make(
      name: name,
      age: Optional.fromNullable(age),
      friends: friends,
      address: address,
      workAddress: Optional.fromNullable(workAddress),
      friendsAddresses: friendsAddresses,
      foo: foo,
    );
  }
}

extension UserMethods on User {
  User copyWith({
    String name,
    Optional<int> age,
    KtList<User> friends,
    ty.Address address,
    Optional<ty.Address> workAddress,
    KtList<ty.Address> friendsAddresses,
    Either<String, int> foo,
  }) {
    return _User.make(
      name: name ?? this.name,
      age: age ?? this.age,
      friends: friends ?? this.friends,
      address: address ?? this.address,
      workAddress: workAddress ?? this.workAddress,
      friendsAddresses: friendsAddresses ?? this.friendsAddresses,
      foo: foo ?? this.foo,
    );
  }
}

@immutable
class _User with User {
  final String name;
  final Optional<int> age;
  final KtList<User> friends;
  final ty.Address address;
  final Optional<ty.Address> workAddress;
  final KtList<ty.Address> friendsAddresses;
  final Either<String, int> foo;

  // We cannot have a const constructor because of https://github.com/dart-lang/sdk/issues/37810
  _User.make({
    @required this.name,
    @required this.age,
    @required this.friends,
    @required this.address,
    @required this.workAddress,
    @required this.friendsAddresses,
    @required this.foo,
  })  : assert(name != null),
        assert(age != null),
        assert(friends != null),
        assert(address != null),
        assert(workAddress != null),
        assert(friendsAddresses != null),
        assert(foo != null);

  @override
  bool operator ==(Object __other$) {
    if (identical(this, __other$)) return true;
    if (this.runtimeType != __other$.runtimeType) return false;
    return __other$ is _User &&
        this.name == __other$.name &&
        this.age == __other$.age &&
        this.friends == __other$.friends &&
        this.address == __other$.address &&
        this.workAddress == __other$.workAddress &&
        this.friendsAddresses == __other$.friendsAddresses &&
        this.foo == __other$.foo;
  }

  @override
  int get hashCode {
    var __result$ = 17;
    __result$ = 37 * __result$ + this.name.hashCode;
    __result$ = 37 * __result$ + this.age.hashCode;
    __result$ = 37 * __result$ + this.friends.hashCode;
    __result$ = 37 * __result$ + this.address.hashCode;
    __result$ = 37 * __result$ + this.workAddress.hashCode;
    __result$ = 37 * __result$ + this.friendsAddresses.hashCode;
    __result$ = 37 * __result$ + this.foo.hashCode;
    return __result$;
  }

  @override
  String toString() {
    return "User(name: ${this.name}, age: ${this.age}, friends: ${this.friends}, address: ${this.address}, workAddress: ${this.workAddress}, friendsAddresses: ${this.friendsAddresses}, foo: ${this.foo})";
  }
}

/// This data class has been generated from NullaryType
abstract class NullaryTypeFactory {
  static NullaryType make() {
    return _NullaryType.make();
  }
}

extension NullaryTypeMethods on NullaryType {
  NullaryType copyWith() {
    return _NullaryType.make();
  }
}

@immutable
class _NullaryType with NullaryType {
  // We cannot have a const constructor because of https://github.com/dart-lang/sdk/issues/37810
  _NullaryType.make();

  @override
  bool operator ==(Object __other$) {
    if (identical(this, __other$)) return true;
    if (this.runtimeType != __other$.runtimeType) return false;
    return __other$ is _NullaryType && true;
  }

  @override
  int get hashCode => 0;

  @override
  String toString() {
    return "NullaryType()";
  }
}

/// This data class has been generated from CustomToString
abstract class CustomToStringFactory {
  static CustomToString make({
    @required String foo,
    @required String bar,
  }) {
    return _CustomToString.make(
      foo: foo,
      bar: bar,
    );
  }
}

extension CustomToStringMethods on CustomToString {
  CustomToString copyWith({
    String foo,
    String bar,
  }) {
    return _CustomToString.make(
      foo: foo ?? this.foo,
      bar: bar ?? this.bar,
    );
  }
}

@immutable
class _CustomToString with CustomToString {
  final String foo;
  final String bar;

  // We cannot have a const constructor because of https://github.com/dart-lang/sdk/issues/37810
  _CustomToString.make({
    @required this.foo,
    @required this.bar,
  })  : assert(foo != null),
        assert(bar != null);

  @override
  bool operator ==(Object __other$) {
    if (identical(this, __other$)) return true;
    if (this.runtimeType != __other$.runtimeType) return false;
    return __other$ is _CustomToString &&
        this.foo == __other$.foo &&
        this.bar == __other$.bar;
  }

  @override
  int get hashCode {
    var __result$ = 17;
    __result$ = 37 * __result$ + this.foo.hashCode;
    __result$ = 37 * __result$ + this.bar.hashCode;
    return __result$;
  }
}

/// This data class has been generated from CustomEq
abstract class CustomEqFactory {
  static CustomEq make({
    @required String foo,
    @required String bar,
  }) {
    return _CustomEq.make(
      foo: foo,
      bar: bar,
    );
  }
}

extension CustomEqMethods on CustomEq {
  CustomEq copyWith({
    String foo,
    String bar,
  }) {
    return _CustomEq.make(
      foo: foo ?? this.foo,
      bar: bar ?? this.bar,
    );
  }
}

@immutable
class _CustomEq with CustomEq {
  final String foo;
  final String bar;

  // We cannot have a const constructor because of https://github.com/dart-lang/sdk/issues/37810
  _CustomEq.make({
    @required this.foo,
    @required this.bar,
  })  : assert(foo != null),
        assert(bar != null);

  @override
  String toString() {
    return "CustomEq(foo: ${this.foo}, bar: ${this.bar})";
  }
}
