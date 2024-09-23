part of 'color_gradient_cubit.dart';

@immutable
final class ColorGradientCubitState with EquatableMixin {
  const ColorGradientCubitState({
    required this.preset,
    required this.alignment,
  });

  final ColorPreset preset;
  final Alignment alignment;

  @override
  List<Object?> get props => <Object?>[
        preset,
        alignment,
      ];
}
