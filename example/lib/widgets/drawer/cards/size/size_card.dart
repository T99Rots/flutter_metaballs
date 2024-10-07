import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:metaball_demo/widgets/better_dropdown.dart';
import 'package:metaball_demo/widgets/card_with_title.dart';

import 'cubit/size_cubit.dart';
import 'views/dynamic_range_scaler_view.dart';
import 'views/dynamic_scaler_view.dart';
import 'views/static_range_scaler_view.dart';
import 'views/static_scaler_view.dart';

class SizeCard extends StatelessWidget {
  const SizeCard({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<SizeCubit, SizeState>(
      builder: (BuildContext context, SizeState state) {
        return CardWithTitle.list(
          title: 'Size',
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 15),
                child: BetterDropdown<ScalerType>(
                  label: 'Select Scaler',
                  items: const <DropdownMenuItem<ScalerType>>[
                    DropdownMenuItem<ScalerType>(
                      value: ScalerType.dynamic,
                      child: Text('Dynamic'),
                    ),
                    DropdownMenuItem<ScalerType>(
                      value: ScalerType.dynamicRange,
                      child: Text('Dynamic range'),
                    ),
                    DropdownMenuItem<ScalerType>(
                      value: ScalerType.static,
                      child: Text('Static'),
                    ),
                    DropdownMenuItem<ScalerType>(
                      value: ScalerType.staticRange,
                      child: Text('Static range'),
                    ),
                  ],
                  value: state.type,
                  onChange: (ScalerType? value) {
                    if (value == null) {
                      return;
                    }

                    context.read<SizeCubit>().setScaler(value);
                  },
                ),
              ),
              const SizedBox(height: 20),
              switch (state) {
                SizeDynamicState() => DynamicScalerView(state: state),
                SizeStaticState() => StaticScalerView(state: state),
                SizeDynamicRangeState() => DynamicRangeScalerView(state: state),
                SizeStaticRangeState() => StaticRangeScalerView(state: state),
              }
            ],
          ),
        );
      },
    );
  }
}

enum ScalerType {
  dynamic,
  static,
  dynamicRange,
  staticRange,
}
