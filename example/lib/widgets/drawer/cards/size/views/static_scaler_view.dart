import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:metaball_demo/widgets/drawer/cards/size/cubit/size_cubit.dart';
import 'package:metaball_demo/widgets/slider_wrapper.dart';

class StaticScalerView extends StatelessWidget {
  const StaticScalerView({
    super.key,
    required this.state,
  });

  final SizeStaticState state;

  @override
  Widget build(BuildContext context) {
    return SliderWrapper(
      label: 'Size',
      value: '${state.scaler.size.toStringAsFixed(0)}px',
      slider: Slider(
        value: state.scaler.size,
        max: 100,
        divisions: 100,
        onChanged: (double value) => context.read<SizeCubit>().setStatic(value),
      ),
    );
  }
}
