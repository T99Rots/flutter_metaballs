import 'package:flutter/rendering.dart';

import 'metaball_render_transform.dart';

class Metaball {
  Metaball({
    required this.position,
    required this.radius,
    required this.createdAt,
  });

  Duration createdAt;

  Offset position;

  /// The radius of the metaball.
  ///
  /// Will influence the visual radius of the metaball and might influence the
  /// physics of the metaball. Does not necessarily equate to the visual offset
  /// of the metaball as this could be offset by [radiusOffset].
  double radius;

  final MetaballRenderTransform transform = MetaballRenderTransform();
}
