import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:metaball_demo/widgets/theme_brightness_button/cubit/theme_brightness_cubit.dart';

class ThemeBrightnessButton extends StatelessWidget {
  const ThemeBrightnessButton({super.key});

  @override
  Widget build(BuildContext context) {
    final BrightnessCubit brightnessCubit = context.watch<BrightnessCubit>();

    return IconButton(
      icon: Icon(
        switch (brightnessCubit.state) {
          Brightness.dark => Icons.dark_mode,
          Brightness.light => Icons.light_mode,
        },
      ),
      onPressed: brightnessCubit.toggleBrightness,
    );
  }
}
