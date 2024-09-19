import 'dart:math';

import 'package:flutter/animation.dart';
import 'package:flutter/gestures.dart';
import 'package:metaballs/src/effects/interface/metaballs_effect.dart';
import 'package:metaballs/src/models/metaball_render_data.dart';

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
  final Map<int, _PointerEffectData> _activePointers = <int, _PointerEffectData>{};
  final Set<_PointerEffectData> _removedPointers = <_PointerEffectData>{};

  @override
  void handlePointerEvent(PointerEvent event) {
    final _PointerEffectData? data;

    print('event: ${event.runtimeType}');

    switch (event) {
      case PointerCancelEvent():
      case PointerExitEvent():
      case PointerPanZoomEndEvent():
      case PointerUpEvent():
      case PointerRemovedEvent():
        print('removed');
        final _PointerEffectData? pointer = _activePointers.remove(event.pointer);

        if (effect.duration != Duration.zero && pointer != null) {
          pointer.removed = scene.elapsed;
          _removedPointers.add(pointer);
        }

        return;
      default:
        data = _activePointers[event.pointer];
    }

    if (data == null) {
      if (event is PointerHoverEvent) {
        return;
      }

      _activePointers[event.pointer] = _PointerEffectData(
        added: scene.elapsed,
        id: event.pointer,
        position: event.position,
      );

      return;
    }

    data.position = event.localPosition;
  }

  @override
  void beforeRender() {
    for (final _PointerEffectData data in _activePointers.values) {
      final int elapsedSinceAdded = (scene.elapsed - data.added).inMicroseconds;
      final double t = min(1.0, elapsedSinceAdded / effect.duration.inMicroseconds);

      scene.renderData.add(
        MetaballRenderData(
          radius: effect.curve.transform(t) * effect.radius,
          x: data.position.dx,
          y: data.position.dy,
        ),
      );
    }

    _removedPointers.removeWhere((_PointerEffectData data) {
      final Duration? removed = data.removed;
      if (removed == null) {
        return true;
      }

      final int timeSinceRemoved = (scene.elapsed - removed).inMicroseconds;
      final double t = 1.0 - (timeSinceRemoved / effect.duration.inMicroseconds);

      if (t < 0) {
        return true;
      }

      final int timeAlive = (removed - data.added).inMicroseconds;
      final double maxAliveT = min(1.0, timeAlive / effect.duration.inMicroseconds);

      scene.renderData.add(
        MetaballRenderData(
          radius: effect.curve.transform(t) * maxAliveT * effect.radius,
          x: data.position.dx,
          y: data.position.dy,
        ),
      );
      return false;
    });
  }

  @override
  void detach() {
    _activePointers.clear();
    super.detach();
  }
}

class _PointerEffectData {
  _PointerEffectData({
    required this.id,
    required this.added,
    required this.position,
  });

  final int id;
  final Duration added;
  Duration? removed;
  Offset position;
}
