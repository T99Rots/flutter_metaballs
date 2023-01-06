import 'package:metaballs/src/models/metaball_state.dart';
import 'package:metaballs/src/models/metaballs_frame_data.dart';
import 'package:metaballs/src/models/metaballs_shader_data.dart';

import '_effects.dart';

/// This effect adds a metaball for every cursor / touch and then follows that cursor / touch around
class MetaballsFollowMouseEffect implements MetaballsEffect {
  MetaballsFollowMouseEffect({
    this.smoothing = 1,
    this.radius,
    this.growthFactor = 1,
  })  : assert(smoothing >= 0),
        assert(growthFactor >= 0),
        assert(radius == null || radius >= 0);

  /// The amount the metaballs movement gets smoothed
  final double smoothing;

  /// The size of the following metaballs where 0 is the minBallRadius and 1 is the maxBallRadius
  final double? radius;

  /// The amount the metaballs grow relative to their movement speed
  final double growthFactor;

  @override
  bool operator ==(Object other) =>
      other is MetaballsFollowMouseEffect &&
      other.smoothing == smoothing &&
      other.radius == radius &&
      other.growthFactor == growthFactor;

  @override
  int get hashCode => Object.hash(smoothing, radius, growthFactor);

  @override
  MetaballShaderData transformShaderData(
      MetaballFrameData frameData, MetaballState state, MetaballShaderData shaderData) {
    // TODO: implement transformShaderData
    throw UnimplementedError();
  }

  @override
  MetaballState transformState(MetaballFrameData frameData, MetaballState state, MetaballState oldState) {
    // TODO: implement transformState
    throw UnimplementedError();
  }
}
