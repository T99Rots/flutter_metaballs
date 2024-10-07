import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:meta/meta.dart';

part 'debug_state.dart';

class DebugCubit extends Cubit<DebugState> {
  DebugCubit()
      : super(const DebugState(
          effectsDebugging: false,
          physicsDebugging: false,
        ));

  void setEffectsDebugging(bool newValue) {
    emit(state.copyWith(
      effectsDebugging: newValue,
    ));
  }

  void setPhysicsDebugging(bool newValue) {
    emit(state.copyWith(
      physicsDebugging: newValue,
    ));
  }
}
