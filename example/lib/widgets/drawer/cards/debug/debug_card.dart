import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:metaball_demo/widgets/card_with_title.dart';
import 'package:metaball_demo/widgets/drawer/cards/debug/cubit/debug_cubit.dart';

class DebugCard extends StatelessWidget {
  const DebugCard({super.key});

  @override
  Widget build(BuildContext context) {
    final DebugCubit cubit = context.watch();
    final DebugState state = cubit.state;

    return CardWithTitle.list(
      title: 'Debugging',
      child: Column(
        children: <Widget>[
          SwitchListTile(
            title: const Text('Effects debugging'),
            value: state.effectsDebugging,
            onChanged: (bool newValue) => cubit.setEffectsDebugging(newValue),
          ),
          SwitchListTile(
            title: const Text('Physics debugging'),
            value: state.physicsDebugging,
            onChanged: (bool newValue) => cubit.setPhysicsDebugging(newValue),
          ),
        ],
      ),
    );
  }
}
