import 'package:metaballs/src/metaballs_scene.dart';
import 'package:metaballs/src/models/metaball.dart';

import 'metaball_scaler.dart';

/// A class representing a range-based size for a metaball.
///
/// The `MetaballStaticSizeRange` class provides a size for a metaball that
/// varies within a specified range based on the radius. This allows for
/// dynamic sizing of metaballs, making them adaptable to different radii
/// while maintaining a defined minimum and maximum size.
///
/// Example:
/// ```dart
/// MetaballStaticSizeRange(
///   min: 5.0,
///   max: 15.0,
/// )
/// ```
///
/// In this example, a `MetaballStaticSizeRange` object is created with a
/// minimum size of 5.0 and a maximum size of 15.0. The size will vary
/// between these values based on the radius.
class MetaballStaticRangeScaler implements MetaballScaler {
  const MetaballStaticRangeScaler({
    required this.max,
    required this.min,
  });

  final double min;
  final double max;

  @override
  void applyScaling(MetaballsScene scene) {
    final double range = max - min;
    scene.visitMetaballs((Metaball metaball) {
      metaball.transform
        ..scaleSize(range)
        ..translateSize(min);
    });
  }
}
