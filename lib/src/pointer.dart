import 'package:flutter/gestures.dart';
import 'package:flutter/widgets.dart';

class Pointer extends ChangeNotifier {
  Pointer({
    required Offset position,
    required Offset delta,
    required this.kind,
    required this.id,
  })  : _position = position,
        _delta = delta;

  final PointerDeviceKind kind;
  final int id;

  Offset _position;
  Offset get position => _position;

  Offset _delta;
  Offset get delta => _delta;

  bool _active = true;
  bool get active => _active;

  void handleEvent(PointerEvent event) {
    if (event.pointer != id || !_active) {
      return;
    }

    switch (event) {
      case PointerRemovedEvent():
      case PointerCancelEvent():
      case PointerExitEvent():
        _active = false;
        break;
      case PointerUpEvent():
        if (kind != PointerDeviceKind.mouse) {
          _active = false;
        }
        break;
    }

    _position = event.localPosition;
    _delta = event.localDelta;
    notifyListeners();

    if (!_active) {
      dispose();
    }
  }
}
