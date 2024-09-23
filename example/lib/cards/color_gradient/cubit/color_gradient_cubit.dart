import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';
import 'package:metaball_demo/cards/color_gradient/color_presets.dart';

part 'color_gradient_cubit_state.dart';

class ColorGradientCubit extends Cubit<ColorGradientCubitState> {
  ColorGradientCubit()
      : super(
          ColorGradientCubitState(
            preset: ColorPreset.presets.first,
            alignment: Alignment.topCenter,
          ),
        );

  void setPreset(ColorPreset preset) {
    emit(
      ColorGradientCubitState(
        preset: preset,
        alignment: state.alignment,
      ),
    );
  }

  void setStartColor(Color color) {
    emit(
      ColorGradientCubitState(
        preset: ColorPreset(
          name: 'Custom',
          startColor: color,
          endColor: state.preset.endColor,
        ),
        alignment: state.alignment,
      ),
    );
  }

  void setEndColor(Color color) {
    emit(
      ColorGradientCubitState(
        preset: ColorPreset(
          name: 'Custom',
          startColor: state.preset.startColor,
          endColor: color,
        ),
        alignment: state.alignment,
      ),
    );
  }

  void setAlignment(Alignment alignment) {
    emit(
      ColorGradientCubitState(
        preset: state.preset,
        alignment: alignment,
      ),
    );
  }
}
