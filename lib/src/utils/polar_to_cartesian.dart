import 'dart:math';

Point<double> polarToCartesian(double theta, double r) {
  final double x = r * cos(theta);
  final double y = r * sin(theta);
  return Point<double>(x, y);
}
