part of 'debug_cubit.dart';

@immutable
final class DebugState with EquatableMixin {
  const DebugState({
    required this.effectsDebugging,
    required this.physicsDebugging,
  });

  final bool effectsDebugging;
  final bool physicsDebugging;

  @override
  List<Object?> get props => <Object?>[
        effectsDebugging,
        physicsDebugging,
      ];

  DebugState copyWith({
    bool? effectsDebugging,
    bool? physicsDebugging,
  }) {
    return DebugState(
      effectsDebugging: effectsDebugging ?? this.effectsDebugging,
      physicsDebugging: physicsDebugging ?? this.physicsDebugging,
    );
  }
}
