import 'dart:math';

import 'package:flutter/src/gestures/events.dart';
import 'package:metaballs/src/effects/interface/metaballs_effect.dart';

/// Applies a speedup effect to metaballs based on user interactions.
///
/// The `SpeedupEffect` class accelerates metaballs in response to user inputs
/// like mouse movements or touch gestures. It allows for configuring the maximum
/// speedup factor and the rate at which the speedup occurs.
///
/// ```dart
/// SpeedupEffect(
///   maxSpeedup: 5.0,
///   speedupRate: 1.5,
/// );
/// ```
///
/// This example creates a `SpeedupEffect` with a maximum speedup factor of 5.0
/// and a speedup rate of 1.5, which will be applied to the metaballs during
/// user interactions.
class SpeedupEffect extends MetaballsEffect {
  const SpeedupEffect({
    this.maxSpeedup = 5.0,
    this.speedupRate = 1,
  });

  /// The maximum speedup factor for the metaballs effect.
  ///
  /// This variable defines the upper limit for how much the metaballs can speed up
  /// relative to the user's mouse or swipe speed. It ensures that the speedup effect
  /// does not exceed a certain threshold.
  final double maxSpeedup;

  /// The rate at which the metaballs speed up.
  ///
  /// This variable determines how quickly the metaballs accelerate in response
  /// to user interactions, such as mouse movements or touch gestures. It controls
  /// the sensitivity of the speedup effect, allowing for fine-tuning of the
  /// animation's responsiveness.
  final double speedupRate;

  @override
  MetaballsEffectState<SpeedupEffect> createState() {
    return SpeedupEffectState();
  }
}

class SpeedupEffectState extends MetaballsEffectState<SpeedupEffect> {
  final Map<int, double> _pointerFrameDeltas = <int, double>{};

  @override
  void handlePointerEvent(PointerEvent event) {
    double delta = event.localDelta.distance;
    final double? currentDelta = _pointerFrameDeltas[event.pointer];
    if (currentDelta != null) {
      delta += currentDelta;
    }

    _pointerFrameDeltas[event.pointer] = delta;
  }

  @override
  double getTimeScale() {
    // Calculate average delta
    if (_pointerFrameDeltas.isEmpty) {
      return 1;
    }

    double sum = 0;
    for (double delta in _pointerFrameDeltas.values) {
      sum += delta;
    }

    final double averageDelta = sum / _pointerFrameDeltas.length;
    final double scale = min(effect.maxSpeedup, 1 + effect.speedupRate * log(averageDelta + 1) / log(10));

    _pointerFrameDeltas.clear();

    return scale;
  }
}
