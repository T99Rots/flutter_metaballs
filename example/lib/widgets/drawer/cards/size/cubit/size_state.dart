part of 'size_cubit.dart';

@immutable
sealed class SizeState with EquatableMixin {
  const SizeState();

  ScalerType get type;
  MetaballScaler get scaler;

  @override
  List<Object?> get props => <Object?>[
        type,
        scaler,
      ];
}

final class SizeDynamicState extends SizeState {
  const SizeDynamicState({
    required this.scaler,
  });

  @override
  final MetaballDynamicScaler scaler;

  @override
  final ScalerType type = ScalerType.dynamic;
}

final class SizeStaticState extends SizeState {
  const SizeStaticState({
    required this.scaler,
  });

  @override
  final MetaballStaticScaler scaler;

  @override
  final ScalerType type = ScalerType.static;
}

final class SizeDynamicRangeState extends SizeState {
  const SizeDynamicRangeState({
    required this.scaler,
  });

  @override
  final MetaballDynamicRangeScaler scaler;

  @override
  final ScalerType type = ScalerType.dynamicRange;
}

final class SizeStaticRangeState extends SizeState {
  const SizeStaticRangeState({
    required this.scaler,
  });

  @override
  final MetaballStaticRangeScaler scaler;

  @override
  final ScalerType type = ScalerType.staticRange;
}
