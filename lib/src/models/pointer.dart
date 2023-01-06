import 'package:flutter/gestures.dart';

class Pointer {
  final double created;
  Offset position;
  Offset delta;
  double timeDeleted = -1;
  PointerDeviceKind kind;

  Pointer({
    required this.created,
    required this.delta,
    required this.position,
    required this.kind,
  });
}
