import 'package:flutter/widgets.dart';
import 'package:metaballs/src/models/metaball.dart';

import 'renderer/metaballs_renderer.dart';

class Metaballs extends LeafRenderObjectWidget {
  const Metaballs({
    super.key,
    required this.gradient,
    required this.metaBalls,
    required this.glowThreshold,
    required this.glowIntensity,
  });

  final Gradient gradient;
  final List<MetaBall> metaBalls;
  final double glowThreshold;
  final double glowIntensity;

  @override
  RenderObject createRenderObject(BuildContext context) {
    return MetaballsRenderer(
      gradient: gradient,
      metaballs: metaBalls,
      glowThreshold: glowThreshold,
      glowIntensity: glowIntensity,
    );
  }
}
