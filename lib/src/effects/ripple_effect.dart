import 'dart:math';
import 'dart:ui';

import 'package:flutter/gestures.dart';
import 'package:metaballs/src/models/metaball_render_data.dart';

import 'metaballs_effect.dart';

/// Creates a ripple effect with metaballs.
///
/// This class defines a ripple effect that propagates through metaballs,
/// allowing customization of speed, width, radius multiplier, distance
/// multiplier, and punch.
///
/// Example:
/// ```dart
/// RippleEffect(
///   speed = 0.5,
///   width = 0.9,
///   radiusMultiplier = 0.5,
///   distanceMultiplier = 0.15,
///   punch = 7,
/// );
/// ```
///
/// In this example, a `RippleEffect` instance is created with custom
/// values for speed, width, radius multiplier, distance multiplier,
/// and punch.
class RippleEffect extends MetaballsEffect {
  const RippleEffect({
    this.speed = 0.45,
    this.width = 0.8,
    this.radiusMultiplier = 0.45,
    this.distanceMultiplier = 0.1,
    this.punch = 6,
  });

  /// Speed of ripple propagation.
  ///
  /// This variable defines the speed at which the ripple propagates
  /// through the metaballs. It is calculated as a percentage of the
  /// widget's diagonal length moved per second. Typically, this value
  /// is a positive double, where higher values indicate faster
  /// propagation. Adjusting this value will affect the speed of the
  /// ripple effect.
  final double speed;

  /// Width of the ripple effect.
  ///
  /// This variable defines the width of the ripple effect, calculated as
  /// a percentage of the widget's diagonal length. Typically, this value
  /// is a positive double, where a value of 1.0 represents 100% of the
  /// diagonal. Adjusting this value will change the size of the ripple
  /// effect relative to the widget's dimensions.
  final double width;

  /// Multiplier added to the metaball radius during the ripple.
  ///
  /// This variable defines the highest multiplier added to the metaball
  /// radius during the ripple effect. Typically, this value is a positive
  /// double, where a value of 0 means no change, and a value of 1 means an
  /// increase by 100%. Adjusting this value will affect the visual intensity
  /// of the ripple effect.
  final double radiusMultiplier;

  /// Multiplier for the maximum metaball distance multiplier from ripple origin.
  ///
  /// This variable defines the highest multiplier applied to the metaball
  /// distance from the ripple origin during the ripple effect. It scales the
  /// distance based on the wave point calculation. Typical values range from
  /// 0.05 to 0.2, where higher values result in a more pronounced ripple effect.
  final double distanceMultiplier;

  /// Ratio of ramp up and decay speed of the ripple.
  ///
  /// This variable controls the ratio between the ramp up and decay speeds
  /// of the ripple effect. A higher value results in a faster ramp up and a
  /// slower decay. Typical values range from 1 to 10, where higher values
  /// create a more pronounced difference between ramp up and decay times.
  final double punch;

  @override
  _RippleEffectState createState() => _RippleEffectState();
}

class _RippleEffectState extends MetaballsEffectState<RippleEffect> {
  final Set<_Ripple> _ripples = <_Ripple>{};

  void handlePointerEvent(PointerEvent event) {
    if (event is PointerDownEvent) {
      _ripples.add(
        _Ripple(
          added: scene.elapsed,
          origin: event.localPosition.getUV(scene.viewportSize),
        ),
      );
    }
  }

  double _getWavePoint(double x) {
    if (x < 0 || x > 1) {
      return 0;
    }

    return (cos(pi + (pow(x, effect.punch).toDouble() * pi * 2)) + 1) / 2;
  }

  double _getMaxDistance(Size size, Offset point) {
    final double dx = max(point.dx, size.width - point.dx);
    final double dy = max(point.dy, size.height - point.dy);
    return sqrt(dx * dx + dy * dy);
  }

  @override
  void beforeRender() {
    _ripples.removeWhere((_Ripple ripple) {
      final double width = scene.viewportSize.width;
      final double height = scene.viewportSize.height;
      final double multiplier = sqrt(width * width + height * height);
      final double scaledWidth = multiplier * effect.width;
      final double scaledSpeed = multiplier * effect.speed;
      final Offset origin = ripple.origin.getXY(scene.viewportSize);
      final double elapsedSeconds = (scene.elapsed - ripple.added).inMilliseconds / 1000;
      final double offset = elapsedSeconds * scaledSpeed;

      for (final MetaballRenderData metaball in scene.renderData) {
        final Offset diff = origin - metaball.position;
        final double normalizedDistance = (diff.distance - offset) / scaledWidth;
        final double wavePoint = _getWavePoint(normalizedDistance + 1);

        metaball.radius *= 1 + (wavePoint * effect.radiusMultiplier);
        metaball.position -= diff * wavePoint * effect.distanceMultiplier;
      }

      if (offset > scaledWidth) {
        return _getMaxDistance(scene.viewportSize, origin) < offset - scaledWidth;
      }

      return false;
    });
  }
}

class _Ripple {
  const _Ripple({
    required this.added,
    required this.origin,
  });

  final Offset origin;
  final Duration added;
}

extension on Offset {
  Offset getUV(Size size) => Offset(
        dx / size.width,
        dy / size.height,
      );

  Offset getXY(Size size) => Offset(
        dx * size.width,
        dy * size.height,
      );
}
