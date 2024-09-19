import 'package:flutter/rendering.dart';
import 'package:flutter/services.dart';
import 'package:flutter/widgets.dart';

typedef PointerEventCallback = void Function(PointerEvent event);

class PointerEventListener extends SingleChildRenderObjectWidget {
  const PointerEventListener({
    super.child,
    required this.onPointerEvent,
    this.mouseCursor = MouseCursor.defer,
    this.behavior = HitTestBehavior.deferToChild,
  });

  final PointerEventCallback onPointerEvent;
  final MouseCursor mouseCursor;
  final HitTestBehavior behavior;

  @override
  RenderObject createRenderObject(BuildContext context) {
    return _PointerEventListenerRenderer(
      onPointerEvent: onPointerEvent,
      cursor: mouseCursor,
      behavior: behavior,
    );
  }

  @override
  void updateRenderObject(BuildContext context, covariant _PointerEventListenerRenderer renderObject) {
    renderObject.onPointerEvent = onPointerEvent;
    renderObject.behavior = behavior;
    renderObject.cursor = mouseCursor;
  }
}

class _PointerEventListenerRenderer extends RenderProxyBoxWithHitTestBehavior implements MouseTrackerAnnotation {
  _PointerEventListenerRenderer({
    required super.behavior,
    required this.onPointerEvent,
    required this.cursor,
  });

  PointerEventCallback onPointerEvent;

  @override
  MouseCursor cursor;

  @override
  void handleEvent(PointerEvent event, covariant BoxHitTestEntry entry) => onPointerEvent(event);

  @override
  PointerEnterEventListener? get onEnter => onPointerEvent;

  @override
  PointerExitEventListener? get onExit => onPointerEvent;

  @override
  bool get validForMouseTracker => true;
}
