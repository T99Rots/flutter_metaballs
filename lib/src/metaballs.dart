import 'package:flutter/widgets.dart';
import 'package:metaballs/src/effects/interface/metaballs_effect.dart';
import 'package:metaballs/src/metaballs_scene.dart';
import 'package:metaballs/src/physics/interface/metaballs_physics.dart';
import 'package:metaballs/src/renderers/metaballs_render_widget.dart';
import 'package:metaballs/src/scalers/metaball_scaler.dart';

import 'pointer_event_listener.dart';

class Metaballs extends StatefulWidget {
  const Metaballs({
    super.key,
    this.gradient,
    required this.effect,
    required this.physics,
    this.count = 40,
    this.glowThreshold = 0.7,
    this.glowIntensity = 0.6,
    this.color = const Color(0xff0080ff),
    this.size = const MetaballScaler.dynamicRange(
      minPercentage: 0.4,
      maxPercentage: 0.6,
    ),
  });

  final int count;
  final Color color;
  final double glowThreshold;
  final double glowIntensity;
  final Gradient? gradient;
  final MetaballsEffect effect;
  final MetaballsPhysics physics;
  final MetaballScaler size;

  @override
  State<Metaballs> createState() => _MetaballsState();
}

class _MetaballsState extends State<Metaballs> with TickerProviderStateMixin {
  late final MetaballsScene _scene = MetaballsScene(
    vsync: this,
    effect: widget.effect,
    physics: widget.physics,
    count: widget.count,
    scaler: widget.size,
  );

  @override
  void didUpdateWidget(covariant Metaballs oldWidget) {
    super.didUpdateWidget(oldWidget);
    _scene.update(
      effect: widget.effect,
      physics: widget.physics,
      count: widget.count,
      metaballScaler: widget.size,
    );
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return PointerEventListener(
      onPointerEvent: _scene.handlePointerEvent,
      behavior: HitTestBehavior.translucent,
      child: RepaintBoundary(
        child: MetaballsRenderWidget(
          gradient: widget.gradient,
          color: widget.color,
          glowThreshold: widget.glowThreshold,
          glowIntensity: widget.glowIntensity,
          scene: _scene,
        ),
      ),
    );
  }
}
