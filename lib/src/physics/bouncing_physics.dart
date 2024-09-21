import 'dart:math';
import 'dart:ui';

import 'package:metaballs/src/models/metaball.dart';
import 'package:metaballs/src/physics/metaballs_physics.dart';

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
///   maxForce: 10.0,
///   friction: 0.5,
///   metaballMass: 1.0,
///   hasInitialSpeed: true,
/// );
/// ```
///
/// This example creates a `BouncingPhysics` instance with a maximum force of
/// 10.0, a friction coefficient of 0.5, a metaball mass multiplier of 1.0,
/// and initial speed enabled. These settings will be applied to the metaballs
/// to simulate bouncing physics.
class BouncingPhysics extends MetaballsPhysics {
  const BouncingPhysics({
    this.maxForce = 1,
    this.friction = 100,
    this.metaballMass = 10,
    this.hasInitialSpeed = false,
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
  final double metaballMass;

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
}

class _MetaballsBouncingPhysicsScene extends MetaballsPhysicsScene<BouncingPhysics, _MetaballBouncingPhysicsState> {
  final Random _random = Random();

  @override
  _MetaballBouncingPhysicsState createState(MetaballPhysicsState? oldState) {
    if (oldState is _MetaballBouncingPhysicsState) {
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

    return _MetaballBouncingPhysicsState(
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
  void tickMetaball(Duration frameTime, Metaball metaball, _MetaballBouncingPhysicsState? state) {
    // Should not happen as we always create a state.
    if (state == null) {
      return;
    }

    final double dt = frameTime.inMilliseconds / 1000.0;

    // Calculate direction components
    final double directionX = cos(state.direction);
    final double directionY = sin(state.direction);

    final double accelerationOverDt = config.maxForce * dt;

    // Update velocity with acceleration
    state.velocity = Offset(
      state.velocity.dx +
          ((-config.friction * state.velocity.dx * dt) / config.metaballMass) +
          (accelerationOverDt * directionX),
      state.velocity.dy +
          ((-config.friction * state.velocity.dy * dt) / config.metaballMass) +
          (accelerationOverDt * directionY),
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
      visitMetaballs((Metaball metaball, _MetaballBouncingPhysicsState? state) {
        if (state == null) {
          return;
        }

        state.force *= oldConfig.maxForce / config.maxForce;
      });
    }
  }
}

class _MetaballBouncingPhysicsState extends MetaballPhysicsState {
  _MetaballBouncingPhysicsState({
    required super.velocity,
    required this.direction,
    required this.force,
  });

  /// The amount of force this metaball has.
  double force;

  /// The direction a metaball wants to move in in radians.
  double direction;
}
