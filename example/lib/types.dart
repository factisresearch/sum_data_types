class Address {
  String toString() {
    return "SomeAddress";
  }

  @override
  int get hashCode => 0;

  bool operator ==(Object other) {
    return (other is Address && runtimeType == other.runtimeType);
  }
}
