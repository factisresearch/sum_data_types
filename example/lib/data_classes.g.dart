// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'data_classes.dart';

// **************************************************************************
// DataClassGenerator
// **************************************************************************

/// This data class has been generated from User
abstract class UserFactory {
  static User make({
    required String name,
    int? age,
    required KtList<User> friends,
    required ty.Address address,
    ty.Address? workAddress,
    required KtList<ty.Address> friendsAddresses,
    required Either<String, int> foo,
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

abstract class _UserBase {
  const _UserBase();

  User copyWith({
    String? name,
    Optional<int>? age,
    KtList<User>? friends,
    ty.Address? address,
    Optional<ty.Address>? workAddress,
    KtList<ty.Address>? friendsAddresses,
    Either<String, int>? foo,
  });
}

@immutable
class _User extends _UserBase with User {
  @override
  final String name;
  @override
  final Optional<int> age;
  @override
  final KtList<User> friends;
  @override
  final ty.Address address;
  @override
  final Optional<ty.Address> workAddress;
  @override
  final KtList<ty.Address> friendsAddresses;
  @override
  final Either<String, int> foo;

  const _User.make({
    required this.name,
    required this.age,
    required this.friends,
    required this.address,
    required this.workAddress,
    required this.friendsAddresses,
    required this.foo,
  });

  @override
  User copyWith({
    String? name,
    Optional<int>? age,
    KtList<User>? friends,
    ty.Address? address,
    Optional<ty.Address>? workAddress,
    KtList<ty.Address>? friendsAddresses,
    Either<String, int>? foo,
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

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    if (this.runtimeType != other.runtimeType) return false;
    return other is _User &&
        this.name == other.name &&
        this.age == other.age &&
        this.friends == other.friends &&
        this.address == other.address &&
        this.workAddress == other.workAddress &&
        this.friendsAddresses == other.friendsAddresses &&
        this.foo == other.foo;
  }

  @override
  int get hashCode {
    var result = 17;
    result = 37 * result + this.name.hashCode;
    result = 37 * result + this.age.hashCode;
    result = 37 * result + this.friends.hashCode;
    result = 37 * result + this.address.hashCode;
    result = 37 * result + this.workAddress.hashCode;
    result = 37 * result + this.friendsAddresses.hashCode;
    result = 37 * result + this.foo.hashCode;
    return result;
  }

  @override
  String toString() {
    return 'User(name: ${this.name}, age: ${this.age}, friends: ${this.friends}, address: ${this.address}, workAddress: ${this.workAddress}, friendsAddresses: ${this.friendsAddresses}, foo: ${this.foo})';
  }
}

/// This data class has been generated from NullaryType
abstract class NullaryTypeFactory {
  static NullaryType make() {
    return _NullaryType.make();
  }
}

abstract class _NullaryTypeBase {
  const _NullaryTypeBase();

  NullaryType copyWith();
}

@immutable
class _NullaryType extends _NullaryTypeBase with NullaryType {
  const _NullaryType.make();

  @override
  NullaryType copyWith() {
    return _NullaryType.make();
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    if (this.runtimeType != other.runtimeType) return false;
    return other is _NullaryType && true;
  }

  @override
  int get hashCode => 0;

  @override
  String toString() {
    return 'NullaryType()';
  }
}

/// This data class has been generated from CustomToString
abstract class CustomToStringFactory {
  static CustomToString make({
    required String foo,
    required String bar,
  }) {
    return _CustomToString.make(
      foo: foo,
      bar: bar,
    );
  }
}

abstract class _CustomToStringBase {
  const _CustomToStringBase();

  CustomToString copyWith({
    String? foo,
    String? bar,
  });
}

@immutable
class _CustomToString extends _CustomToStringBase with CustomToString {
  @override
  final String foo;
  @override
  final String bar;

  const _CustomToString.make({
    required this.foo,
    required this.bar,
  });

  @override
  CustomToString copyWith({
    String? foo,
    String? bar,
  }) {
    return _CustomToString.make(
      foo: foo ?? this.foo,
      bar: bar ?? this.bar,
    );
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    if (this.runtimeType != other.runtimeType) return false;
    return other is _CustomToString &&
        this.foo == other.foo &&
        this.bar == other.bar;
  }

  @override
  int get hashCode {
    var result = 17;
    result = 37 * result + this.foo.hashCode;
    result = 37 * result + this.bar.hashCode;
    return result;
  }
}

/// This data class has been generated from CustomEq
abstract class CustomEqFactory {
  static CustomEq make({
    required String foo,
    required String bar,
  }) {
    return _CustomEq.make(
      foo: foo,
      bar: bar,
    );
  }
}

abstract class _CustomEqBase {
  const _CustomEqBase();

  CustomEq copyWith({
    String? foo,
    String? bar,
  });
}

@immutable
class _CustomEq extends _CustomEqBase with CustomEq {
  @override
  final String foo;
  @override
  final String bar;

  const _CustomEq.make({
    required this.foo,
    required this.bar,
  });

  @override
  CustomEq copyWith({
    String? foo,
    String? bar,
  }) {
    return _CustomEq.make(
      foo: foo ?? this.foo,
      bar: bar ?? this.bar,
    );
  }

  @override
  String toString() {
    return 'CustomEq(foo: ${this.foo}, bar: ${this.bar})';
  }
}
