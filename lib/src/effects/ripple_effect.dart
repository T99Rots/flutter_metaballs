import 'dart:math';

import 'package:flutter/rendering.dart';
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

  @override
  int get hashCode => Object.hash(
        speed,
        width,
        radiusMultiplier,
        distanceMultiplier,
        punch,
      );

  @override
  bool operator ==(Object other) =>
      identical(this, other) || other is RippleEffect && other.runtimeType == runtimeType && other.hashCode == hashCode;

  RippleEffect copyWith({
    double? speed,
    double? width,
    double? radiusMultiplier,
    double? distanceMultiplier,
    double? punch,
  }) {
    return RippleEffect(
      speed: speed ?? this.speed,
      width: width ?? this.width,
      radiusMultiplier: radiusMultiplier ?? this.radiusMultiplier,
      distanceMultiplier: distanceMultiplier ?? this.distanceMultiplier,
      punch: punch ?? this.punch,
    );
  }
}

class _RippleEffectState extends MetaballsEffectState<RippleEffect> {
  final Set<_Ripple> _ripples = <_Ripple>{};

  @override
  void handlePointerEvent(PointerEvent event) {
    if (event is PointerDownEvent) {
      _ripples.add(
        _Ripple(
          added: scene.elapsed,
          uvOrigin: event.localPosition.getUV(scene.viewportSize),
        ),
      );
    }
  }

  double _getWavePoint(double x) {
    if (x < 0 || x > 1) {
      return 0;
    }

    return pow(sin(pi * pow(x, effect.punch)), 2).toDouble();
  }

  @override
  void beforePhysics() {
    _ripples.removeWhere((_Ripple ripple) {
      final double width = scene.viewportSize.width;
      final double height = scene.viewportSize.height;
      final double multiplier = sqrt(width * width + height * height);
      final double scaledWidth = multiplier * effect.width;
      final double scaledSpeed = multiplier * effect.speed;
      final Offset origin = ripple.uvOrigin.getXY(scene.viewportSize);
      final double elapsedSeconds = (scene.elapsed - ripple.added).inMilliseconds / 1000;
      final double outerRadius = elapsedSeconds * scaledSpeed;

      if (outerRadius > scaledWidth) {
        final double dx = max(origin.dx, width - origin.dx);
        final double dy = max(origin.dy, height - origin.dy);
        final bool outOfScreen = sqrt(dx * dx + dy * dy) < outerRadius - scaledWidth;
        if (outOfScreen) {
          return true;
        }
      }

      ripple.origin = origin;
      ripple.width = scaledWidth;
      ripple.outerRadius = outerRadius;

      return false;
    });
  }

  @override
  void beforeRender() {
    for (final _Ripple ripple in _ripples) {
      for (final MetaballRenderData metaball in scene.renderData) {
        final Offset diff = ripple.origin - metaball.position;
        final double normalizedDistance = (diff.distance - ripple.outerRadius) / ripple.width;
        final double wavePoint = _getWavePoint(normalizedDistance + 1);

        metaball.radius *= 1 + (wavePoint * effect.radiusMultiplier);
        metaball.position -= diff * wavePoint * effect.distanceMultiplier;
      }
    }
  }

  @override
  void debugPaint(PaintingContext context, Offset offset) {
    assert(() {
      final Canvas canvas = context.canvas;
      final Paint circlePaint = Paint()..color = const Color(0x80ffff00);
      final Paint centerPaint = Paint()
        ..color = const Color(0x80ff00ff)
        ..style = PaintingStyle.stroke
        ..strokeWidth = 5;
      final Paint doughnutPaint = Paint()
        ..color = const Color(0x80ffff00)
        ..style = PaintingStyle.stroke;
      final double center = 1 - pow(0.5, 1 / effect.punch).toDouble();
      for (final _Ripple ripple in _ripples) {
        if (ripple.outerRadius < ripple.width) {
          canvas.drawCircle(
            ripple.origin,
            ripple.outerRadius,
            circlePaint,
          );
        } else {
          doughnutPaint.strokeWidth = ripple.width;
          canvas.drawCircle(
            ripple.origin,
            ripple.outerRadius - (ripple.width / 2),
            doughnutPaint,
          );
        }

        final double scaledCenter = ripple.outerRadius - center * ripple.width;
        if (scaledCenter > 0) {
          canvas.drawCircle(ripple.origin, scaledCenter, centerPaint);
        }
      }

      return true;
    }());
  }
}

class _Ripple {
  _Ripple({
    required this.added,
    required this.uvOrigin,
  });

  final Offset uvOrigin;
  final Duration added;
  double width = 0;
  double outerRadius = 0;
  Offset origin = Offset.zero;
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
