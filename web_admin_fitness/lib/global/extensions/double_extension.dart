extension DoubleExt on double {
  String toStringWithNoZero() {
    return toStringAsFixed(this == toInt() ? 0 : 1);
  }
}
