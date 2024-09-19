import 'package:flutter/gestures.dart';
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
    this.behavior = HitTestBehavior.deferToChild,
  });

  final PointerAddedHandler onPointerAdded;
  final MouseCursor mouseCursor;
  final HitTestBehavior behavior;

  @override
  RenderObject createRenderObject(BuildContext context) {
    return _PointerTrackerRenderer(
      onPointerAdded: onPointerAdded,
      behavior: behavior,
    );
  }

  @override
  void updateRenderObject(BuildContext context, covariant _PointerTrackerRenderer renderObject) {
    renderObject.onPointerAdded = onPointerAdded;
    renderObject.behavior = behavior;
  }
}

class _PointerTrackerRenderer extends RenderProxyBoxWithHitTestBehavior implements MouseTrackerAnnotation {
  _PointerTrackerRenderer({
    required this.onPointerAdded,
    super.behavior = HitTestBehavior.deferToChild,
  });

  PointerAddedHandler onPointerAdded;

  final Map<int, Pointer> _pointers = <int, Pointer>{};

  @override
  void handleEvent(PointerEvent event, covariant BoxHitTestEntry entry) => _handlePointerEvent(event);

  @override
  MouseCursor get cursor => MouseCursor.defer;

  @override
  PointerEnterEventListener? get onEnter => _handlePointerEvent;

  @override
  PointerExitEventListener? get onExit => _handlePointerEvent;

  void _handlePointerEvent(PointerEvent event) {
    final Pointer? pointer = _pointers[event.pointer];
    if (pointer == null) {
      switch (event) {
        case PointerRemovedEvent():
        case PointerCancelEvent():
        case PointerExitEvent():
        case PointerUpEvent():
        case PointerHoverEvent():
          return;
      }

      final Pointer pointer = Pointer(
        position: event.localPosition,
        delta: event.localDelta,
        kind: event.kind,
        id: event.pointer,
      );
      _pointers[event.pointer] = pointer;
      onPointerAdded(pointer);
      return;
    }

    pointer.handleEvent(event);
    if (!pointer.active) {
      _pointers.remove(event.pointer);
    }
  }

  @override
  bool get validForMouseTracker => true;
}
