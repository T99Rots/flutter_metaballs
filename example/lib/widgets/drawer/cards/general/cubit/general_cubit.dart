import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:meta/meta.dart';

part 'general_state.dart';

class GeneralCubit extends Cubit<GeneralState> {
  GeneralCubit()
      : super(const GeneralState(
          count: 40,
          glowIntensity: 0.4,
          glowThreshold: 0.4,
        ));

  void setCount(int newValue) {
    emit(
      state.copyWith(
        count: newValue,
      ),
    );
  }

  void setGlowThreshold(double newValue) {
    emit(
      state.copyWith(
        glowThreshold: newValue,
      ),
    );
  }

  void setGlowIntensity(double newValue) {
    emit(
      state.copyWith(
        glowIntensity: newValue,
      ),
    );
  }
}
