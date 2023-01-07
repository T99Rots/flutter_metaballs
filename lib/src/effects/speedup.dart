import '_effects.dart';

/// This effect makes all metaballs speedup relative to how fast you move your mouse or swipe on your touchscreen
class MetaballsSpeedupEffect extends MetaballsEffect {
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
  MetaballsSpeedupEffectState createState() {
    return MetaballsSpeedupEffectState();
  }
}

class MetaballsSpeedupEffectState extends MetaballsEffectState<MetaballsSpeedupEffect> {}
