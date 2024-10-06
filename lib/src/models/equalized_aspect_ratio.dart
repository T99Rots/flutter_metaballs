import 'dart:math';

/// An aspect ratio which a ratio component for each axis.
///
/// When constructed from [fromRatio] ensures that any cube maintains its volume
/// when multiplied by the [x] and [y] components.
class EqualizedAspectRatio {
  const EqualizedAspectRatio({
    required this.x,
    required this.y,
  });

  /// Creates an [EqualizedAspectRatio] from a [ratio].
  ///
  /// This method ensures that any cube maintains its volume when multiplied by
  /// the [x] and [y] components.
  factory EqualizedAspectRatio.fromRatio(double ratio) {
    final double y = sqrt(1 / ratio);
    final double x = ratio * y;

    return EqualizedAspectRatio(
      y: y,
      x: x,
    );
  }

  /// The aspect ratio for the x-axis.
  final double x;

  /// The aspect ratio for the y-axis.
  final double y;
}
