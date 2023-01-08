/// The metaball shader data for the current screen size.
class MetaballShaderData {
  MetaballShaderData({
    required this.radius,
    required this.x,
    required this.y,
  });

  /// The radius of the metaball in pixels.
  final double radius;

  /// The x position of the metaball in pixels.
  final double x;

  /// The y position of the metaball in pixels.
  final double y;

  MetaballShaderData copyWith({
    double? x,
    double? y,
    double? radius,
  }) {
    return MetaballShaderData(
      radius: radius ?? this.radius,
      x: x ?? this.x,
      y: y ?? this.y,
    );
  }
}
