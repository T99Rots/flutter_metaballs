import 'dart:math';
import 'dart:ui';

import 'package:metaballs/src/models/metaball.dart';
import 'package:metaballs/src/physics/interface/metaballs_physics.dart';

class LavaLampPhysics extends MetaballsPhysics {
  const LavaLampPhysics({
    required this.heatSourceTemperature,
    required this.friction,
    required this.forceMultiplier,
    required this.ambientCooling,
    required this.heatSourceFallOff,
  });

  final double heatSourceTemperature;
  final double heatSourceFallOff;
  final double friction;
  final double forceMultiplier;
  final double ambientCooling;

  @override
  LavaLampPhysicsScene createScene() {
    return LavaLampPhysicsScene();
  }
}

class LavaLampPhysicsScene extends MetaballsPhysicsScene<LavaLampPhysics, MetaballLavaLampPhysicsState> {
  final Random _random = Random();

  @override
  MetaballLavaLampPhysicsState createState(MetaballPhysicsState? oldState) {
    if (oldState is MetaballLavaLampPhysicsState) {
      return oldState;
    }

    return MetaballLavaLampPhysicsState(
      temperature: _random.nextDouble() * config.heatSourceTemperature,
      velocity: oldState?.velocity ?? Offset.zero,
    );
  }

  @override
  void tickMetaball(Duration frameTime, Metaball metaball, MetaballLavaLampPhysicsState? state) {
    if (state == null) {
      return;
    }
  }
}

class MetaballLavaLampPhysicsState extends MetaballPhysicsState {
  MetaballLavaLampPhysicsState({
    required super.velocity,
    required this.temperature,
  });

  double temperature;
}
