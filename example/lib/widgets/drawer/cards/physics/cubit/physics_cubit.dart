import 'package:bloc/bloc.dart';
import 'package:meta/meta.dart';

part 'physics_state.dart';

class PhysicsCubit extends Cubit<PhysicsState> {
  PhysicsCubit() : super(PhysicsInitial());
}
