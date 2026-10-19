import 'package:flutter/rendering.dart';
import 'package:flutter/services.dart';
import 'package:flutter/widgets.dart';
import 'package:metaballs/src/pointer.dart';

typedef PointerAddedHandler = void Function(Pointer pointer);

class PointerDetector extends SingleChildRenderObjectWidget {
  const PointerDetector({
    super.child,
    required this.onPointerAdded,
    this.mouseCursor = MouseCursor.defer,
  });

  final PointerAddedHandler onPointerAdded;
  final MouseCursor mouseCursor;

  @override
  RenderObject createRenderObject(BuildContext context) {
    return _PointerTrackerRenderer(
      onPointerAdded: onPointerAdded,
    );
  }

  @override
  void updateRenderObject(BuildContext context, covariant _PointerTrackerRenderer renderObject) {
    renderObject.onPointerAdded = onPointerAdded;
  }
}

class _PointerTrackerRenderer extends RenderProxyBox implements MouseTrackerAnnotation {
  _PointerTrackerRenderer({
    required this.onPointerAdded,
  });

  PointerAddedHandler onPointerAdded;

  final Map<int, Pointer> _pointers = <int, Pointer>{};

  @override
  void handleEvent(PointerEvent event, covariant BoxHitTestEntry entry) {
    _pointers[event.pointer]?.handleEvent(event);
  }

  @override
  MouseCursor get cursor => MouseCursor.defer;

  @override
  PointerEnterEventListener? get onEnter => _handleOnEnter;
  void _handleOnEnter(PointerEnterEvent event) {
    final Pointer pointer = Pointer(
      position: event.localPosition,
      delta: event.localDelta,
      kind: event.kind,
      id: event.pointer,
    );
    _pointers[event.pointer] = pointer;
    onPointerAdded(pointer);
  }

  @override
  PointerExitEventListener? get onExit => _handleOnExit;
  void _handleOnExit(PointerExitEvent event) {
    _pointers.remove(event.pointer);
  }

  @override
  bool get validForMouseTracker => true;
}
