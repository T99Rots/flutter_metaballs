import 'metaballs_physics_scene.dart';

abstract class MetaballsPhysics {
  const MetaballsPhysics();

  MetaballsPhysicsScene<MetaballsPhysics> createPhysicsScene();
}
