import 'package:flutter/widgets.dart';

class MetaballPhysicsState {
  MetaballPhysicsState({
    required this.velocity,
  });

  factory MetaballPhysicsState.from(
    MetaballPhysicsState oldState,
  ) {
    return MetaballPhysicsState(
      velocity: oldState.velocity,
    );
  }

  Offset velocity;
}
