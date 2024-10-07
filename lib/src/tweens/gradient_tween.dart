import 'package:flutter/widgets.dart';

class GradientTween extends Tween<Gradient> {
  /// Creates a gradient tween.
  ///
  /// The [begin] and [end] properties may be null. If both are null, then the
  /// result is always null. If [end] is not null, then its lerping logic is
  /// used (via [Gradient.lerpTo]). Otherwise, [begin]'s lerping logic is used
  /// (via [Gradient.lerpFrom]).
  GradientTween({super.begin, super.end});

  /// Returns the value this variable has at the given animation clock value.
  @override
  Gradient lerp(double t) => Gradient.lerp(begin, end, t)!;
}
