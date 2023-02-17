import 'dart:math';

import 'package:flutter/widgets.dart';
import 'package:metaballs/src/effects/interface.dart';
import 'package:metaballs/src/utils/_utils.dart';

import '_models.dart';

const double _defaultMultiplier = 0.07;

class Metaball {
  Metaball({
    required this.speed,
    required this.radius,
    required MetaballState initialState,
  }) : state = initialState;

  factory Metaball.withRandomValues() {
    final Random random = Random();

    final double direction = random.nextDouble() * pi * 2;
    final double speed = random.nextDouble();

    return Metaball(
      initialState: MetaballState(
        direction: direction,
        position: Offset(
          random.nextDouble(),
          random.nextDouble(),
        ),
        velocity: polarToCartesian(direction, speed),
      ),
      radius: random.nextDouble(),
      speed: speed,
    );
  }

  /// The current metaball state.
  MetaballState state;

  /// The speed of the metaball in a range of 0 to 1.
  final double speed;

  /// The radius of the metaball in a range of 0 to 1.
  final double radius;

  void computeNewState(MetaballFrameData frameData) {
    // Extract the state values so we can modify them.
    double x = state.position.dx;
    double y = state.position.dy;
    double xVelocity = state.velocity.dx;
    double yVelocity = state.velocity.dy;
    double direction = state.direction;

    final double aspectRatio = frameData.canvasSize.aspectRatio;

    final double interpolatedSpeed = frameData.config.speed.interpolate(speed);

    // Calculate the movementMultiplier.
    // frameData.speedMultiplier should already have frame time included.
    final double movementMultiplier = frameData.speedMultiplier * _defaultMultiplier * interpolatedSpeed;

    // Compute new the new position.
    x += (xVelocity / aspectRatio) * movementMultiplier;
    y += yVelocity * movementMultiplier;

    // Flip the direction if the direction of the metaball is out of bounds and
    // the direction is going towards a out of bounds direction.
    Offset targetVelocity = polarToCartesian(direction, interpolatedSpeed);

    if ((x < 0 && targetVelocity.dx < 0) || (x > 1 && targetVelocity.dx > 0)) {
      direction = reflectRadian(direction, Axis.vertical);
      targetVelocity = polarToCartesian(direction, interpolatedSpeed);
    }

    if ((y < 0 && targetVelocity.dy < 0) || (y > 1 && targetVelocity.dy > 0)) {
      direction = reflectRadian(direction, Axis.horizontal);
      targetVelocity = polarToCartesian(direction, interpolatedSpeed);
    }

    // Update the velocity based on target velocity.
    xVelocity = transformValueOverTime(
      xVelocity,
      targetVelocity.dx,
      movementMultiplier,
      frameData.config.bounceIntensity,
    );

    yVelocity = transformValueOverTime(
      yVelocity,
      targetVelocity.dy,
      movementMultiplier,
      frameData.config.bounceIntensity,
    );

    // Create new state.
    state = MetaballState(
      direction: direction,
      velocity: Offset(xVelocity, yVelocity),
      position: Offset(x, y),
    );

    // Apply the effects if there are any.
    for (final MetaballsEffectState<MetaballsEffect> effect in frameData.effects) {
      state = effect.transformState(frameData, this, state);
    }
  }

  MetaballShaderData computeShaderData(MetaballFrameData frameData) {
    final double computedRadius = frameData.config.radius.interpolate(radius) * frameData.scale;
    final double diameter = computedRadius * 2;

    MetaballShaderData shaderData = MetaballShaderData(
      radius: computedRadius,
      position: Offset(
        ((frameData.canvasSize.width - diameter) * state.position.dx) + computedRadius,
        ((frameData.canvasSize.height - diameter) * state.position.dy) + computedRadius,
      ),
    );

    // Apply the effects if there are any.
    for (final MetaballsEffectState<MetaballsEffect> effect in frameData.effects) {
      shaderData = effect.transformShaderData(frameData, this, shaderData);
    }

    return shaderData;
  }
}
