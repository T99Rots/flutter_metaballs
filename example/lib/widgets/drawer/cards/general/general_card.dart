import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:metaball_demo/widgets/card_with_title.dart';
import 'package:metaball_demo/widgets/drawer/cards/general/cubit/general_cubit.dart';
import 'package:metaball_demo/widgets/slider_wrapper.dart';

class GeneralCard extends StatelessWidget {
  const GeneralCard({super.key});

  @override
  Widget build(BuildContext context) {
    final GeneralCubit cubit = context.watch<GeneralCubit>();
    final GeneralState state = cubit.state;

    return CardWithTitle.list(
      title: 'General',
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: <Widget>[
          SliderWrapper(
            label: 'Metaballs count',
            value: state.count.toStringAsFixed(0),
            slider: Slider(
              value: state.count.toDouble(),
              max: 128,
              divisions: 128,
              onChanged: (double newValue) => cubit.setCount(newValue.toInt()),
            ),
          ),
          SliderWrapper(
            label: 'Glow threshold',
            value: state.glowThreshold.toStringAsFixed(2),
            slider: Slider(
              value: state.glowThreshold,
              onChanged: (double newValue) => cubit.setGlowThreshold(newValue),
            ),
          ),
          SliderWrapper(
            label: 'Glow intensity',
            value: state.glowIntensity.toStringAsFixed(2),
            slider: Slider(
              value: state.glowIntensity,
              onChanged: (double newValue) => cubit.setGlowIntensity(newValue),
            ),
          ),
        ],
      ),
    );
  }
}
