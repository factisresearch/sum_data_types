# Sum Types and Data Classes for Dart

[![Build Status](https://travis-ci.com/factisresearch/sum_data_types.svg?branch=master)](https://travis-ci.com/factisresearch/sum_data_types)

This dart library generates immutable data classes and classes for sum types from
a blueprint mixin. The generated class define structural equality and `hashCode`. They
also provide a meaningful implementation of `toString`.
Also see [this issue](https://github.com/dart-lang/language/issues/314).

The library is influence by the [data_classes](https://pub.dev/packages/data_classes)
and the [sum_types](https://github.com/werediver/sum_types.dart)
libraries. However, their interfaces are different, so we created a new package.

# Installation

Add these packages to your dependencies:

```yaml
dependencies:
  sum_data_types: [insert newest version here]

dev_dependencies:
  build_runner: ^1.7.0
  sum_data_types_generator: [insert newest version here]
```

# Data Classes

A data class is similar to an immutable record. The fields of a data class are used to define
equality and `hashCode` in a structural way.

## Define a blueprint mixin

Here is an example:

```dart
import 'package:sum_data_types/main.dart';
import 'package:quiver/core.dart';
import 'package:kt_dart/collection.dart';

@DataClass()
mixin User on _UserBase {
  String get name;
  Optional<int> get age;
  KtList<User> get friends;

  int numerOfFriends() {
    return this.friends.size;
  }
}
```

The `@DataClass()` annotation triggers generation of the data class from the mixin
following the annotation.
The mixin should define getters for each property of the data class. The code generation
then generates code for `==` (structural equality), `hashCode` and `toString`.
Additionally, it generates
a `copyWith` method through which you can non-destructively modify some fields of an existing
object of the class (i.e. `copyWith` returns a copy of the object).

## Use the generated class

You create instances of the data class by using the static `make` method of the
also generated `UserFactory` class.

```dart
void main() {
  final userBob = UserFactory.make(
    name: "Bob",
    friends: KtList.empty(),
  );
  final userSarah = UserFactory.make(
    name: "Sarah",
    friends: KtList.empty(userBob),
    age: 31,
  );
}
```

## Optional fields

Fields are optional if their type is `Optional<...>`, where `Optional` comes from
the [quiver.core](https://api.flutter.dev/flutter/quiver.core/Optional-class.html) library.
It is recommended to use immutable collections, for example from the
[kt.dart](https://github.com/passsy/kt.dart) package. You can also use the builtin collections
such as `List``, but their equality is based on pointer-equality and not on structural equality.

# Sum Types

A sum type combines various alternatives of types under a new type. The generated code
defines switching functiosn for distinguishing between the different alternatives.

## Define a blueprint mixin

Here is an example:

```dart
import 'package:sum_data_types/main.dart';

@SumType()
mixin Either<A, B> on _EitherBase<A, B> {
  A get _left;
  B get _right;
}
```

The `@SumType()` annotation triggers generation of the data class from the mixin
following the annotation.
The mixin should define getters for each alternative of the sum type. The name
of the getters must start with an underscore. The code generation
then generates code for `==` (structural equality), `hashCode` and `toString`.
Additionally, it generates
`iswitch` and `iswitcho` methods which you can use to switch over the various alternatives.
Here is an example use of the `iswitch` method:

```dart
void foo(Either<String, int> x) {
  x.iswitch(
    left: (s) => print("String: " + s),
    right: (i) => print("int: " + i.toString())
  );
}
```

The `iswitcho` method has an additional `otherwise` label, so you do not have to cover
all cases when using `iswitcho`.

## Use the generated class

You create instances of the data class by using the static `left` and `right` methods of the
also generated `EitherFactor` class.

```dart
EitherFactory.right(42)
```
