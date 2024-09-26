import 'dart:math';
import 'dart:ui';

import 'package:metaballs/src/metaballs_scene.dart';
import 'package:metaballs/src/models/metaball.dart';

import 'metaball_scaler.dart';

/// A class for dynamic metaball sizing.
///
/// The `MetaballDynamicSize` class calculates the size of metaballs
/// based on a percentage of the widget's volume. This allows for
/// dynamic resizing of metaballs within a given view size.
///
/// Example:
/// ```dart
/// MetaballDynamicSize(
///   percentage: 3,
/// )
/// ```
///
/// In this example, a `MetaballDynamicSize` object is created with a
/// percentage of 3.
class MetaballDynamicScaler implements MetaballScaler {
  const MetaballDynamicScaler({
    this.percentage = 1,
  });

  /// A percentage of the widget volume the metaballs will use.
  final double percentage;

  @override
  void applyScaling(MetaballsScene scene) {
    final Size viewSize = scene.viewportSize;
    final double volume = viewSize.height * viewSize.width;
    final double targetVolume = volume * (percentage / 100);
    final double targetSize = 2 * sqrt(targetVolume / pi);

    scene.visitMetaballs((Metaball metaball) {
      metaball.transform
        ..scaleSize(0)
        ..translateSize(targetSize);
    });
  }

  @override
  int get hashCode => percentage.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is MetaballDynamicScaler && runtimeType == other.runtimeType && hashCode == other.hashCode;
}
