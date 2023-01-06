import 'package:flutter/gestures.dart';
import 'package:flutter/widgets.dart';

class CombinedListener extends StatefulWidget {
  final void Function(PointerEvent event)? onMove;
  final void Function(PointerEvent event)? onAdd;
  final void Function(PointerEvent event)? onRemove;
  final void Function(PointerEvent event)? onPress;
  final Widget? child;

  const CombinedListener({
    Key? key,
    this.onMove,
    this.onAdd,
    this.onRemove,
    this.onPress,
    this.child,
  }) : super(key: key);

  @override
  State<CombinedListener> createState() => CombinedListenerState();
}

class CombinedListenerState extends State<CombinedListener> {
  PointerEvent? _mouseEvent;

  @override
  Widget build(BuildContext context) {
    return MouseRegion(
      onExit: (event) {
        if (_mouseEvent != null) {
          widget.onRemove?.call(event);
          _mouseEvent = null;
        }
      },
      child: Listener(
        onPointerDown: (event) {
          if (event.kind == PointerDeviceKind.touch) {
            widget.onAdd?.call(event);
          }
          widget.onPress?.call(event);
        },
        onPointerMove: (event) {
          if (_mouseEvent != null && event.kind == PointerDeviceKind.mouse) {
            widget.onMove?.call(event.copyWith(pointer: _mouseEvent!.pointer));
          } else {
            widget.onMove?.call(event);
          }
        },
        onPointerCancel: widget.onRemove,
        onPointerUp: widget.onRemove,
        onPointerHover: (event) {
          if (event.kind == PointerDeviceKind.mouse) {
            if (_mouseEvent == null) {
              widget.onAdd?.call(event);
            } else {
              widget.onMove?.call(event);
            }
            _mouseEvent = event;
          }
        },
        child: widget.child,
      ),
    );
  }
}
