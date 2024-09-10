import 'package:metaballs/src/interfaces/_interfaces.dart';
import 'package:metaballs/src/physics/interface/metaball_physics_state.dart';
import 'package:metaballs/src/physics/interface/metaballs_physics_scene.dart';

class LavaLampPhysics extends MetaballsPhysics {
  const LavaLampPhysics();

  @override
  LavaLampPhysicsScene createPhysicsScene() {
    return LavaLampPhysicsScene();
  }
}

class LavaLampPhysicsScene extends MetaballsPhysicsScene<LavaLampPhysics> {
  @override
  MetaballPhysicsState? createMetaballPhysicsState(MetaballPhysicsState? oldState) {
    if(oldState == null) {
      return MetaballLavaLampPhysicsState();
    }

    return MetaballLavaLampPhysicsState.from(oldState)
  }
}

class MetaballLavaLampPhysicsState extends MetaballPhysicsState {
  MetaballLavaLampPhysicsState({
    required super.velocity,
    required this.temperature,
  });

  factory MetaballLavaLampPhysicsState.from(
    MetaballPhysicsState state, {
    double? temperature,
  }) {


    return MetaballLavaLampPhysicsState(
      temperature: temperature ?? 0,
      velocity: state.velocity,
    );
  }

  double temperature;
}
