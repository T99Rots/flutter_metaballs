import 'package:bloc/bloc.dart';
import 'package:meta/meta.dart';

part 'examples_state.dart';

class ExamplesCubit extends Cubit<ExamplesState> {
  ExamplesCubit() : super(ExamplesInitial());
}
