import 'package:metaballs/src/models/metaball_state.dart';
import 'package:metaballs/src/models/metaballs_frame_data.dart';
import 'package:metaballs/src/models/metaballs_shader_data.dart';

import '_effects.dart';

/// This effect makes all metaballs increase and then decrease their radius in an outgoing ripple from a tab / mouse click
class MetaballsTabRippleEffect implements MetaballsEffect {
  MetaballsTabRippleEffect(
      {this.speed = 1, this.width = 1, this.growthFactor = 1, this.fade = const Duration(milliseconds: 1200)})
      : assert(speed > 0),
        assert(width > 0),
        assert(growthFactor > 0);

  /// The speed of the ripple effect
  final double speed;

  /// The the ripple width
  final double width;

  /// The amount by which the metaballs grow
  final double growthFactor;

  /// The time before the ripple is completely faded away
  final Duration fade;

  @override
  bool operator ==(Object other) =>
      other is MetaballsTabRippleEffect &&
      other.speed == speed &&
      other.width == width &&
      other.growthFactor == growthFactor &&
      other.fade == fade;

  @override
  int get hashCode => Object.hash(speed, width, growthFactor, fade);

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
