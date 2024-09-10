import 'package:metaballs/src/interfaces/_interfaces.dart';

import 'metaball_physics_state.dart';

abstract class MetaballsPhysicsScene<Config extends MetaballsPhysics, State extends MetaballPhysicsState> {
  final Map<Metaball, State> _stateCache = <Metaball, State>{};

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
  void metaballAdded(Metaball metaball, MetaballPhysicsState? oldState) {
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
  State? metaballRemoved(Metaball metaball) {
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
  void updateMetaball(Duration elapsed, Metaball metaball, State state) {}

  /// Gets called whenever the physics config gets updated.
  ///
  /// May update the physics state of the current metaballs if required.
  void physicsConfigUpdated() {}

  Config get config {}
}
