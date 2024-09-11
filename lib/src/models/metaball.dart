import 'package:flutter/rendering.dart';

import 'visual_metaball.dart';

class Metaball implements VisualMetaball {
  Metaball({
    required this.position,
    required this.radius,
    required this.createdAt,
    this.positionOffset = Offset.zero,
    this.radiusOffset = 0,
  });

  Duration createdAt;

  /// The position of the metaball.
  ///
  /// Will influence the visual position of the metaball and might influence the
  /// physics of the metaball. Does not necessarily equate to the visual offset
  /// of the metaball as this could be offset by [positionOffset].
  Offset position;

  /// The radius of the metaball.
  ///
  /// Will influence the visual radius of the metaball and might influence the
  /// physics of the metaball. Does not necessarily equate to the visual offset
  /// of the metaball as this could be offset by [radiusOffset].
  double radius;

  /// Visual offset from the actual position.
  ///
  /// Does not influence the physics of the metaball and only gets applied
  /// during rendering.
  Offset positionOffset;

  /// Visual offset from the actual radius.
  ///
  /// Does not influence the physics of the metaball and only gets applied
  /// during rendering.
  double radiusOffset;

  /// The visual position of the metaball.
  ///
  /// This is the [position] of the metaball with the [positionOffset] applied.
  Offset get visualPosition => position + positionOffset;

  /// The visual radius of the metaball.
  ///
  /// This is the [radius] of the metaball with the [radiusOffset] applied.
  double get visualRadius => radius + radiusOffset;
}
