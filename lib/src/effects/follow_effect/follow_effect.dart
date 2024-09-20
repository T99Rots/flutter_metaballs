import 'package:flutter/widgets.dart';
import 'package:metaballs/src/effects/interface/metaballs_effect.dart';
import 'package:metaballs/src/effects/mixins/animated_pointer_tracker_mixin.dart';
import 'package:metaballs/src/models/metaball_render_data.dart';

/// Applies a follow effect to metaballs based on user interactions.
///
/// The `FollowEffect` class creates metaballs that appear and scale in and out
/// at the location of user interactions, such as taps or clicks. It allows for
/// configuring the duration, animation curve, and radius of the metaballs.
///
/// ```dart
/// FollowEffect(
///   duration: Duration(milliseconds: 200),
///   curve: Curves.easeIn,
///   radius: 50,
/// );
/// ```
///
/// This example creates a `FollowEffect` with a duration of 200 milliseconds,
/// an ease-in animation curve, and a metaball radius of 50. The effect will
/// be applied to the metaballs during user interactions.
class FollowEffect extends MetaballsEffect {
  const FollowEffect({
    this.duration = const Duration(milliseconds: 80),
    this.curve = Curves.ease,
    this.radius = 40,
    this.pointerSmoothing = 0,
  });

  /// The duration of the metaball's scale in and out effect.
  ///
  /// This variable specifies the total time it takes for the metaball to scale in
  /// and out when it appears in the widget or gets removed from the widget.
  final Duration duration;

  /// The animation curve for the metaball's scale effect.
  ///
  /// This variable defines the curve used to interpolate the scale in and out
  /// animation over time. It allows for customizing the easing behavior of the
  /// scale in and out effect.
  final Curve curve;

  /// The radius of the metaball.
  ///
  /// This variable determines the size of the metaball that appears where you
  /// press on the screen.
  final double radius;

  final double pointerSmoothing;

  @override
  MetaballsEffectState<FollowEffect> createState() => _FollowEffectState();
}

class _FollowEffectState extends MetaballsEffectState<FollowEffect> with AnimatedPointerTrackerMixin<FollowEffect> {
  @override
  void beforeRender() {
    for (final PointerEffectData pointer in pointers) {
      scene.renderData.add(
        MetaballRenderData(
          radius: pointer.t * effect.radius,
          position: pointer.position,
        ),
      );
    }
  }

  @override
  Curve get animationCurve => effect.curve;

  @override
  Duration get animationDuration => effect.duration;

  @override
  double get pointerSmoothing => effect.pointerSmoothing;
}
