import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:metaball_demo/widgets/curves_dropdown.dart';
import 'package:metaball_demo/widgets/drawer/cards/effects/cubit/effects_cubit.dart';
import 'package:metaball_demo/widgets/duration_slider.dart';
import 'package:metaball_demo/widgets/slider_wrapper.dart';
import 'package:metaballs/src/effects/grow_effect.dart';

class GrowEffectView extends StatelessWidget {
  const GrowEffectView({
    super.key,
    required this.state,
  });

  final GrowEffectState state;

  @override
  Widget build(BuildContext context) {
    final GrowEffect effect = state.effect;

    return Column(
      children: <Widget>[
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 15),
          child: CurvesDropdown(
            curve: effect.curve,
            onChanged: (Curve value) => context.read<EffectsCubit>().setGrowEffectCurve(value),
          ),
        ),
        const SizedBox(height: 20),
        DurationSlider(
          value: effect.duration,
          onChanged: (Duration value) => context.read<EffectsCubit>().setGrowEffectDuration(value),
        ),
        SliderWrapper(
          label: 'Multiplier',
          value: effect.multiplier.toStringAsFixed(2),
          slider: Slider(
            value: effect.multiplier,
            divisions: 100,
            onChanged: (double value) => context.read<EffectsCubit>().setGrowEffectMultiplier(value),
          ),
        ),
        SliderWrapper(
          label: 'Radius',
          value: '${effect.radius.toStringAsFixed(0)}px',
          slider: Slider(
            value: effect.radius,
            max: 100,
            onChanged: (double value) => context.read<EffectsCubit>().setGrowEffectRadius(value),
          ),
        ),
        SliderWrapper(
          label: 'Movement smoothing',
          value: effect.pointerSmoothing.toStringAsFixed(2),
          slider: Slider(
            value: effect.pointerSmoothing,
            divisions: 100,
            onChanged: (double value) => context.read<EffectsCubit>().setGrowEffectMovementSmoothing(value),
          ),
        ),
      ],
    );
  }
}
