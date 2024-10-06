import 'package:metaballs/src/metaballs_scene.dart';
import 'package:metaballs/src/models/transform.dart';

import 'metaball_scaler.dart';

/// A class representing a static size for a metaball.
///
/// The `MetaballStaticSize` class provides a fixed size for a metaball,
/// regardless of the view size or radius. This can be useful in scenarios
/// where a constant size is needed for rendering metaballs, ensuring
/// uniformity and predictability in their appearance.
///
/// Example:
/// ```dart
/// MetaballStaticSize(
///   size: 10.0,
/// )
/// ```
///
/// In this example, a `MetaballStaticSize` object is created with a fixed
/// size of 10.0. This size will be used for rendering the metaball.
class MetaballStaticScaler implements MetaballScaler {
  const MetaballStaticScaler({
    this.size = 40,
  });

  final double size;

  @override
  Transform1D getTransform(MetaballsScene scene) {
    return Transform1D()
      ..scale(0)
      ..translate(size);
  }

  @override
  int get hashCode => size.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is MetaballStaticScaler && runtimeType == other.runtimeType && hashCode == other.hashCode;

  MetaballStaticScaler copyWith({
    double? size,
  }) {
    return MetaballStaticScaler(
      size: size ?? this.size,
    );
  }
}
