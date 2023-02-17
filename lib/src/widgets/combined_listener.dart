import 'dart:async';

import 'package:flutter/gestures.dart';
import 'package:flutter/widgets.dart';

class CombinedListener extends StatefulWidget {
  const CombinedListener({
    Key? key,
    this.child,
    required this.onPointerAdded,
    required this.onTap,
    required this.animation,
  }) : super(key: key);

  final Widget? child;

  final void Function(Pointer pointer) onPointerAdded;
  final void Function(TapEvent tabEvent) onTap;
  final Animation<double> animation;

  @override
  State<CombinedListener> createState() => CombinedListenerState();
}

class CombinedListenerState extends State<CombinedListener> {
  final Map<int, Pointer> _pointers = <int, Pointer>{};
  PointerEvent? _mouseEvent;

  @override
  Widget build(BuildContext context) {
    return MouseRegion(
      onExit: (PointerExitEvent event) {
        if (_mouseEvent != null) {
          onRemove.call(event);
          _mouseEvent = null;
        }
      },
      child: Listener(
        onPointerDown: (PointerDownEvent event) {
          if (event.kind == PointerDeviceKind.touch) {
            onAdd.call(event);
          }
          onPress.call(event);
        },
        onPointerMove: (PointerMoveEvent event) {
          if (_mouseEvent != null && event.kind == PointerDeviceKind.mouse) {
            onMove.call(event.copyWith(pointer: _mouseEvent!.pointer));
          } else {
            onMove.call(event);
          }
        },
        onPointerCancel: onRemove,
        onPointerUp: onRemove,
        onPointerHover: (PointerHoverEvent event) {
          if (event.kind == PointerDeviceKind.mouse) {
            if (_mouseEvent == null) {
              onAdd.call(event);
            } else {
              onMove.call(event);
            }
            _mouseEvent = event;
          }
        },
        child: widget.child,
      ),
    );
  }

  void onMove(PointerEvent event) {
    if (event.delta.distance > 0 && _pointers.containsKey(event.pointer)) {
      _pointers[event.pointer]!.addEvent(
        position: event.localPosition,
        delta: event.delta,
      );
    }
  }

  void onAdd(PointerEvent event) {
    if (!_pointers.containsKey(event.pointer)) {
      final Pointer pointer = _pointers[event.pointer] = Pointer(
        animation: widget.animation,
        position: event.localPosition,
        kind: event.kind,
        id: event.pointer,
      );

      widget.onPointerAdded(pointer);
    }
  }

  void onRemove(PointerEvent event) {
    _pointers.remove(event.pointer)?.remove();
  }

  void onPress(PointerEvent event) {
    widget.onTap(TapEvent(
      position: event.localPosition,
      time: widget.animation.value,
    ));
  }
}

class Pointer extends Stream<PointerUpdateEvent> {
  Pointer({
    required this.id,
    required this.kind,
    required Offset position,
    required Animation<double> animation,
  })  : _animation = animation,
        _createdTime = animation.value,
        _lastEvent = PointerUpdateEvent(
          position: position,
          delta: const Offset(0, 0),
          time: animation.value,
        ) {
    _controller.add(_lastEvent);
  }

  final int id;
  final PointerDeviceKind kind;

  final StreamController<PointerUpdateEvent> _controller = StreamController<PointerUpdateEvent>();
  final Animation<double> _animation;
  final double _createdTime;

  double? _removedTime;
  PointerUpdateEvent _lastEvent;

  double get createdTime => _createdTime;
  double? get removedTime => _removedTime;

  Offset get position => _lastEvent.position;
  Offset get delta => _lastEvent.delta;

  bool get removed => _removedTime != null;

  @override
  StreamSubscription<PointerUpdateEvent> listen(
    void Function(PointerUpdateEvent event)? onData, {
    Function? onError,
    void Function()? onDone,
    bool? cancelOnError,
  }) {
    return _controller.stream.listen(
      onData,
      onDone: onDone,
      onError: onError,
      cancelOnError: cancelOnError,
    );
  }

  void addEvent({
    required Offset position,
    required Offset delta,
  }) {
    _controller.add(_lastEvent = PointerUpdateEvent(
      position: position,
      delta: delta,
      time: _animation.value,
    ));
  }

  void remove() {
    _controller.close();
    _removedTime = _animation.value;
  }
}

class TapEvent {
  TapEvent({
    required this.position,
    required this.time,
  });

  final Offset position;
  final double time;
}

class PointerUpdateEvent {
  PointerUpdateEvent({
    required this.position,
    required this.delta,
    required this.time,
  });

  final Offset position;
  final Offset delta;
  final double time;
}
