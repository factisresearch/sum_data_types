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
mixin User$ on _UserBase {
  String get name;
  Optional<int> get age;
  KtList<User$> get friends;

  int numerOfFriends() {
    return this.friends.size;
  }
}
```

The `@DataClass()` annotation trigger code generation for the mixin following the annotation.
The mixin should define getters for each property of the data type. The code generation
then generates code for `==`, `hashCode` and `toString`. Additionally, it generates
a `copyWith` method through which you can non-destructively modify some fields of an existing
object of the class (i.e. `copyWith` returns a copy of the object).

The name of the mixin must end with `$`. In the case above, for the mixin `User$`, an
abstract class `_UserBase` (declaring `copyWith`) and a concrete class `User` (defining
all the implementation methods) is generated.

## Use the generated class

You can then use the `User` class for instantiating objects. For example:

```dart
void main() {
  final userBob = User(
    name: "Bob",
    friends: KtList.empty(),
  );
  final userSarah = User(
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

## Attention with recursive types

If your blueprint mixin refers the the class being generated, you cannot directly
use the name of the class being generated. Instead, you have to use the name of the mixin.
That's why we wrote `KtList<User$>` for the type of the `friends` field in the example above.
If you do not follow this rule, you will get strange type errors involving the `dynamic` type
in the generated code. For example, if we wrote `KtList<User>` in the code above, we would
get the following rather strange looking error:

```
Error: The return type of the method 'User.friends' is 'KtList<dynamic>', which does not match
the return type, 'KtList<User>', of the overridden method, 'User$.friends'.
```
