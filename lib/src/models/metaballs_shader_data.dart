import 'package:flutter/widgets.dart';

/// The metaball shader data for the current screen size.
class MetaballShaderData {
  MetaballShaderData({
    required this.radius,
    required this.position,
  });

  /// The radius of the metaball in pixels.
  final double radius;

  /// The position of the metaball.
  final Offset position;

  MetaballShaderData copyWith({
    Offset? position,
    double? radius,
  }) {
    return MetaballShaderData(
      radius: radius ?? this.radius,
      position: position ?? this.position,
    );
  }
}
