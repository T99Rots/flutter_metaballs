import 'package:metaballs/src/models/metaball_state.dart';
import 'package:metaballs/src/models/metaballs_frame_data.dart';
import 'package:metaballs/src/models/metaballs_shader_data.dart';

import '_effects.dart';

/// This effect makes all metaballs speedup relative to how fast you move your mouse or swipe on your touchscreen
class MetaballsSpeedupEffect implements MetaballsEffect {
  MetaballsSpeedupEffect({
    this.speedup = 1,
  }) : assert(speedup > 0);

  /// The amount the metaballs speed up relative to the mouse / swipe speed
  final double speedup;

  @override
  bool operator ==(Object other) => other is MetaballsSpeedupEffect && other.speedup == speedup;

  @override
  int get hashCode => speedup.hashCode;

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
