import 'package:metaballs/src/metaballs_scene.dart';

import 'metaball_dynamic_range_scaler.dart';
import 'metaball_dynamic_scaler.dart';
import 'metaball_static_range_scaler.dart';
import 'metaball_static_scaler.dart';

/// An interface for defining the size of a metaball.
///
/// The `MetaballScaler` interface provides a method to calculate the render
/// size of a metaball based on the view size and radius. Implementing this
/// interface allows for different strategies to determine the size of
/// metaballs, making it flexible for various rendering requirements.
///
/// Example:
/// ```dart
/// class CustomMetaballScaler implements MetaballScaler {
///   @override
///   double getRenderSize(Size viewSize, double radius) {
///     return radius * 2;
///   }
/// }
/// ```
///
/// In this example, a `CustomMetaballScaler` class implements the `MetaballScaler`
/// interface and provides a custom calculation for the render size, which is
/// simply twice the radius.
abstract interface class MetaballScaler {
  /// A class representing a static size for a metaball.
  ///
  /// The `MetaballStaticSize` class provides a fixed size for a metaball,
  /// regardless of the view size or radius. This can be useful in scenarios
  /// where a constant size is needed for rendering metaballs, ensuring
  /// uniformity and predictability in their appearance.
  ///
  /// Example:
  /// ```dart
  /// MetaballScaler.static(
  ///   size: 10.0,
  /// )
  /// ```
  ///
  /// In this example, a `MetaballScaler.static` factory constructor is used to
  /// create a `MetaballStaticSize` object with a fixed size of 10.0. This size
  /// will be used for rendering the metaball.
  const factory MetaballScaler.static({
    double size,
  }) = MetaballStaticScaler;

  /// A class representing a range-based size for a metaball.
  ///
  /// The `MetaballStaticSizeRange` class provides a size for a metaball that
  /// varies within a specified range based on the radius. This allows for
  /// dynamic sizing of metaballs, making them adaptable to different radii
  /// while maintaining a defined minimum and maximum size.
  ///
  /// Example:
  /// ```dart
  /// MetaballScaler.staticRange(
  ///   min: 5.0,
  ///   max: 15.0,
  /// )
  /// ```
  ///
  /// In this example, a `MetaballScaler.staticRange` factory constructor is used
  /// to create a `MetaballStaticSizeRange` object with a minimum size of 5.0
  /// and a maximum size of 15.0. The size will vary between these values based
  /// on the radius.
  const factory MetaballScaler.staticRange({
    double max,
    double min,
  }) = MetaballStaticRangeScaler;

  /// A class for dynamic metaball sizing.
  ///
  /// The `MetaballDynamicSize` class calculates the size of metaballs
  /// based on a percentage of the widget's volume. This allows for
  /// dynamic resizing of metaballs within a given view size.
  ///
  /// Example:
  /// ```dart
  /// MetaballScaler.dynamic(
  ///   percentage: 3,
  /// )
  /// ```
  ///
  /// In this example, a `MetaballScaler.dynamic` factory constructor is used to
  /// create a `MetaballDynamicSize` object with a percentage of 3.
  const factory MetaballScaler.dynamic({
    double percentage,
  }) = MetaballDynamicScaler;

  /// Adjusts metaball size based on a range of screen size percentages.
  ///
  /// The `MetaballDynamicSizeRange` class allows for flexible and responsive design
  /// by adjusting the size of metaballs to occupy a percentage range of the viewport's
  /// volume. This ensures that the metaballs maintain a consistent visual presence
  /// across different screen sizes and resolutions.
  ///
  /// Example:
  /// ```dart
  /// MetaballScaler.dynamicRange(
  ///   minPercentage: 3,
  ///   maxPercentage: 5,
  /// )
  /// ```
  ///
  /// In this example, a `MetaballScaler.dynamicRange` factory constructor is used to
  /// create a `MetaballDynamicSizeRange` object with a minimum percentage of 3 and
  /// a maximum percentage of 5. The metaballs will occupy between 3% and 5% of the
  /// viewport's volume, ensuring a balanced and responsive design.
  const factory MetaballScaler.dynamicRange({
    double maxPercentage,
    double minPercentage,
  }) = MetaballDynamicRangeScaler;

  /// Calculates the render size of a metaball.
  ///
  /// This method determines the size of a metaball based on the provided
  /// view size and radius. The implementation of this method can vary
  /// depending on the specific strategy used for sizing the metaball.
  ///
  /// - [viewSize]: The size of the view in which the metaball is rendered.
  /// - [radius]: The radius of the metaball.
  ///
  /// Returns the calculated render size of the metaball.
  void applyScaling(MetaballsScene scene);
}
