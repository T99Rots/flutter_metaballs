import 'dart:math';

import 'package:flutter/widgets.dart';
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
    this.friction = 10,
    this.mass = 10,
    this.hasInitialSpeed = false,
  })  : assert(maxForce >= 0, 'maxForce can not be a negative value.'),
        assert(mass > 0, 'mass must be a positive value.'),
        assert(friction >= 0, 'friction can not be a negative value');

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
    double? friction,
    double? metaballMass,
    bool? hasInitialSpeed,
  }) {
    return BouncingPhysics(
      maxForce: maxForce ?? this.maxForce,
      friction: friction ?? this.friction,
      mass: metaballMass ?? mass,
      hasInitialSpeed: hasInitialSpeed ?? this.hasInitialSpeed,
    );
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
    final double force = _random.nextDouble();

    Offset? initialVelocity = oldState?.velocity;
    if (initialVelocity == null) {
      if (config.hasInitialSpeed) {
        // Calculate terminal velocity
        final double terminalVelocity = (force * config.maxForce) / config.friction;
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
      mass: config.mass,
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

    // Apply physics
    final double deltaTime = frameTime.inMicroseconds / 1e6;
    final double aspectRatio = scene.hasSize ? scene.viewportSize.aspectRatio : 1;
    final double yRatio = sqrt(1 / aspectRatio);
    final double xRatio = aspectRatio * yRatio;
    final double directionX = cos(state.direction);
    final double directionY = sin(state.direction);
    final double force = state.force * config.maxForce;

    state.forceVector = Offset(
      force * directionX * xRatio,
      force * directionY * yRatio,
    );
    state.resistanceVector = Offset(
      -state.velocity.dx * config.friction * xRatio,
      -state.velocity.dy * config.friction * yRatio,
    );

    final Offset netForce = state.forceVector + state.resistanceVector;
    final Offset acceleration = Offset(
      netForce.dx / config.mass / xRatio,
      netForce.dy / config.mass / yRatio,
    );

    state.velocity = Offset(
      state.velocity.dx + acceleration.dx * deltaTime,
      state.velocity.dy + acceleration.dy * deltaTime,
    );
    metaball.position = Offset(
      metaball.position.dx + state.velocity.dx * deltaTime,
      metaball.position.dy + state.velocity.dy * deltaTime,
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
  void debugPaint(PaintingContext context, Offset offset) {
    assert(() {
      final Canvas canvas = context.canvas;
      final Paint forcePaint = Paint()
        ..color = const Color(0x8000ff00)
        ..strokeWidth = 2;
      final Paint resistancePaint = Paint()
        ..color = const Color(0x80ff0000)
        ..strokeWidth = 2;

      visitMetaballs((Metaball metaball, _MetaballBouncingPhysicsState? state) {
        if (state == null || config.maxForce <= 0) {
          return;
        }

        final Offset realPosition = metaball.transform.transformPosition(metaball.position) + offset;
        final double scale = 30 / config.maxForce;

        canvas.drawLine(
          realPosition,
          realPosition + (state.forceVector * scale),
          forcePaint,
        );
        canvas.drawLine(
          realPosition,
          realPosition + (state.resistanceVector * scale),
          resistancePaint,
        );
      });

      return true;
    }());
  }

  @override
  void physicsConfigUpdated(BouncingPhysics oldConfig) {
    print('${oldConfig.maxForce} => ${config.maxForce}');
  }
}

class _MetaballBouncingPhysicsState extends MetaballPhysicsState {
  _MetaballBouncingPhysicsState({
    required super.velocity,
    required this.direction,
    required this.force,
    required this.mass,
  });

  /// A vector representing the resistance applied to the metaball.
  Offset resistanceVector = Offset.zero;

  /// A vector representing the force applied to the metaball.
  Offset forceVector = Offset.zero;

  /// The amount of force this metaball has.
  double force;

  /// The mass of this metaball.
  double mass;

  /// The direction a metaball wants to move in in radians.
  double direction;
}
