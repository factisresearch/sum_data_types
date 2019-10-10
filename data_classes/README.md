Hey there!
If you're reading this and want data classes to become a language-level feature
of Dart, consider giving
[this issue](https://github.com/dart-lang/language/issues/314) a thumbs up. 👍

In the meantime, this library generates immutable data classes for you based on
simple blueprint mixing. Here's how to get started:

**1.** 📦 Add these packages to your dependencies:

```yaml
dependencies:
  data_classes: [insert newest version here]

dev_dependencies:
  build_runner: ^1.0.0
  data_classes_generator: [insert newest version here]
```

**2.** 🧬 Write a blueprint mixing. An example can be found in the `example` sub-project.
