import 'package:flutter/widgets.dart';
import 'package:metaballs/src/metaballs_scene.dart';
import 'package:metaballs/src/models/metaball.dart';
import 'package:metaballs/src/pointer.dart';

abstract class MetaballsEffect {
  const MetaballsEffect();

  MetaballsEffectState<MetaballsEffect> createState();
}

typedef MetaballsEffectStateAny = MetaballsEffectState<MetaballsEffect>;

abstract class MetaballsEffectState<Effect extends MetaballsEffect> {
  final List<Metaball> _effectMetaballs = <Metaball>[];
  MetaballsScene? _scene;
  Effect? _effect;

  /// Gets called before physics have been applied.
  void beforePhysics(MetaballsScene scene) {}

  /// Gets called after physics have been applied.
  ///
  /// [scene.viewportSize] may not be available at this point. If you rely on
  /// the viewport size use the [beforeRenderTransform] or [beforeRender].
  void afterPhysics(MetaballsScene scene) {}

  /// Gets called before the render transform gets applied.
  ///
  /// This may get called right before the render runs, ideally you should not
  /// run heavy calculations at this point unless access [scene.viewportSize]
  /// is required.
  void beforeRenderTransform(MetaballsScene scene) {}

  /// Gets called before rendering.
  ///
  /// This may get called right before the render runs, ideally you should not
  /// run heavy calculations at this point unless access [scene.viewportSize]
  /// is required.
  void beforeRender(MetaballsScene scene) {}

  /// Gets called every time a new pointer gets added to the widget.
  void handlePointer(MetaballsScene scene, Pointer pointer) {}

  /// Gets called when the [Effect] class has been updated.
  void effectUpdated(Effect oldEffect) {}

  /// Should return a scale which gets applied to the [frameTime] before physics.
  ///
  /// Primarily used for slowdown or speed up effects based on user input.
  /// Should ideally not be used to permanently alter physics.
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
