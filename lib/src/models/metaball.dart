import 'metaball_render_transform.dart';

class Metaball {
  Metaball({
    required this.x,
    required this.y,
    required this.radius,
    required this.createdAt,
  });

  Duration createdAt;

  double x;

  double y;

  /// The radius of the metaball.
  ///
  /// Will influence the visual radius of the metaball and might influence the
  /// physics of the metaball. Does not necessarily equate to the visual offset
  /// of the metaball as this could be offset by [radiusOffset].
  double radius;

  MetaballRenderTransform transform = MetaballRenderTransform();
}
