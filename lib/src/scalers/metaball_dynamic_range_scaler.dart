import 'dart:math';
import 'dart:ui';

import 'package:metaballs/src/metaballs_scene.dart';
import 'package:metaballs/src/models/transform.dart';

import 'metaball_scaler.dart';

/// Adjusts metaball size based on a range of screen size percentages.
///
/// The `MetaballDynamicSizeRange` class allows for flexible and responsive design
/// by adjusting the size of metaballs to occupy a percentage range of the viewport's
/// volume. This ensures that the metaballs maintain a consistent visual presence
/// across different screen sizes and resolutions.
///
/// ## Example
///
/// ```dart
/// MetaballDynamicSizeRange(
///   minPercentage: 3,
///   maxPercentage: 5,
/// )
/// ```
///
/// In this example, the metaballs will occupy between 5% and 10% of the viewport's
/// volume, ensuring a balanced and responsive design.
class MetaballDynamicRangeScaler implements MetaballScaler {
  const MetaballDynamicRangeScaler({
    this.minPercentage = 0.1,
    this.maxPercentage = 1,
  });

  /// The minimum percentage of the widget volume the metaballs will use.
  final double minPercentage;

  /// The maximum percentage of the widget volume the metaballs will use.
  final double maxPercentage;

  @override
  Transform1D getTransform(MetaballsScene scene) {
    final Size viewSize = scene.viewportSize;
    final double volume = viewSize.height * viewSize.width;
    final double minVolume = volume * (minPercentage / 100);
    final double maxVolume = volume * (maxPercentage / 100);

    final double minSize = 2 * sqrt(minVolume / pi);
    final double maxSize = 2 * sqrt(maxVolume / pi);
    final double range = maxSize - minSize;

    return Transform1D()
      ..scale(range)
      ..translate(minSize);
  }

  @override
  int get hashCode => Object.hash(minPercentage, maxPercentage);

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is MetaballDynamicRangeScaler && other.runtimeType == runtimeType && other.hashCode == hashCode;

  MetaballDynamicRangeScaler copyWith({
    double? minPercentage,
    double? maxPercentage,
  }) {
    return MetaballDynamicRangeScaler(
      minPercentage: minPercentage ?? this.minPercentage,
      maxPercentage: maxPercentage ?? this.maxPercentage,
    );
  }
}
