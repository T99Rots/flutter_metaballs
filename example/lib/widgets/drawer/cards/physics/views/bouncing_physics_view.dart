import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:metaball_demo/widgets/drawer/cards/physics/cubit/physics_cubit.dart';
import 'package:metaball_demo/widgets/slider_wrapper.dart';
import 'package:metaballs/src/physics/bouncing_physics.dart';

class BouncingPhysicsView extends StatelessWidget {
  const BouncingPhysicsView({
    super.key,
    required this.state,
  });

  final BouncingPhysicsState state;

  @override
  Widget build(BuildContext context) {
    final BouncingPhysics physics = state.physics;

    return Column(
      children: <Widget>[
        SliderWrapper(
          label: 'Force',
          value: '${state.physics.minForce.toStringAsFixed(2)} - ${state.physics.maxForce.toStringAsFixed(2)}',
          slider: RangeSlider(
            values: RangeValues(
              state.physics.minForce,
              state.physics.maxForce,
            ),
            max: 5,
            divisions: 100,
            onChanged: (RangeValues values) => context.read<PhysicsCubit>().setForce(
                  values.start,
                  values.end,
                ),
          ),
        ),
        SliderWrapper(
          label: 'Friction',
          value: physics.friction.toStringAsFixed(1),
          slider: Slider(
            value: physics.friction,
            divisions: 100,
            max: 50,
            onChanged: (double newValue) => context.read<PhysicsCubit>().setFriction(newValue),
          ),
        ),
        SliderWrapper(
          label: 'Metaball Mass',
          value: physics.mass.toStringAsFixed(1),
          slider: Slider(
            value: physics.mass,
            divisions: 99,
            max: 50,
            min: 0.5,
            onChanged: (double newValue) => context.read<PhysicsCubit>().setMetaballMass(newValue),
          ),
        ),
        SwitchListTile(
          title: const Text('Initialize with terminal velocity'),
          value: physics.hasInitialSpeed,
          onChanged: (bool newValue) => context.read<PhysicsCubit>().setHasInitialSpeed(newValue),
        ),
      ],
    );
  }
}
