import 'package:flutter/widgets.dart';
import 'package:metaballs/src/effects/metaballs_effect.dart';
import 'package:metaballs/src/metaballs_scene.dart';
import 'package:metaballs/src/physics/bouncing_physics.dart';
import 'package:metaballs/src/physics/metaballs_physics.dart';
import 'package:metaballs/src/scalers/metaball_scaler.dart';
import 'package:metaballs/src/widgets/metaballs_animated_renderer_widget.dart';

import 'widgets/pointer_event_listener.dart';

class Metaballs extends StatefulWidget {
  const Metaballs({
    super.key,
    this.child,
    this.effect,
    this.gradient,
    this.count = 40,
    this.glowThreshold = 0.7,
    this.glowIntensity = 0.6,
    this.color = const Color(0xff0080ff),
    this.physics = const BouncingPhysics(),
    this.size = const MetaballScaler.dynamicRange(),
    this.duration = const Duration(milliseconds: 300),
    this.curve = Curves.easeInOut,
    this.effectsDebugging = false,
    this.physicsDebugging = false,
  });

  final int count;
  final Color color;
  final double glowThreshold;
  final double glowIntensity;
  final Gradient? gradient;
  final MetaballsEffect? effect;
  final MetaballsPhysics physics;
  final MetaballScaler size;
  final Duration duration;
  final Curve curve;
  final Widget? child;

  final bool effectsDebugging;
  final bool physicsDebugging;

  @override
  State<Metaballs> createState() => _MetaballsState();
}

class _MetaballsState extends State<Metaballs> with SingleTickerProviderStateMixin {
  late final MetaballsScene _scene = MetaballsScene(
    vsync: this,
    effect: widget.effect,
    physics: widget.physics,
    count: widget.count,
    scaler: widget.size,
  );

  @override
  void didUpdateWidget(covariant Metaballs oldWidget) {
    _scene.update(
      effect: widget.effect,
      physics: widget.physics,
      metaballScaler: widget.size,
      count: widget.count,
    );
    super.didUpdateWidget(oldWidget);
  }

  @override
  Widget build(BuildContext context) {
    final Widget? child = widget.child;

    return PointerEventListener(
      onPointerEvent: _scene.handlePointerEvent,
      behavior: HitTestBehavior.translucent,
      child: Stack(
        children: <Widget>[
          RepaintBoundary(
            child: MetaballsAnimatedRendererWidget(
              gradient: widget.gradient,
              color: widget.color,
              glowThreshold: widget.glowThreshold,
              glowIntensity: widget.glowIntensity,
              scene: _scene,
              curve: widget.curve,
              duration: widget.duration,
              effectsDebugging: widget.effectsDebugging,
              physicsDebugging: widget.physicsDebugging,
            ),
          ),
          if (child != null)
            Positioned.fill(
              child: child,
            )
        ],
      ),
    );
  }
}
