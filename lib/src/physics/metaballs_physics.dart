import 'package:flutter/foundation.dart';
import 'package:flutter/rendering.dart';
import 'package:metaballs/src/metaballs_scene.dart';
import 'package:metaballs/src/models/metaball.dart';

abstract class MetaballsPhysics {
  const MetaballsPhysics();

  MetaballsPhysicsSceneAny createScene();
}

typedef MetaballsPhysicsSceneMetaballsVisitor<State extends MetaballPhysicsState> = void Function(
  Metaball metaball,
  State? state,
);

typedef MetaballsPhysicsSceneAny = MetaballsPhysicsScene<MetaballsPhysics, MetaballPhysicsState>;

abstract class MetaballsPhysicsScene<Config extends MetaballsPhysics, State extends MetaballPhysicsState> {
  final Map<Metaball, State> _stateCache = <Metaball, State>{};
  MetaballsScene? _scene;
  Config? _config;

  /// Should create a physics state for a metaball.
  ///
  /// This gets called both if this physics scene first gets loaded and all
  /// metaballs are added, and when metaballs get added during the lifecycle of
  /// this scene.
  State? createState(MetaballPhysicsState? oldState) {
    return null;
  }

  /// Gets called when a metaball is added to this physics scene.
  ///
  /// This gets called both if this physics scene first gets loaded and all
  /// metaballs are added, and when metaballs get added during the lifecycle of
  /// this scene.
  ///
  /// Should initialize the physics state associated to this metaball.
  ///
  /// If this metaball already existed in a previous [MetaballPhysicsScene],
  /// [oldState] will be the old [MetaballPhysicsState] assigned to this
  /// metaball.
  @mustCallSuper
  void adoptMetaball(Metaball metaball, MetaballPhysicsState? oldState) {
    final State? state = createState(oldState);
    if (state != null) {
      _stateCache[metaball] = state;
    }
  }

  /// Gets called when a metaball is removed from this physics scene.
  ///
  /// This gets called both if this physics scene gets unloaded and all
  /// metaballs are removed, and when metaballs get removed during the lifecycle
  /// of this scene.
  ///
  /// Should remove all associated state this physics scene keeps for this
  /// metaball.
  ///
  /// In case this physics scene does keep state for this [metaball], this
  /// method should return it.
  @mustCallSuper
  State? dropMetaball(Metaball metaball) {
    return _stateCache.remove(metaball);
  }

  /// Returns the physics state for a given metaball.
  State? getPhysicsState(Metaball metaball) {
    return _stateCache[metaball];
  }

  /// Should update the metaball current state.
  ///
  /// Gets called once a tick, usually would update the position and velocity of
  /// the passed metaball based on how much time has passed since the last tick.
  void tickMetaball(Duration frameTime, Metaball metaball, State? state) {}

  /// Gets called whenever the physics config gets updated.
  ///
  /// May update the physics state of the current metaballs if required.
  void physicsConfigUpdated(Config oldConfig) {}

  /// Gets called during rendering when debug paint is enabled.
  ///
  /// Can be used to visualize parts of the metaball physics for debugging
  /// purposes.
  void debugPaint(PaintingContext context, Offset offset) {}

  /// Ticks every metaball in the [scene].
  ///
  /// Gets called only once every tick. Should normally not be overwritten,
  /// instead [tickMetaball] should be overwritten to apply physics to the
  /// individual metaballs.
  @mustCallSuper
  void tick(Duration frameTime) {
    visitMetaballs((Metaball metaball, State? state) {
      tickMetaball(frameTime, metaball, state);
    });
  }

  /// Allows you to iterate over every metaball and its physics state.
  @mustCallSuper
  void visitMetaballs(MetaballsPhysicsSceneMetaballsVisitor<State> visitor) {
    scene.visitMetaballs((Metaball metaball) {
      final State? state = getPhysicsState(metaball);
      visitor(metaball, state);
    });
  }

  /// The current physics config.
  Config get config {
    assert(
      _config != null,
      'Tried accessing MetaballsPhysicsConfig while the physics scene was not attached to a metaballs scene.',
    );

    return _config!;
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
  void attach(MetaballsScene scene, Config config) {
    _config = config;
    _scene = scene;
  }

  @mustCallSuper
  void detach() {
    _config = null;
    _scene = null;
  }

  @mustCallSuper
  void update(Config newConfig) {
    if (_config == newConfig) {
      return;
    }

    final Config oldConfig = config;
    _config = newConfig;
    physicsConfigUpdated(oldConfig);
  }
}

class MetaballPhysicsState {
  MetaballPhysicsState({
    required this.velocity,
  });

  Offset velocity;
}
