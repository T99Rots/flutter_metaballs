import 'dart:math';

Point<double> polarToCartesian(double theta, double r) {
  double x = r * cos(theta);
  double y = r * sin(theta);
  return Point(x, y);
}
