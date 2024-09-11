import 'package:flutter/rendering.dart';

/// The visual representation of a [Metaball].
abstract interface class VisualMetaball {
  /// The visual position of the metaball.
  Offset get visualPosition;

  /// The visual radius of the metaball.
  double get visualRadius;
}
