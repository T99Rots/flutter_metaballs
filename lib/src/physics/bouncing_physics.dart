import 'dart:math';

import 'package:flutter/widgets.dart';
import 'package:metaballs/src/models/equalized_aspect_ratio.dart';
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
  _MetaballBouncingPhysicsState createState() {
    return _MetaballBouncingPhysicsState();
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

class _MetaballBouncingPhysicsState extends AdvancedMetaballPhysicsState<BouncingPhysics> {
  final Random _random = Random();

  late double force;
  late double direction;

  @override
  double get debugForceScale => 30 / physics.maxForce;

  @override
  double get friction => physics.friction;

  @override
  double get mass => physics.mass;

  @override
  void initState(MetaballStateAny? oldState) {
    if (oldState is _MetaballBouncingPhysicsState) {
      velocity = oldState.velocity;
      direction = oldState.direction;
      force = oldState.force;
    }

    direction = _random.nextDouble() * pi * 2;
    force = _random.nextDouble();

    if (oldState is AdvancedMetaballPhysicsState) {
      velocity = oldState.velocity;
    } else if (physics.hasInitialSpeed) {
      final double terminalVelocity = (force * physics.maxForce) / physics.friction;
      velocity = Offset(
        terminalVelocity * cos(direction),
        terminalVelocity * sin(direction),
      );
    } else {
      velocity = Offset.zero;
    }
  }

  @override
  void applyForces() {
    // Apply physics
    final EqualizedAspectRatio aspectRatio = scene.aspectRatio;
    final double directionX = cos(direction);
    final double directionY = sin(direction);
    final double forceRange = physics.maxForce - physics.minForce;
    final double scaledForce = physics.minForce + force * forceRange;

    applyForce(
      Offset(
        scaledForce * directionX * aspectRatio.x,
        scaledForce * directionY * aspectRatio.y,
      ),
      const Color(0x8000ff00),
    );

    // Ensure metaball stays in bounds
    final bool outOfBoundsLeft = metaball.position.dx < 0 && directionX < 0;
    final bool outOfBoundsRight = metaball.position.dx > 1 && directionX > 0;
    if (outOfBoundsLeft || outOfBoundsRight) {
      direction = _normalizeRadian(pi - direction);
    }

    final bool outOfBoundsTop = metaball.position.dy < 0 && directionY < 0;
    final bool outOfBoundsBottom = metaball.position.dy > 1 && directionY > 0;
    if (outOfBoundsTop || outOfBoundsBottom) {
      direction = _normalizeRadian(-direction);
    }
  }

  double _normalizeRadian(double radian) {
    // Normalize the radian to be within the range of 0 to 2 * pi
    radian = radian % (2 * pi);
    if (radian < 0) {
      radian += 2 * pi;
    }
    return radian;
  }
}
