import 'dart:math';

import 'package:flutter/rendering.dart';
import 'package:metaballs/src/models/metaball.dart';
import 'package:metaballs/src/physics/interface/metaball_physics_state.dart';
import 'package:metaballs/src/physics/interface/metaballs_physics_scene.dart';

import 'bouncing_physics.dart';
import 'metaball_bouncing_physics_state.dart';

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
  void tickMetaball(Duration elapsed, Metaball metaball, MetaballBouncingPhysicsState? state) {
    // Should not happen as we always create a state.
    if (state == null) {
      return;
    }

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
    final bool outOfBoundsLeft = metaball.position.dx < 0 && directionX < 0;
    final bool outOfBoundsRight = metaball.position.dx > 1 && directionX > 0;
    if (outOfBoundsLeft || outOfBoundsRight) {
      state.direction = pi - state.direction;
    }

    final bool outOfBoundsTop = metaball.position.dy < 0 && directionY < 0;
    final bool outOfBoundsBottom = metaball.position.dy > 1 && directionY > 0;
    if (outOfBoundsTop || outOfBoundsBottom) {
      state.direction = -state.direction;
    }
  }

  @override
  void physicsConfigUpdated(BouncingPhysics oldConfig) {
    if (oldConfig.maxForce != config.maxForce) {
      visitMetaballs((Metaball metaball, MetaballBouncingPhysicsState? state) {
        if (state == null) {
          return;
        }

        state.force *= oldConfig.maxForce / config.maxForce;
      });
    }
  }
}
