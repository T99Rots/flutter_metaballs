import 'package:flutter/widgets.dart';
import 'package:metaballs/src/metaballs_scene.dart';

import 'metaballs_renderer.dart';

class MetaballsRenderWidget extends LeafRenderObjectWidget {
  const MetaballsRenderWidget({
    super.key,
    required this.gradient,
    required this.color,
    required this.scene,
    required this.glowThreshold,
    required this.glowIntensity,
  });

  final Color color;
  final Gradient? gradient;
  final MetaballsScene scene;
  final double glowThreshold;
  final double glowIntensity;

  @override
  RenderObject createRenderObject(BuildContext context) {
    return MetaballsRenderer(
      color: color,
      gradient: gradient,
      scene: scene,
      glowThreshold: glowThreshold,
      glowIntensity: glowIntensity,
    );
  }

  @override
  void updateRenderObject(BuildContext context, covariant MetaballsRenderer renderObject) {
    renderObject.color = color;
    renderObject.gradient = gradient;
    renderObject.scene = scene;
    renderObject.glowThreshold = glowThreshold;
    renderObject.glowIntensity = glowIntensity;
  }
}
