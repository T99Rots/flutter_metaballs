import 'package:metaballs/src/physics/interface/metaballs_physics.dart';

import 'metaballs_bouncing_physics_scene.dart';

class BouncingPhysics extends MetaballsPhysics {
  const BouncingPhysics({
    required this.maxForce,
    required this.friction,
    required this.massMultiplier,
    required this.hasInitialSpeed,
  });

  /// The maximum force that can be applied to a metaball for acceleration.
  ///
  /// A higher max force results in greater acceleration and a higher top speed
  /// for the metaballs.
  final double maxForce;

  /// The friction coefficient that affects the metaball's motion.
  ///
  /// A higher friction value results in greater resistance, reducing the
  /// metaball's top speed.
  final double friction;

  /// Multiplier used to calculate the mass of a metaball based on its radius.
  ///
  /// The mass determines the amount of force required to move the metaball.
  /// A higher mass multiplier means more force is needed to achieve the same
  /// acceleration.
  final double massMultiplier;

  /// Determines whether the metaball should be initialized with an initial speed.
  ///
  /// If true, the metaball's initial velocity will be set to its terminal velocity
  /// based on the applied force and friction coefficient. If false, the initial
  /// velocity will be set to zero or retained from the previous state.
  final bool hasInitialSpeed;

  @override
  MetaballsBouncingPhysicsScene createScene() {
    return MetaballsBouncingPhysicsScene();
  }
}
