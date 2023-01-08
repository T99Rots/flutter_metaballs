import 'dart:math';

extension DoubleExtensions on double {
  double roundToPrecision(int precision) {
    final num mod = pow(10.0, precision);
    return ((this * mod).round().toDouble() / mod);
  }
}
