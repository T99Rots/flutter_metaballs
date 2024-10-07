part of 'physics_cubit.dart';

@immutable
sealed class PhysicsState with EquatableMixin {
  const PhysicsState();

  MetaballsPhysics get physics;

  PhysicsType get type;

  @override
  List<Object?> get props => <Object?>[
        physics,
        type,
      ];
}

final class BouncingPhysicsState extends PhysicsState {
  const BouncingPhysicsState({
    required this.physics,
  });

  @override
  final BouncingPhysics physics;

  @override
  final PhysicsType type = PhysicsType.bouncing;
}

final class LavaLampPhysicsState extends PhysicsState {
  const LavaLampPhysicsState({
    required this.physics,
  });

  @override
  final LavaLampPhysics physics;

  @override
  final PhysicsType type = PhysicsType.lavaLamp;
}
