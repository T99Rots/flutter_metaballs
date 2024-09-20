import 'dart:math';

import 'package:flutter/src/animation/curves.dart';
import 'package:metaballs/src/effects/interface/metaballs_effect.dart';
import 'package:metaballs/src/effects/mixins/animated_pointer_tracker_mixin.dart';
import 'package:metaballs/src/models/metaball_render_data.dart';

class GrowEffect extends MetaballsEffect {
  const GrowEffect({
    this.multiplier = 1.0,
    this.radius = 100,
    this.duration = const Duration(milliseconds: 300),
    this.curve = Curves.ease,
    this.movementSmoothing = 0.3,
  });

  final double multiplier;
  final double radius;
  final double movementSmoothing;
  final Duration duration;
  final Curve curve;

  @override
  MetaballsEffectState<GrowEffect> createState() => GrowEffectState();
}

class GrowEffectState extends MetaballsEffectState<GrowEffect> with AnimatedPointerTrackerMixin<GrowEffect> {
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
  double get pointerSmoothing => effect.movementSmoothing;
}
