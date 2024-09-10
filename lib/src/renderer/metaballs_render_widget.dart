import 'package:flutter/widgets.dart';
import 'package:metaballs/src/interfaces/metaballs_effect_controller.dart';

import 'metaballs_renderer.dart';

class MetaballsRenderWidget extends LeafRenderObjectWidget {
  const MetaballsRenderWidget({
    super.key,
    required this.gradient,
    required this.color,
    required this.controller,
    required this.glowThreshold,
    required this.glowIntensity,
  });

  final Color color;
  final Gradient? gradient;
  final MetaballsEffectController controller;
  final double glowThreshold;
  final double glowIntensity;

  @override
  RenderObject createRenderObject(BuildContext context) {
    return MetaballsRenderer(
      color: color,
      gradient: gradient,
      scene: controller,
      glowThreshold: glowThreshold,
      glowIntensity: glowIntensity,
    );
  }

  @override
  void updateRenderObject(BuildContext context, covariant MetaballsRenderer renderObject) {
    renderObject.color = color;
    renderObject.gradient = gradient;
    renderObject.scene = controller;
    renderObject.glowThreshold = glowThreshold;
    renderObject.glowIntensity = glowIntensity;
  }
}
