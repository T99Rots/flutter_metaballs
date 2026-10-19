import 'package:metaballs/src/physics/interface/metaball_physics_state.dart';

class MetaballBouncingPhysicsState extends MetaballPhysicsState {
  MetaballBouncingPhysicsState({
    required super.velocity,
    required this.direction,
    required this.force,
  });

  /// The amount of force this metaball has.
  double force;

  /// The direction a metaball wants to move in in radians.
  double direction;
}
