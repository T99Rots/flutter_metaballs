import 'package:bloc/bloc.dart';
import 'package:flutter/material.dart';

class BrightnessCubit extends Cubit<Brightness> {
  BrightnessCubit() : super(Brightness.dark);

  void toggleBrightness() {
    emit(switch (state) {
      Brightness.dark => Brightness.light,
      Brightness.light => Brightness.dark,
    });
  }
}
