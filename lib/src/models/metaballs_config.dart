import 'package:flutter/widgets.dart';
import 'package:metaballs/src/effects/_effects.dart';

import '_models.dart';

class MetaballsConfig {
  MetaballsConfig({
    this.animationDuration = const Duration(milliseconds: 200),
    this.radius = const Range(min: 15, max: 40),
    this.speed = const Range.fromValue(1),
    this.color = const Color(0xff4285F4),
    this.effects,
    this.glowRadius = 0.7,
    this.glowIntensity = 0.6,
    this.bounceIntensity = 3,
    this.metaballs = 40,
    this.gradient,
  })  : assert(speed.min >= 0),
        assert(bounceIntensity > 0),
        assert(radius.min >= 0),
        assert(glowRadius >= 0 && glowRadius <= 1),
        assert(glowIntensity >= 0 && glowIntensity <= 1),
        assert(metaballs > 0 && metaballs <= 128);

  /// A multiplier range of the ball radius.
  final Range radius;

  /// A multiplier range of the ball movement speed.
  final Range speed;

  /// A multiplier to change the speed at which balls change direction.
  final double bounceIntensity;

  /// The color of the metaballs.
  final Color color;

  /// A gradient for coloring the metaballs, overwrites color.
  final Gradient? gradient;

  /// A multiplier to indicate the radius of the glow.
  final double glowRadius;

  /// The brightness of the glow around the ball.
  final double glowIntensity;

  /// The duration of the color changing animation.
  final Duration animationDuration;

  /// The amount of metaballs.
  final int metaballs;

  /// The animated effect applied to the metaballs.
  final List<MetaballsEffect>? effects;
}
