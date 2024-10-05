import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:metaball_demo/widgets/drawer/cards/effects/cubit/effects_cubit.dart';
import 'package:metaball_demo/widgets/slider_wrapper.dart';
import 'package:metaballs/src/effects/speedup_effect.dart';

class SpeedupEffectView extends StatelessWidget {
  const SpeedupEffectView({
    super.key,
    required this.state,
  });

  final SpeedupEffectState state;

  @override
  Widget build(BuildContext context) {
    final SpeedupEffect effect = state.effect;

    // double maxSpeedup
    // double speedupRate

    return Column(
      children: <Widget>[
        SliderWrapper(
          label: 'Max Speedup',
          value: effect.maxSpeedup.toStringAsFixed(2),
          slider: Slider(
            value: effect.maxSpeedup,
            min: 0,
            max: 10,
            divisions: 100,
            onChanged: (double value) => context.read<EffectsCubit>().setSpeedupEffectMaxSpeedup(value),
          ),
        ),
        SliderWrapper(
          label: 'Speedup Rate',
          value: effect.speedupRate.toStringAsFixed(2),
          slider: Slider(
            value: effect.speedupRate,
            min: 0,
            max: 10,
            divisions: 100,
            onChanged: (double value) => context.read<EffectsCubit>().setSpeedupEffectSpeedupRate(value),
          ),
        ),
      ],
    );
  }
}
