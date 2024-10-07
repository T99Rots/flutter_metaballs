import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:metaball_demo/widgets/drawer/cards/size/cubit/size_cubit.dart';
import 'package:metaball_demo/widgets/slider_wrapper.dart';

class DynamicRangeScalerView extends StatelessWidget {
  const DynamicRangeScalerView({
    super.key,
    required this.state,
  });

  final SizeDynamicRangeState state;

  @override
  Widget build(BuildContext context) {
    return SliderWrapper(
      label: 'Size range',
      value: '${state.scaler.minPercentage.toStringAsFixed(2)}% - ${state.scaler.maxPercentage.toStringAsFixed(2)}%',
      slider: RangeSlider(
        values: RangeValues(
          state.scaler.minPercentage,
          state.scaler.maxPercentage,
        ),
        max: 5,
        divisions: 250,
        onChanged: (RangeValues values) => context.read<SizeCubit>().setDynamicRange(
              values.start,
              values.end,
            ),
      ),
    );
  }
}
