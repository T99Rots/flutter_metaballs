import 'dart:math';

import 'package:flutter/rendering.dart';
import 'package:metaballs/src/interfaces/_interfaces.dart';
import 'package:metaballs/src/physics/interface/metaball_physics_state.dart';
import 'package:metaballs/src/physics/interface/metaballs_physics_scene.dart';

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
  MetaballsBouncingPhysicsScene createPhysicsScene() {
    return MetaballsBouncingPhysicsScene();
  }
}

class MetaballsBouncingPhysicsScene extends MetaballsPhysicsScene<BouncingPhysics, MetaballBouncingPhysicsState> {
  final Random _random = Random();

  @override
  MetaballBouncingPhysicsState createState(MetaballPhysicsState? oldState) {
    if (oldState is MetaballBouncingPhysicsState) {
      return oldState;
    }

    final double direction = _random.nextDouble() * pi * 2;
    final double force = _random.nextDouble() * config.maxForce;

    Offset? initialVelocity = oldState?.velocity;
    if (initialVelocity == null) {
      if (config.hasInitialSpeed) {
        // Calculate terminal velocity
        final double terminalVelocity = force / config.friction;
        // Calculate velocity components based on direction
        final double velocityX = terminalVelocity * cos(direction);
        final double velocityY = terminalVelocity * sin(direction);
        initialVelocity = Offset(velocityX, velocityY);
      } else {
        initialVelocity = Offset.zero;
      }
    }

    return MetaballBouncingPhysicsState(
      velocity: initialVelocity,
      direction: direction,
      force: force,
    );
  }

  @override
  void updateMetaball(Duration elapsed, Metaball metaball, MetaballBouncingPhysicsState state) {
    final double dt = elapsed.inMilliseconds / 1000.0;

    // Calculate mass based on radius
    final double mass = metaball.radius * metaball.radius * config.massMultiplier;

    // Calculate direction components
    final double directionX = cos(state.direction);
    final double directionY = sin(state.direction);

    // Calculate acceleration
    final double ax = (state.force / mass) * directionX;
    final double ay = (state.force / mass) * directionY;

    // Update velocity with acceleration
    state.velocity = Offset(
      state.velocity.dx + ax * dt,
      state.velocity.dy + ay * dt,
    );

    // Apply friction
    final double speed = state.velocity.distance;
    final double frictionForce = config.friction * speed;
    final double frictionAx = (frictionForce / mass) * (state.velocity.dx / speed);
    final double frictionAy = (frictionForce / mass) * (state.velocity.dy / speed);

    state.velocity = Offset(
      state.velocity.dx - frictionAx * dt,
      state.velocity.dy - frictionAy * dt,
    );

    // Update position
    metaball.position = Offset(
      metaball.position.dx + state.velocity.dx * dt,
      metaball.position.dy + state.velocity.dy * dt,
    );

    // Ensure metaball stays in bounds
    final bool isOutOfBoundsLeft = metaball.position.dx < 0 && directionX < 0;
    final bool isOutOfBoundsRight = metaball.position.dx > 1 && directionX > 0;
    if (isOutOfBoundsLeft || isOutOfBoundsRight) {
      state.direction = pi - state.direction;
    }

    final bool isOutOfBoundsTop = metaball.position.dy < 0 && directionY < 0;
    final bool isOutOfBoundsBottom = metaball.position.dy > 1 && directionY > 0;
    if (isOutOfBoundsTop || isOutOfBoundsBottom) {
      state.direction = -state.direction;
    }
  }
}

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
