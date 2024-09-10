import 'dart:math';

import 'package:flutter/widgets.dart';
import 'package:metaballs/src/interfaces/_interfaces.dart';

class MetaballsNoEffectController extends MetaballsEffectController {
  MetaballsNoEffectController();

  final Random _random = Random();

  @override
  void tick(Size size) {
    // TODO: implement buildFrame
    throw UnimplementedError();
  }

  @override
  void handlePointer(PointerEvent event) {
    // TODO: implement handleEvent
  }

  @override
  Metaball createMetaball() {
    return Metaball(
      position: Offset(_random.nextDouble(), _random.nextDouble()),
      radius: radius,
    );
  }
}
