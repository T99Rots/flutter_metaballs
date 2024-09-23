import 'package:bloc/bloc.dart';
import 'package:meta/meta.dart';

part 'effects_state.dart';

class EffectsCubit extends Cubit<EffectsState> {
  EffectsCubit() : super(EffectsInitial());
}
