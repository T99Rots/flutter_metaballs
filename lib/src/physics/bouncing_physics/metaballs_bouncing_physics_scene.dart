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

  double _normalizeRadian(double radian) {
    // Normalize the radian to be within the range of 0 to 2 * pi
    radian = radian % (2 * pi);
    if (radian < 0) {
      radian += 2 * pi;
    }
    return radian;
  }

  @override
  void tickMetaball(Duration elapsed, Metaball metaball, MetaballBouncingPhysicsState? state) {
    // Should not happen as we always create a state.
    if (state == null) {
      return;
    }

    final double dt = elapsed.inMilliseconds / 1000.0;

    // Calculate direction components
    final double directionX = cos(state.direction);
    final double directionY = sin(state.direction);

    final double accelerationOverDt = config.maxForce * dt;

    // Update velocity with acceleration
    state.velocity = Offset(
      state.velocity.dx + (-config.friction * state.velocity.dx) + (accelerationOverDt * directionX),
      state.velocity.dy + (-config.friction * state.velocity.dy) + (accelerationOverDt * directionY),
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
      state.direction = _normalizeRadian(pi - state.direction);
    }

    final bool outOfBoundsTop = metaball.position.dy < 0 && directionY < 0;
    final bool outOfBoundsBottom = metaball.position.dy > 1 && directionY > 0;
    if (outOfBoundsTop || outOfBoundsBottom) {
      state.direction = _normalizeRadian(-state.direction);
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
