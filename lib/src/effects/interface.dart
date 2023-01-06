import 'package:metaballs/src/models/_models.dart';

import '_effects.dart';

abstract class MetaballsEffect {
  /// Effect which adds a metaball for every cursor / touch and then follows that cursor / touch around.
  factory MetaballsEffect.follow({
    double smoothing = 1,
    double growthFactor = 1,
    double? radius,
  }) {
    return MetaballsFollowMouseEffect(
      smoothing: smoothing,
      growthFactor: growthFactor,
      radius: radius,
    );
  }

  /// Effect which makes all metaballs speedup relative to how fast you move your mouse or swipe on your touchscreen.
  factory MetaballsEffect.speedup({
    double speedup = 1,
  }) {
    return MetaballsSpeedupEffect(
      speedup: speedup,
    );
  }

  /// Effect which increases the radius of all metaballs based on how close they are to the mouse cursor or a touch.
  factory MetaballsEffect.grow({
    double radius = 0.5,
    double growthFactor = 0.5,
    double smoothing = 1,
  }) {
    return MetaballsMouseGrowEffect(
      radius: radius,
      growthFactor: growthFactor,
      smoothing: smoothing,
    );
  }

  /// Effect which makes all metaballs increase and then decrease their radius in an outgoing ripple from a tab / mouse click.
  factory MetaballsEffect.ripple({
    double speed = 1,
    double width = 1,
    double growthFactor = 1,
    Duration fade = const Duration(seconds: 2),
  }) {
    return MetaballsTabRippleEffect(
      fade: fade,
      growthFactor: growthFactor,
      speed: speed,
      width: width,
    );
  }
  MetaballShaderData transformShaderData(
    MetaballFrameData frameData,
    MetaballState state,
    MetaballShaderData shaderData,
  ) {
    return shaderData;
  }

  MetaballState transformState(
    MetaballFrameData frameData,
    MetaballState state,
    MetaballState oldState,
  ) {
    return state;
  }
}

abstract class EffectState {}
