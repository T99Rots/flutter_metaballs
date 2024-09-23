import 'package:bloc/bloc.dart';
import 'package:meta/meta.dart';

part 'debug_state.dart';

class DebugCubit extends Cubit<DebugState> {
  DebugCubit() : super(DebugInitial());
}
