import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:metaball_demo/widgets/drawer/cards/size/cubit/size_cubit.dart';
import 'package:metaball_demo/widgets/slider_wrapper.dart';

class StaticRangeScalerView extends StatelessWidget {
  const StaticRangeScalerView({
    super.key,
    required this.state,
  });

  final SizeStaticRangeState state;

  @override
  Widget build(BuildContext context) {
    return SliderWrapper(
      label: 'Size range',
      value: '${state.scaler.min.toStringAsFixed(0)}px - ${state.scaler.max.toStringAsFixed(0)}px',
      slider: RangeSlider(
        values: RangeValues(
          state.scaler.min,
          state.scaler.max,
        ),
        max: 100,
        divisions: 100,
        onChanged: (RangeValues values) => context.read<SizeCubit>().setStaticRange(
              values.start,
              values.end,
            ),
      ),
    );
  }
}
