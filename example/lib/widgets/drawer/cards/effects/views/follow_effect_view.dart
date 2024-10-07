import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:metaball_demo/widgets/curves_dropdown.dart';
import 'package:metaball_demo/widgets/drawer/cards/effects/cubit/effects_cubit.dart';
import 'package:metaball_demo/widgets/duration_slider.dart';
import 'package:metaball_demo/widgets/slider_wrapper.dart';
import 'package:metaballs/metaballs.dart';

class FollowEffectView extends StatelessWidget {
  const FollowEffectView({
    super.key,
    required this.state,
  });

  final FollowEffectState state;

  @override
  Widget build(BuildContext context) {
    final FollowEffect effect = state.effect;

    return Column(
      children: <Widget>[
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 15),
          child: CurvesDropdown(
            curve: effect.curve,
            onChanged: (Curve value) => context.read<EffectsCubit>().setFollowEffectCurve(value),
          ),
        ),
        const SizedBox(height: 20),
        DurationSlider(
          value: effect.duration,
          onChanged: (Duration value) => context.read<EffectsCubit>().setFollowEffectDuration(value),
        ),
        SliderWrapper(
          label: 'Radius',
          value: '${effect.radius.toStringAsFixed(0)}px',
          slider: Slider(
            value: effect.radius,
            max: 100,
            onChanged: (double value) => context.read<EffectsCubit>().setFollowEffectRadius(value),
          ),
        ),
        SliderWrapper(
          label: 'Pointer smoothing',
          value: effect.pointerSmoothing.toStringAsFixed(2),
          slider: Slider(
            value: effect.pointerSmoothing,
            divisions: 100,
            onChanged: (double value) => context.read<EffectsCubit>().setFollowEffectPointerSmoothing(value),
          ),
        ),
      ],
    );
  }
}
