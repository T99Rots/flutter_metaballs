part of 'physics_cubit.dart';

@immutable
sealed class PhysicsState {
  const PhysicsState();

  PhysicsType get type;
}

final class BouncingPhysicsState extends PhysicsState {
  const BouncingPhysicsState({
    required this.physics,
  });

  final BouncingPhysics physics;

  @override
  final PhysicsType type = PhysicsType.bouncing;
}

final class LavaLampPhysicsState extends PhysicsState {
  const LavaLampPhysicsState();

  @override
  final PhysicsType type = PhysicsType.lavaLamp;
}
