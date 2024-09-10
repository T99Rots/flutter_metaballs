import 'package:flutter/widgets.dart';
import 'package:metaballs/src/controller/_controller.dart';
import 'package:metaballs/src/controller/metaballs_scene_implementation.dart';
import 'package:metaballs/src/interfaces/_interfaces.dart';
import 'package:metaballs/src/renderer/_renderer.dart';

class Metaballs extends StatefulWidget {
  const Metaballs({
    super.key,
    this.gradient,
    this.controller,
    this.physics,
    this.count = 40,
    this.glowThreshold = 0.7,
    this.glowIntensity = 0.6,
    this.color = const Color(0xff0080ff),
  });

  final int count;
  final Color color;
  final double glowThreshold;
  final double glowIntensity;
  final Gradient? gradient;
  final MetaballsEffectController? controller;
  final MetaballsPhysics? physics;

  @override
  State<Metaballs> createState() => _MetaballsState();
}

class _MetaballsState extends State<Metaballs> with TickerProviderStateMixin {
  final MetaballsSceneImplementation _scene = MetaballsSceneImplementation();
  late MetaballsEffectController _controller;
  late MetaballsPhysics _physics;

  @override
  void initState() {
    _controller = widget.controller ?? MetaballsNoEffectController();
    _physics = widget.physics ?? const DefaultMetaballsPhysics();

    for (int i = 0; i < widget.count; i++) {
      _scene.metaballs.add(_controller.createMetaball());
    }
    super.initState();
  }

  @override
  void didUpdateWidget(covariant Metaballs oldWidget) {
    final MetaballsEffectController? oldController = oldWidget.controller;
    final MetaballsEffectController? newController = widget.controller;
    final MetaballsEffectController currentController = _controller;
    if (newController != currentController) {
      if (newController == null) {
        if (oldController == currentController) {
          _controller = MetaballsNoEffectController();
        }
      } else {
        _controller = newController;
      }
    }

    final MetaballsPhysics? oldPhysics = oldWidget.physics;
    final MetaballsPhysics? newPhysics = widget.physics;
    final MetaballsPhysics currentPhysics = _physics;
    if (newPhysics != currentPhysics) {
      if (newPhysics == null) {
        if (oldPhysics == currentPhysics) {
          _physics = const DefaultMetaballsPhysics();
        }
      } else {
        _physics = newPhysics;
      }
    }

    final int newCount = widget.count;
    final int oldCount = oldWidget.count;
    final List<Metaball> metaballs = _scene.metaballs;
    if (newCount > oldCount) {
      for (int i = oldCount; i < oldCount; i++) {
        metaballs.add(_controller.createMetaball());
      }
    } else if (oldCount > newCount) {
      metaballs.removeRange(
        newCount,
        metaballs.length,
      );
    }
    super.didUpdateWidget(oldWidget);
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return MetaballsRenderWidget(
      gradient: widget.gradient,
      color: widget.color,
      controller: _controller,
      glowThreshold: widget.glowThreshold,
      glowIntensity: widget.glowIntensity,
    );
  }
}
