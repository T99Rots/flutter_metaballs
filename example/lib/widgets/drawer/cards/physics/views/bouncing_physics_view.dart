import 'package:flutter/material.dart';
import 'package:metaball_demo/widgets/drawer/cards/physics/cubit/physics_cubit.dart';
import 'package:metaball_demo/widgets/slider_wrapper.dart';

class BouncingPhysicsView extends StatelessWidget {
  const BouncingPhysicsView({
    super.key,
    required this.state,
  });

  final BouncingPhysicsState state;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: <Widget>[
        // final double maxForce;
        SliderWrapper(
          label: 'Maximum Force',
          value: '1',
          slider: Slider(
            value: 0.5,
            onChanged: (_) {},
          ),
        ),
        // final double friction;
        SliderWrapper(
          label: 'Friction',
          value: '0.5',
          slider: Slider(
            value: 0.5,
            onChanged: (_) {},
          ),
        ),
        // final double metaballMass;
        SliderWrapper(
          label: 'Metaball Mass',
          value: '1',
          slider: Slider(
            value: 0.5,
            onChanged: (_) {},
          ),
        ),
        // final bool hasInitialSpeed;
        SwitchListTile(
          title: const Text('Initialize with terminal velocity'),
          value: true,
          onChanged: (_) {},
        ),
      ],
    );
  }
}
