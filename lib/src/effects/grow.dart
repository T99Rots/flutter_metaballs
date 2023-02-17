import 'dart:math';

import 'package:flutter/widgets.dart';
import 'package:metaballs/src/models/_models.dart';
import 'package:metaballs/src/widgets/combined_listener.dart';

import '_effects.dart';

/// This effect increases the radius of all metaballs based on how close they are to the mouse cursor or a touch
class MetaballsMouseGrowEffect extends MetaballsEffect {
  MetaballsMouseGrowEffect({
    this.radius = 40,
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
  final List<Pointer> _pointers = [];

  @override
  MetaballShaderData transformShaderData(
    MetaballFrameData frameData,
    Metaball metaball,
    MetaballShaderData shaderData,
  ) {
    double target = 1;
    for (final Pointer pointer in _pointers) {
      const double radius = 500.0;
      const double growthFactor = 1.5;
      final double distance = (pointer.position - shaderData.position).distance;
      final double distancePercentOfRadius = distance / (radius * frameData.scale);
      final double limitedInverseDistance = max(1 - distancePercentOfRadius, 0);
      final double ageScale = Curves.easeOut.transform(
        min(
          (frameData.time - pointer.createdTime) / 0.33,
          1,
        ),
      );
      final double computedScale = 1 + (growthFactor * limitedInverseDistance * ageScale);

      if (computedScale > target) target = computedScale;
    }

    return shaderData.copyWith(
      radius: target * shaderData.radius,
    );
  }

  @override
  void onPointerAdded(Pointer pointer) {
    _pointers.add(pointer);
    // pointer.l
  }
}
