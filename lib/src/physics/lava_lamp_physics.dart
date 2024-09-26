import 'dart:math';
import 'dart:ui';

import 'package:metaballs/src/models/metaball.dart';
import 'package:metaballs/src/physics/metaballs_physics.dart';

class LavaLampPhysics extends MetaballsPhysics {
  const LavaLampPhysics({
    this.heatSourceTemperature = 0,
    this.friction = 0,
    this.forceMultiplier = 0,
    this.ambientCooling = 0,
    this.heatSourceFallOff = 0,
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

  @override
  int get hashCode => Object.hash(
        heatSourceTemperature,
        heatSourceFallOff,
        friction,
        forceMultiplier,
        ambientCooling,
      );

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is LavaLampPhysics && other.runtimeType == runtimeType && other.hashCode == hashCode;

  LavaLampPhysics copyWith({
    double? heatSourceTemperature,
    double? heatSourceFallOff,
    double? friction,
    double? forceMultiplier,
    double? ambientCooling,
  }) {
    return LavaLampPhysics(
      heatSourceTemperature: heatSourceTemperature ?? this.heatSourceTemperature,
      heatSourceFallOff: heatSourceFallOff ?? this.heatSourceFallOff,
      friction: friction ?? this.friction,
      forceMultiplier: forceMultiplier ?? this.forceMultiplier,
      ambientCooling: ambientCooling ?? this.ambientCooling,
    );
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
