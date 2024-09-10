import 'package:metaballs/src/interfaces/_interfaces.dart';
import 'package:metaballs/src/pointer.dart';

abstract class MetaballsEffectController {
  MetaballsEffectController();

  Metaball createMetaball();

  void tick(Duration elapsed);

  void handlePointer(Pointer pointer) {}
}
