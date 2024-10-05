import 'package:bloc/bloc.dart';
import 'package:metaball_demo/widgets/drawer/cards/examples/examples_card.dart';

class ExamplesCubit extends Cubit<ExampleLayouts> {
  ExamplesCubit() : super(ExampleLayouts.none);

  void setExample(ExampleLayouts example) {
    emit(example);
  }
}
