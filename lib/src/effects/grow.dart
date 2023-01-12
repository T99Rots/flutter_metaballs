import 'dart:math';

import 'package:metaballs/src/models/metaball_state.dart';
import 'package:metaballs/src/models/metaballs_frame_data.dart';
import 'package:metaballs/src/models/metaballs_shader_data.dart';
import 'package:metaballs/src/widgets/combined_listener.dart';

import '_effects.dart';

/// This effect increases the radius of all metaballs based on how close they are to the mouse cursor or a touch
class MetaballsMouseGrowEffect extends MetaballsEffect {
  MetaballsMouseGrowEffect({
    this.radius = 0.5,
    this.growthFactor = 0.5,
    this.smoothing = 1,
  })  : assert(smoothing >= 0 && smoothing <= 1),
        assert(radius > 0),
        assert(growthFactor > 0);

  /// The radius around the mouse / touch in which the metaballs get scaled up
  final double radius;

  /// The amount by which the metaballs increase in size
  final double growthFactor;

  /// The amount the movement gets smoothed
  final double smoothing;

  @override
  bool operator ==(Object other) =>
      other is MetaballsMouseGrowEffect &&
      other.growthFactor == growthFactor &&
      other.radius == radius &&
      other.smoothing == smoothing;

  @override
  int get hashCode => Object.hash(growthFactor, radius, smoothing);

  @override
  MetaballsMouseGrowEffectState createState() {
    return MetaballsMouseGrowEffectState();
  }
}

class MetaballsMouseGrowEffectState extends MetaballsEffectState<MetaballsMouseGrowEffect> {
  @override
  MetaballShaderData transformShaderData(
    MetaballFrameData frameData,
    MetaballState state,
    MetaballShaderData shaderData,
  ) {
    double combinedDistance = 0;

    for (final Pointer pointer in frameData.pointers) {
      combinedDistance += (pointer.position - shaderData.position).distance;
    }

    print(combinedDistance);

    return shaderData.copyWith(
      radius: max(
              1,
              1 +
                  effect.growthFactor -
                  ((combinedDistance / (frameData.canvasSize.shortestSide * effect.radius)) * effect.growthFactor)) *
          shaderData.radius,
    );
  }
}
