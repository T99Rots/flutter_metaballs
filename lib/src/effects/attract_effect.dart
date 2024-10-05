import 'package:flutter/animation.dart';
import 'package:metaballs/src/effects/mixins/animated_pointer_tracker_mixin.dart';

import 'metaballs_effect.dart';

class AttractEffect extends MetaballsEffect {
  const AttractEffect({
    this.curve = Curves.easeInOut,
    this.duration = const Duration(milliseconds: 100),
    this.pointerSmoothing = 0,
  });

  final Duration duration;
  final Curve curve;
  final double pointerSmoothing;

  @override
  _AttractEffectState createState() => _AttractEffectState();

  @override
  int get hashCode => Object.hash(
        duration,
        curve,
        pointerSmoothing,
      );

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is AttractEffect && other.runtimeType == runtimeType && other.hashCode == hashCode;

  AttractEffect copyWith({
    Duration? duration,
    Curve? curve,
    double? pointerSmoothing,
  }) {
    return AttractEffect(
      duration: duration ?? this.duration,
      curve: curve ?? this.curve,
      pointerSmoothing: pointerSmoothing ?? this.pointerSmoothing,
    );
  }
}

class _AttractEffectState extends MetaballsEffectState<AttractEffect> with AnimatedPointerTrackerMixin<AttractEffect> {
  @override
  Curve get animationCurve => effect.curve;

  @override
  Duration get animationDuration => effect.duration;

  @override
  double get pointerSmoothing => effect.pointerSmoothing;
}
