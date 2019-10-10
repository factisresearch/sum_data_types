This dart library generates immutable data classes with structural equality from
a blueprint mixin.
Also see [this issue](https://github.com/dart-lang/language/issues/314).

# Installation

Add these packages to your dependencies:

```yaml
dependencies:
  sum_data_types: [insert newest version here]

dev_dependencies:
  build_runner: ^1.7.0
  sum_data_types_generator: [insert newest version here]
```

# Usage

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

You create instances of the data class by using the also generated `makeUser` function:

```dart
void main() {
  final userBob = makeUser(
    name: "Bob",
    friends: KtList.empty(),
  );
  final userSarah = makeUser(
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
