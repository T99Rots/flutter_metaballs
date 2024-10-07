import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:metaball_demo/widgets/drawer/cards/size/cubit/size_cubit.dart';
import 'package:metaball_demo/widgets/slider_wrapper.dart';

class DynamicScalerView extends StatelessWidget {
  const DynamicScalerView({
    super.key,
    required this.state,
  });

  final SizeDynamicState state;

  @override
  Widget build(BuildContext context) {
    return SliderWrapper(
      label: 'Size',
      value: '${state.scaler.percentage.toStringAsFixed(2)}%',
      slider: Slider(
        value: state.scaler.percentage,
        max: 5,
        divisions: 250,
        onChanged: (double value) => context.read<SizeCubit>().setDynamic(value),
      ),
    );
  }
}
