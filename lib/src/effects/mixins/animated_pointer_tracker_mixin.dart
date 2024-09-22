import 'dart:math';

import 'package:flutter/gestures.dart';
import 'package:flutter/widgets.dart';
import 'package:metaballs/src/effects/metaballs_effect.dart';

mixin AnimatedPointerTrackerMixin<Effect extends MetaballsEffect> on MetaballsEffectState<Effect> {
  final Set<PointerEffectData> _removedPointers = <PointerEffectData>{};
  final Map<int, PointerEffectData> _activePointers = <int, PointerEffectData>{};

  Duration get animationDuration;

  Curve get animationCurve;

  double get pointerSmoothing => 0.0;

  Iterable<PointerEffectData> get pointers => _activePointers.values.followedBy(_removedPointers);

  @override
  @mustCallSuper
  void beforePhysics() {
    final Duration duration = animationDuration;
    final Curve curve = animationCurve;
    final double smoothing = pointerSmoothing;

    for (final PointerEffectData data in _activePointers.values) {
      final int elapsedSinceAdded = (scene.elapsed - data.added).inMicroseconds;
      final double t = min(1.0, elapsedSinceAdded / duration.inMicroseconds);

      data._t = curve.transform(t);
    }

    _removedPointers.removeWhere((PointerEffectData pointer) {
      final Duration? removed = pointer._removed;
      if (removed == null) {
        return true;
      }

      final int timeSinceRemoved = (scene.elapsed - removed).inMicroseconds;
      final double t = timeSinceRemoved / duration.inMicroseconds;

      if (t > 1.0) {
        return true;
      }

      final int timeAlive = (removed - pointer.added).inMicroseconds;
      final double maxAliveT = min(1.0, timeAlive / duration.inMicroseconds);

      pointer._t = (1 - curve.transform(t)) * maxAliveT;

      return false;
    });

    if (pointerSmoothing > 0) {
      for (final PointerEffectData pointer in pointers) {
        final double factor = 1.0 - pow(smoothing, scene.frameTime.inMilliseconds / 100);
        final Offset difference = pointer._targetPosition - pointer._position;

        pointer._position += difference * factor;
      }
    }
  }

  @override
  void handlePointerEvent(PointerEvent event) {
    final PointerEffectData? pointer;

    switch (event) {
      case PointerCancelEvent():
      case PointerExitEvent():
      case PointerPanZoomEndEvent():
      case PointerUpEvent():
      case PointerRemovedEvent():
        final PointerEffectData? pointer = _activePointers.remove(event.pointer);

        if (pointer != null && animationDuration != Duration.zero) {
          pointer._removed = scene.elapsed;
          _removedPointers.add(pointer);
        }

        return;
      default:
        pointer = _activePointers[event.pointer];
    }

    if (pointer == null) {
      if (event is PointerHoverEvent) {
        return;
      }

      _activePointers[event.pointer] = PointerEffectData(
        added: scene.elapsed,
        id: event.pointer,
        position: event.localPosition,
        t: 0,
      );

      return;
    }

    if (pointerSmoothing > 0) {
      pointer._targetPosition = event.localPosition;
    } else {
      pointer._position = event.localPosition;
    }
  }

  @override
  void debugPaint(PaintingContext context, Offset offset) {
    assert(() {
      final Paint paint = Paint()
        ..color = Color(0xffffffff)
        ..strokeWidth = 2;
      final Canvas canvas = context.canvas;
      for (final PointerEffectData pointer in pointers) {
        canvas.drawCircle(pointer._targetPosition, 10, paint);
        canvas.drawCircle(pointer._position, 10, paint);
        canvas.drawLine(pointer._targetPosition, pointer._position, paint);
      }
      return true;
    }());

    super.debugPaint(context, offset);
  }

  @override
  @mustCallSuper
  void detach() {
    _activePointers.clear();
    super.detach();
  }
}

class PointerEffectData {
  PointerEffectData({
    required this.id,
    required this.added,
    required Offset position,
    required double t,
  })  : _t = t,
        _position = position,
        _targetPosition = position;

  final Duration added;
  final int id;

  Duration? _removed;
  Duration? get removed => removed;

  Offset _position;
  Offset _targetPosition;
  Offset get position => _position;

  double _t;
  double get t => _t;
}
