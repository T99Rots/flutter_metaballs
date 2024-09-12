import 'package:flutter/widgets.dart';
import 'package:metaballs/src/metaballs_scene.dart';
import 'package:metaballs/src/pointer.dart';

abstract class MetaballsEffect {
  const MetaballsEffect();

  MetaballsEffectState<MetaballsEffect> createState();
}

typedef MetaballsEffectStateAny = MetaballsEffectState<MetaballsEffect>;

abstract class MetaballsEffectState<Effect extends MetaballsEffect> {
  MetaballsScene? _scene;
  Effect? _effect;

  void beforePhysics(MetaballsScene scene) {}

  void beforeRender(MetaballsScene scene) {}

  void handlePointer(MetaballsScene scene, Pointer pointer) {}

  void effectUpdated(Effect oldEffect) {}

  double getTimeScale() {
    return 1.0;
  }

  /// The current effect.
  Effect get effect {
    assert(
      _effect != null,
      'Tried accessing effect while the physics scene was not attached to a metaballs scene.',
    );

    return _effect!;
  }

  /// The parent metaballs scene.
  MetaballsScene get scene {
    assert(
      _scene != null,
      'Tried accessing MetaballsScene while the physics scene was not attached to a metaballs scene.',
    );

    return _scene!;
  }

  @mustCallSuper
  void detach() {
    _effect = null;
    _scene = null;
  }

  @mustCallSuper
  void attach(MetaballsScene scene, Effect effect) {
    _effect = effect;
    _scene = scene;
  }

  @mustCallSuper
  void update(Effect newEffect) {
    if (_effect == newEffect) {
      return;
    }

    final Effect oldEffect = effect;
    _effect = newEffect;
    effectUpdated(oldEffect);
  }
}
