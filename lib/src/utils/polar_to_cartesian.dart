import 'dart:math';

import 'package:flutter/widgets.dart';

Offset polarToCartesian(double theta, double r) {
  final double x = r * cos(theta);
  final double y = r * sin(theta);
  return Offset(x, y);
}
