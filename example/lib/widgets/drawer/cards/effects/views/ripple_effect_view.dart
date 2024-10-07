import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:metaball_demo/widgets/drawer/cards/effects/cubit/effects_cubit.dart';
import 'package:metaball_demo/widgets/slider_wrapper.dart';
import 'package:metaballs/src/effects/ripple_effect.dart';

class RippleEffectView extends StatelessWidget {
  const RippleEffectView({
    super.key,
    required this.state,
  });

  final RippleEffectState state;

  @override
  Widget build(BuildContext context) {
    final RippleEffect effect = state.effect;

    return Column(
      children: <Widget>[
        SliderWrapper(
          label: 'Speed',
          value: effect.speed.toStringAsFixed(2),
          slider: Slider(
            value: effect.speed,
            min: 0,
            max: 5,
            divisions: 100,
            onChanged: (double value) => context.read<EffectsCubit>().setRippleEffectSpeed(value),
          ),
        ),
        SliderWrapper(
          label: 'Width',
          value: effect.width.toStringAsFixed(2),
          slider: Slider(
            value: effect.width,
            min: 0,
            max: 2,
            divisions: 100,
            onChanged: (double value) => context.read<EffectsCubit>().setRippleEffectWidth(value),
          ),
        ),
        SliderWrapper(
          label: 'Radius Multiplier',
          value: effect.radiusMultiplier.toStringAsFixed(2),
          slider: Slider(
            value: effect.radiusMultiplier,
            min: 0,
            max: 2,
            divisions: 100,
            onChanged: (double value) => context.read<EffectsCubit>().setRippleEffectRadiusMultiplier(value),
          ),
        ),
        SliderWrapper(
          label: 'Distance Multiplier',
          value: effect.distanceMultiplier.toStringAsFixed(2),
          slider: Slider(
            value: effect.distanceMultiplier,
            min: 0,
            max: 2,
            divisions: 100,
            onChanged: (double value) => context.read<EffectsCubit>().setRippleEffectDistanceMultiplier(value),
          ),
        ),
        SliderWrapper(
          label: 'Punch',
          value: effect.punch.toStringAsFixed(1),
          slider: Slider(
            value: effect.punch,
            min: 0,
            max: 10,
            divisions: 100,
            onChanged: (double value) => context.read<EffectsCubit>().setRippleEffectPunch(value),
          ),
        ),
      ],
    );
  }
}
