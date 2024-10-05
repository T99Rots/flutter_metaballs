import 'dart:math';

import 'package:flutter/animation.dart';
import 'package:metaballs/src/effects/mixins/animated_pointer_tracker_mixin.dart';
import 'package:metaballs/src/models/metaball_render_data.dart';

import 'metaballs_effect.dart';

class GrowEffect extends MetaballsEffect {
  const GrowEffect({
    this.multiplier = 1.0,
    this.radius = 100,
    this.duration = const Duration(milliseconds: 300),
    this.curve = Curves.ease,
    this.pointerSmoothing = 0.3,
  });

  final double multiplier;
  final double radius;
  final double pointerSmoothing;
  final Duration duration;
  final Curve curve;

  @override
  MetaballsEffectState<GrowEffect> createState() => _GrowEffectState();

  @override
  int get hashCode => Object.hash(
        multiplier,
        radius,
        pointerSmoothing,
        duration,
        curve,
      );

  @override
  bool operator ==(Object other) =>
      identical(this, other) || other is GrowEffect && other.runtimeType == runtimeType && other.hashCode == hashCode;

  GrowEffect copyWith({
    double? multiplier,
    double? radius,
    double? pointerSmoothing,
    Duration? duration,
    Curve? curve,
  }) {
    return GrowEffect(
      multiplier: multiplier ?? this.multiplier,
      radius: radius ?? this.radius,
      pointerSmoothing: pointerSmoothing ?? this.pointerSmoothing,
      duration: duration ?? this.duration,
      curve: curve ?? this.curve,
    );
  }
}

class _GrowEffectState extends MetaballsEffectState<GrowEffect> with AnimatedPointerTrackerMixin<GrowEffect> {
  @override
  void beforeRender() {
    for (final MetaballRenderData metaball in scene.renderData) {
      double sum = 0.0;

      for (final PointerEffectData pointer in pointers) {
        final Offset(
          :double dx,
          :double dy,
        ) = metaball.position - pointer.position;
        final double radius = effect.radius;
        sum += (radius * radius * 0.5) / (dx * dx + dy * dy) * pointer.t;
      }

      metaball.radius *= 1 + (atan(sum) * effect.multiplier);
    }
  }

  @override
  Curve get animationCurve => effect.curve;

  @override
  Duration get animationDuration => effect.duration;

  @override
  double get pointerSmoothing => effect.pointerSmoothing;
}
