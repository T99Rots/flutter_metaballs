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

  void handleEvent(PointerEvent event) {
    if (event.pointer != id) {
      return;
    }

    bool shouldNotify = false;

    if (_position != event.position) {
      _position = event.position;
      shouldNotify = true;
    }

    if (_delta != event.delta) {
      _delta = event.delta;
      shouldNotify = true;
    }

    if (shouldNotify) {
      notifyListeners();
    }
  }
}
