import 'dart:math';
import 'dart:ui';

import 'package:metaballs/src/physics/advanced_metaball_physics.dart';
import 'package:metaballs/src/physics/metaballs_physics.dart';

class LavaLampPhysics extends MetaballsPhysics {
  const LavaLampPhysics({
    this.heatSourceTemperature = 0,
    this.friction = 2,
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
  MetaballLavaLampPhysicsState createState() {
    return MetaballLavaLampPhysicsState();
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

class MetaballLavaLampPhysicsState extends AdvancedMetaballPhysicsState<LavaLampPhysics> {
  final Random _random = Random();

  late double temperature;

  @override
  void initState(MetaballStateAny? oldState) {
    if (oldState is MetaballLavaLampPhysicsState) {
      velocity = oldState.velocity;
      temperature = oldState.temperature;
    }

    if (oldState is AdvancedMetaballPhysicsState) {
      velocity = oldState.velocity;
    } else {
      velocity = Offset.zero;
    }

    temperature = _random.nextDouble() * physics.heatSourceTemperature;
  }

  @override
  double get debugForceScale => 30;

  @override
  double get friction => physics.friction;

  @override
  void applyForces() {}

  @override
  double get mass => 1;
}
