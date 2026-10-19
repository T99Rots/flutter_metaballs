import 'package:metaballs/src/effects/interface/metaballs_effect.dart';
import 'package:metaballs/src/metaballs_scene.dart';
import 'package:metaballs/src/pointer.dart';

class FollowEffect extends MetaballsEffect {
  const FollowEffect();

  @override
  FollowEffectState createState() => FollowEffectState();
}

class FollowEffectState extends MetaballsEffectState<FollowEffect> {
  final Map<int, PointerData> _pointerCache = <int, PointerData>{};

  @override
  void handlePointer(MetaballsScene scene, Pointer pointer) {
    _pointerCache[pointer.id] = PointerData(
      added: scene.elapsed,
      pointer: pointer,
    );
  }

  @override
  void detach() {
    _pointerCache.clear();
    super.detach();
  }
}

class PointerData {
  PointerData({
    required this.added,
    required this.pointer,
  });

  final Pointer pointer;
  final Duration added;
  Duration? removed;
}
