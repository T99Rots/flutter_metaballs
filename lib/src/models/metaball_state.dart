import 'package:flutter/widgets.dart';

/// The internal state of the metaball.
class MetaballState {
  MetaballState({
    required this.direction,
    required this.velocity,
    required this.position,
  });

  /// The position of the metaball.
  final Offset position;

  /// The movement velocity of the metaball.
  final Offset velocity;

  /// The direction the metaball is moving in.
  final double direction;
}
