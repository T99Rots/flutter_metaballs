part of 'effects_cubit.dart';

@immutable
sealed class EffectState with EquatableMixin {
  const EffectState();

  MetaballsEffect? get effect;

  EffectType get type;

  @override
  List<Object?> get props => <Object?>[
        effect,
        type,
      ];
}

final class NoEffectState extends EffectState {
  const NoEffectState();

  @override
  final EffectType type = EffectType.none;

  @override
  final MetaballsEffect? effect = null;
}

final class AttractEffectState extends EffectState {
  const AttractEffectState({
    required this.effect,
  });

  @override
  final AttractEffect effect;

  @override
  final EffectType type = EffectType.attract;
}

final class FollowEffectState extends EffectState {
  const FollowEffectState({
    required this.effect,
  });

  @override
  final FollowEffect effect;

  @override
  final EffectType type = EffectType.follow;
}

final class GrowEffectState extends EffectState {
  const GrowEffectState({
    required this.effect,
  });

  @override
  final GrowEffect effect;

  @override
  final EffectType type = EffectType.grow;
}

final class RippleEffectState extends EffectState {
  const RippleEffectState({
    required this.effect,
  });

  @override
  final RippleEffect effect;

  @override
  final EffectType type = EffectType.ripple;
}

final class SpeedupEffectState extends EffectState {
  const SpeedupEffectState({
    required this.effect,
  });

  @override
  final SpeedupEffect effect;

  @override
  final EffectType type = EffectType.speedup;
}
