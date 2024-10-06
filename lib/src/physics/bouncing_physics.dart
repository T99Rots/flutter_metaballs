import 'dart:math';

import 'package:flutter/widgets.dart';
import 'package:metaballs/src/models/equalized_aspect_ratio.dart';
import 'package:metaballs/src/models/metaball.dart';
import 'package:metaballs/src/physics/metaballs_physics.dart';

import 'advanced_metaball_physics.dart';

/// Applies bouncing physics to metaballs.
///
/// The `BouncingPhysics` class defines the physical properties and behaviors
/// of metaballs, including maximum force, friction, mass, and initial speed.
/// It allows for configuring these properties to simulate realistic bouncing
/// effects in a metaball animation, where the metaballs bounce off the edges
/// of the widget.
///
/// ```dart
/// BouncingPhysics(
///   maxForce: 1.0,
///   friction: 10.0,
///   metaballMass: 10.0,
///   hasInitialSpeed: true,
/// );
/// ```
///
/// This example creates a `BouncingPhysics` instance with a maximum force of
/// 1.0, a friction coefficient of 10.0, a metaball mass of 10.0, and initial
/// speed enabled. These settings will be applied to the metaballs to simulate
/// bouncing physics.
class BouncingPhysics extends MetaballsPhysics {
  const BouncingPhysics({
    this.maxForce = 1,
    this.minForce = 0,
    this.friction = 10,
    this.mass = 10,
    this.hasInitialSpeed = false,
  })  : assert(maxForce >= 0, 'maxForce can not be a negative value.'),
        assert(minForce >= 0, 'minForce can not be a negative value.'),
        assert(mass > 0, 'mass must be a positive value.'),
        assert(friction >= 0, 'friction can not be a negative value');

  /// The maximum force multiplier that can be applied to a metaball.
  ///
  /// A higher maximum force results in greater acceleration and a higher top
  /// speed for the metaballs.
  final double maxForce;

  /// The minimum force multiplier that can be applied to a metaball.
  ///
  /// A higher minimum force results in greater acceleration and a higher top
  /// speed for the metaballs.
  final double minForce;

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
  final double mass;

  /// Determines whether the metaball should be initialized with an initial speed.
  ///
  /// If true, the metaball's initial velocity will be set to its terminal velocity
  /// based on the applied force and friction coefficient. If false, the initial
  /// velocity will be set to zero or retained from the previous state.
  final bool hasInitialSpeed;

  @override
  _MetaballsBouncingPhysicsScene createScene() {
    return _MetaballsBouncingPhysicsScene();
  }

  @override
  int get hashCode => Object.hash(
        maxForce,
        minForce,
        friction,
        mass,
        hasInitialSpeed,
      );

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is BouncingPhysics && other.runtimeType == runtimeType && other.hashCode == hashCode;

  BouncingPhysics copyWith({
    double? maxForce,
    double? minForce,
    double? friction,
    double? metaballMass,
    bool? hasInitialSpeed,
  }) {
    return BouncingPhysics(
      maxForce: maxForce ?? this.maxForce,
      minForce: minForce ?? this.minForce,
      friction: friction ?? this.friction,
      mass: metaballMass ?? mass,
      hasInitialSpeed: hasInitialSpeed ?? this.hasInitialSpeed,
    );
  }
}

class _MetaballsBouncingPhysicsScene extends MetaballsPhysicsScene<BouncingPhysics, _MetaballBouncingPhysicsState>
    with AdvancedMetaballPhysicsSceneMixin<BouncingPhysics, _MetaballBouncingPhysicsState> {
  final Random _random = Random();

  @override
  _MetaballBouncingPhysicsState createState(MetaballPhysicsState? oldState) {
    if (oldState is _MetaballBouncingPhysicsState) {
      return oldState;
    }

    final double direction = _random.nextDouble() * pi * 2;
    final double force = _random.nextDouble();

    final Offset initialVelocity;
    if (oldState is AdvancedMetaballPhysicsState) {
      initialVelocity = oldState.velocity;
    } else if (physics.hasInitialSpeed) {
      final double terminalVelocity = (force * physics.maxForce) / physics.friction;
      initialVelocity = Offset(
        terminalVelocity * cos(direction),
        terminalVelocity * sin(direction),
      );
    } else {
      initialVelocity = Offset.zero;
    }

    return _MetaballBouncingPhysicsState(
      velocity: initialVelocity,
      direction: direction,
      force: force,
      mass: physics.mass,
    );
  }

  double _normalizeRadian(double radian) {
    // Normalize the radian to be within the range of 0 to 2 * pi
    radian = radian % (2 * pi);
    if (radian < 0) {
      radian += 2 * pi;
    }
    return radian;
  }

  @override
  void applyMetaballForces(Metaball metaball, _MetaballBouncingPhysicsState? state) {
    // Should not happen as we always create a state.
    if (state == null) {
      return;
    }

    // Apply physics
    final EqualizedAspectRatio aspectRatio = scene.aspectRatio;
    final double directionX = cos(state.direction);
    final double directionY = sin(state.direction);
    final double forceRange = physics.maxForce - physics.minForce;
    final double force = physics.minForce + state.force * forceRange;

    state.applyForce(
      Offset(
        force * directionX * aspectRatio.x,
        force * directionY * aspectRatio.y,
      ),
      const Color(0x8000ff00),
    );

    // Ensure metaball stays in bounds
    final bool outOfBoundsLeft = metaball.position.dx < 0 && directionX < 0;
    final bool outOfBoundsRight = metaball.position.dx > 1 && directionX > 0;
    if (outOfBoundsLeft || outOfBoundsRight) {
      state.direction = _normalizeRadian(pi - state.direction);
    }

    final bool outOfBoundsTop = metaball.position.dy < 0 && directionY < 0;
    final bool outOfBoundsBottom = metaball.position.dy > 1 && directionY > 0;
    if (outOfBoundsTop || outOfBoundsBottom) {
      state.direction = _normalizeRadian(-state.direction);
    }
  }

  @override
  void physicsUpdated(BouncingPhysics oldPhysics) {
    if (oldPhysics.mass != physics.mass) {
      visitMetaballs((Metaball metaball, _MetaballBouncingPhysicsState? state) {
        state?.mass = physics.mass;
      });
    }
  }

  @override
  double get debugForceScale => 30 / physics.maxForce;

  @override
  double get friction => physics.friction;
}

class _MetaballBouncingPhysicsState extends AdvancedMetaballPhysicsState {
  _MetaballBouncingPhysicsState({
    required super.velocity,
    required this.direction,
    required this.force,
    required super.mass,
  });

  /// The amount of force this metaball has.
  double force;

  /// The direction a metaball wants to move in in radians.
  double direction;
}
