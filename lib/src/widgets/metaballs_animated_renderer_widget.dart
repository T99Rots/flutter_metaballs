import 'package:flutter/widgets.dart';
import 'package:metaballs/src/metaballs_scene.dart';
import 'package:metaballs/src/renderers/metaballs_render_widget.dart';
import 'package:metaballs/src/tweens/gradient_tween.dart';

class MetaballsAnimatedRendererWidget extends ImplicitlyAnimatedWidget {
  const MetaballsAnimatedRendererWidget({
    super.key,
    required this.gradient,
    required this.color,
    required this.scene,
    required this.glowThreshold,
    required this.glowIntensity,
    required super.curve,
    required super.duration,
  });

  final Color color;
  final Gradient? gradient;
  final MetaballsScene scene;
  final double glowThreshold;
  final double glowIntensity;

  @override
  AnimatedWidgetBaseState<MetaballsAnimatedRendererWidget> createState() => _MetaballsAnimatedRendererWidgetState();
}

class _MetaballsAnimatedRendererWidgetState extends AnimatedWidgetBaseState<MetaballsAnimatedRendererWidget> {
  ColorTween? _colorTween;
  GradientTween? _gradientTween;
  Tween<double>? _glowThresholdTween;
  Tween<double>? _glowIntensityTween;

  @override
  void forEachTween(TweenVisitor<dynamic> visitor) {
    _colorTween = visitor(
      _colorTween,
      widget.color,
      (dynamic value) => ColorTween(begin: value as Color),
    ) as ColorTween?;

    _glowThresholdTween = visitor(
      _glowThresholdTween,
      widget.glowThreshold,
      (dynamic value) => Tween<double>(begin: value as double),
    ) as Tween<double>?;

    _glowIntensityTween = visitor(
      _glowIntensityTween,
      widget.glowIntensity,
      (dynamic value) => Tween<double>(begin: value as double),
    ) as Tween<double>?;

    if (widget.gradient != null) {
      _gradientTween = visitor(
        _gradientTween,
        widget.gradient,
        (dynamic value) => GradientTween(begin: value as Gradient),
      ) as GradientTween?;
    }
  }

  @override
  Widget build(BuildContext context) {
    return MetaballsRenderWidget(
      gradient: _gradientTween?.evaluate(animation),
      color: _colorTween!.evaluate(animation)!,
      glowThreshold: _glowThresholdTween!.evaluate(animation),
      glowIntensity: _glowIntensityTween!.evaluate(animation),
      scene: widget.scene,
    );
  }
}
