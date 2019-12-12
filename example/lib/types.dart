class Address {
  @override
  String toString() {
    return 'SomeAddress';
  }

  @override
  int get hashCode => 0;

  @override
  bool operator ==(Object other) {
    return (other is Address && runtimeType == other.runtimeType);
  }
}
