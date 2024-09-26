part of 'general_cubit.dart';

@immutable
final class GeneralState with EquatableMixin {
  const GeneralState({
    required this.count,
    required this.glowIntensity,
    required this.glowThreshold,
  });

  final int count;
  final double glowThreshold;
  final double glowIntensity;

  @override
  List<Object?> get props => <Object?>[
        count,
        glowIntensity,
        glowThreshold,
      ];

  GeneralState copyWith({
    int? count,
    double? glowThreshold,
    double? glowIntensity,
  }) {
    return GeneralState(
      count: count ?? this.count,
      glowThreshold: glowThreshold ?? this.glowThreshold,
      glowIntensity: glowIntensity ?? this.glowIntensity,
    );
  }
}
