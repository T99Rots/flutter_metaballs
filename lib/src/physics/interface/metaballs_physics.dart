import 'package:metaballs/src/physics/interface/metaball_physics_state.dart';

import 'metaballs_physics_scene.dart';

abstract class MetaballsPhysics {
  const MetaballsPhysics();

  MetaballsPhysicsScene<MetaballsPhysics, MetaballPhysicsState> createPhysicsScene();
}
