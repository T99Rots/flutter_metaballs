import 'package:flutter/foundation.dart';
import 'package:flutter/rendering.dart';
import 'package:metaballs/src/metaballs_scene.dart';
import 'package:metaballs/src/models/metaball.dart';

typedef MetaballStateAny = MetaballState<MetaballsPhysics>;

abstract class MetaballsPhysics {
  const MetaballsPhysics();

  MetaballStateAny createState();
}

class MetaballState<Physics extends MetaballsPhysics> {
  MetaballsScene? _scene;
  Physics? _physics;
  Metaball? _metaball;

  void initState(MetaballStateAny? oldState) {}

  void tick(Duration frameTime) {}

  /// The current physics physics.
  Physics get physics {
    assert(
      _physics != null,
      'Tried accessing MetaballState.physics while the physics state was not attached to a metaballs scene.',
    );

    return _physics!;
  }

  /// The parent metaballs scene.
  MetaballsScene get scene {
    assert(
      _scene != null,
      'Tried accessing MetaballState.scene while the physics state was not attached to a metaballs scene.',
    );

    return _scene!;
  }

  Metaball get metaball {
    assert(
      _metaball != null,
      'Tried accessing MetaballState.metaball while the physics state was not attached to a metaball.',
    );

    return _metaball!;
  }

  void physicsUpdated(Physics oldPhysics) {}

  void update(Physics physics) {
    final Physics oldPhysics = _physics!;
    _physics = physics;
    physicsUpdated(oldPhysics);
  }

  @mustCallSuper
  void attach(MetaballsScene scene, Physics physics, Metaball metaball) {
    _physics = physics;
    _scene = scene;
    _metaball = metaball;
  }

  @mustCallSuper
  void detach() {
    _physics = null;
    _scene = null;
    _metaball = null;
  }

  void debugPaint(PaintingContext context, Offset offset) {}
}
