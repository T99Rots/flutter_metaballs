import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:metaball_demo/widgets/better_dropdown.dart';
import 'package:metaball_demo/widgets/card_with_title.dart';
import 'package:metaball_demo/widgets/drawer/cards/physics/cubit/physics_cubit.dart';
import 'package:metaball_demo/widgets/drawer/cards/physics/views/bouncing_physics_view.dart';
import 'package:metaball_demo/widgets/drawer/cards/physics/views/lava_lamp_physics_view.dart';

class PhysicsCard extends StatelessWidget {
  const PhysicsCard({super.key});

  @override
  Widget build(BuildContext context) {
    return CardWithTitle.list(
      title: 'Physics',
      child: BlocBuilder<PhysicsCubit, PhysicsState>(
        builder: (BuildContext context, PhysicsState state) {
          return Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 15),
                child: BetterDropdown<PhysicsType>(
                  label: 'Select physics type',
                  items: const <DropdownMenuItem<PhysicsType>>[
                    DropdownMenuItem<PhysicsType>(
                      value: PhysicsType.bouncing,
                      child: Text('Bouncing Physics'),
                    ),
                    DropdownMenuItem<PhysicsType>(
                      value: PhysicsType.lavaLamp,
                      child: Text('Lava Lamp Physics'),
                    ),
                  ],
                  value: state.type,
                  onChange: (PhysicsType? value) {
                    if (value == null) {
                      return;
                    }

                    context.read<PhysicsCubit>().setPhysicsType(value);
                  },
                ),
              ),
              const SizedBox(height: 20),
              switch (state) {
                BouncingPhysicsState() => BouncingPhysicsView(
                    state: state,
                  ),
                LavaLampPhysicsState() => LavaLampPhysicsView(
                    state: state,
                  ),
              }
            ],
          );
        },
      ),
    );
  }
}

enum PhysicsType {
  bouncing,
  lavaLamp,
}
