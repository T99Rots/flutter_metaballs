import 'package:flutter/widgets.dart';

class MetaBallComputedState {
  final double x;
  final double y;
  final double r;

  MetaBallComputedState({
    required this.x,
    required this.y,
    required this.r,
  });
}

class ColorAndGradient {
  final Color color;
  final Gradient? gradient;

  ColorAndGradient({
    this.gradient,
    required this.color,
  });
}
