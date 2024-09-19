import 'dart:math';

import 'package:flutter/animation.dart';
import 'package:metaballs/src/effects/interface/metaballs_effect.dart';
import 'package:metaballs/src/metaballs_scene.dart';
import 'package:metaballs/src/models/metaball_render_data.dart';
import 'package:metaballs/src/pointer.dart';

class FollowEffect extends MetaballsEffect {
  const FollowEffect({
    this.duration = const Duration(milliseconds: 125),
    this.curve = Curves.easeInOut,
    this.radius = 40,
  });

  final Duration duration;
  final Curve curve;
  final double radius;

  @override
  MetaballsEffectStateAny createState() => _FollowEffectState();
}

class _FollowEffectState extends MetaballsEffectState<FollowEffect> {
  final Map<int, _PointerEffectData> _pointerCache = <int, _PointerEffectData>{};

  @override
  void handlePointer(MetaballsScene scene, Pointer pointer) {
    _pointerCache[pointer.id] = _PointerEffectData(
      added: scene.elapsed,
      pointer: pointer,
      scene: scene,
    );
  }

  @override
  void beforeRender(MetaballsScene scene) {
    for (final _PointerEffectData data in _pointerCache.values) {
      double t;
      if (data.pointer.active) {
        final int elapsedSinceAdded = (scene.elapsed - data.added).inMicroseconds;
        t = min(1.0, elapsedSinceAdded / effect.duration.inMicroseconds);
      } else {
        if (effect.duration == Duration.zero) {
          continue;
        }

        final int timeSinceRemoved = (scene.elapsed - data.removed!).inMicroseconds;
        t = 1.0 - (timeSinceRemoved / effect.duration.inMicroseconds);
      }

      if (t < 0) {
        continue;
      }

      final Offset position = data.pointer.position;

      scene.renderData.add(
        MetaballRenderData(
          radius: effect.curve.transform(t) * effect.radius,
          x: position.dx,
          y: position.dy,
        ),
      );
    }
  }

  @override
  void detach() {
    for (final _PointerEffectData effectData in _pointerCache.values) {
      effectData.dispose();
    }
    _pointerCache.clear();
    super.detach();
  }
}

class _PointerEffectData {
  _PointerEffectData({
    required this.added,
    required this.pointer,
    required this.scene,
  }) {
    pointer.addListener(_handleUpdate);
  }

  final MetaballsScene scene;
  final Pointer pointer;
  final Duration added;
  Duration? removed;

  void _handleUpdate() {
    if (!pointer.active) {
      removed = scene.elapsed;
      dispose();
    }
  }

  void dispose() {
    pointer.removeListener(_handleUpdate);
  }
}
