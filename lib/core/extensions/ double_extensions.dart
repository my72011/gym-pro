extension DoubleX on double {
  String toAmountString({int fractionDigits = 2}) {
    return toStringAsFixed(fractionDigits);
  }

  bool get isNearZero => abs() < 0.001;
}