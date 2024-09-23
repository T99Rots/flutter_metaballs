import 'package:bloc/bloc.dart';
import 'package:meta/meta.dart';
import 'package:metaball_demo/widgets/drawer/cards/physics/physics_card.dart';
import 'package:metaballs/metaballs.dart';

part 'physics_state.dart';

class PhysicsCubit extends Cubit<PhysicsState> {
  PhysicsCubit()
      : super(
          const BouncingPhysicsState(
            physics: BouncingPhysics(),
          ),
        );

  void setPhysicsType(PhysicsType type) {
    if (state.type == type) {
      return;
    }

    emit(switch (type) {
      PhysicsType.bouncing => const BouncingPhysicsState(
          physics: BouncingPhysics(),
        ),
      PhysicsType.lavaLamp => const LavaLampPhysicsState(),
    });
  }
}
