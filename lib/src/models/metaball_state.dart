import 'dart:math';

/// The internal state of the metaball.
class MetaballState {
  MetaballState({
    required this.direction,
    required this.velocity,
    required this.position,
  });

  /// The position of the metaball.
  final Point<double> position;

  /// The movement velocity of the metaball.
  final Point<double> velocity;

  /// The direction the metaball is moving in.
  final double direction;
}
