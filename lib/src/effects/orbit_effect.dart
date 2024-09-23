import 'package:flutter/src/animation/curves.dart';
import 'package:metaballs/src/effects/mixins/animated_pointer_tracker_mixin.dart';

import 'metaballs_effect.dart';

class OrbitEffect extends MetaballsEffect {
  const OrbitEffect({
    required this.animationCurve,
    required this.animationDuration,
  });

  final Duration animationDuration;
  final Curve animationCurve;

  @override
  OrbitEffectState createState() => OrbitEffectState();
}

class OrbitEffectState extends MetaballsEffectState<OrbitEffect> with AnimatedPointerTrackerMixin<OrbitEffect> {
  @override
  Curve get animationCurve => effect.animationCurve;

  @override
  Duration get animationDuration => effect.animationDuration;

  @override
  void beforePhysics() {
    super.beforePhysics();
  }
}
