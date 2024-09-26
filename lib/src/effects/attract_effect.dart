import 'package:flutter/animation.dart';
import 'package:metaballs/src/effects/mixins/animated_pointer_tracker_mixin.dart';

import 'metaballs_effect.dart';

class AttractEffect extends MetaballsEffect {
  const AttractEffect({
    this.animationCurve = Curves.easeInOut,
    this.animationDuration = const Duration(milliseconds: 100),
  });

  final Duration animationDuration;
  final Curve animationCurve;

  @override
  _AttractEffectState createState() => _AttractEffectState();

  @override
  int get hashCode => Object.hash(
        animationDuration,
        animationCurve,
      );

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is AttractEffect && other.runtimeType == runtimeType && other.hashCode == hashCode;

  AttractEffect copyWith({
    Duration? animationDuration,
    Curve? animationCurve,
  }) {
    return AttractEffect(
      animationDuration: animationDuration ?? this.animationDuration,
      animationCurve: animationCurve ?? this.animationCurve,
    );
  }
}

class _AttractEffectState extends MetaballsEffectState<AttractEffect> with AnimatedPointerTrackerMixin<AttractEffect> {
  @override
  Curve get animationCurve => effect.animationCurve;

  @override
  Duration get animationDuration => effect.animationDuration;
}
