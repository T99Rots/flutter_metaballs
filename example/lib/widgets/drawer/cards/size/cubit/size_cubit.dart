import 'package:bloc/bloc.dart';
import 'package:meta/meta.dart';

part 'size_state.dart';

class SizeCubit extends Cubit<SizeState> {
  SizeCubit() : super(SizeInitial());
}
