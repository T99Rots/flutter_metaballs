import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:metaball_demo/cards/color_gradient/color_presets.dart';
import 'package:metaball_demo/cards/color_gradient/cubit/color_gradient_cubit.dart';

class ColorSchemeProvider extends StatelessWidget {
  const ColorSchemeProvider({
    super.key,
    required this.child,
  });

  final Widget child;

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<ColorGradientCubit, ColorGradientCubitState>(
      builder: (BuildContext context, ColorGradientCubitState state) {
        final ThemeData theme = Theme.of(context);
        final ColorScheme colorScheme = computeColorScheme(state.preset, theme.colorScheme);
        return Theme(
          data: theme.copyWith(
            colorScheme: colorScheme,
            textSelectionTheme: theme.textSelectionTheme.copyWith(
              selectionColor: colorScheme.primary.withOpacity(0.25),
            ),
          ),
          child: child,
        );
      },
    );
  }

  /// Creates a [ColorScheme] based on the current selected preset to make the ui
  /// match the metaballs colors.
  ColorScheme computeColorScheme(ColorPreset preset, ColorScheme base) {
    final HSVColor startColor = HSVColor.fromColor(preset.startColor);
    final HSVColor endColor = HSVColor.fromColor(preset.endColor);

    final Color primary = HSVColor.fromColor(
      Color.lerp(
        preset.startColor,
        preset.endColor,
        0.5 - ((startColor.saturation - endColor.saturation) / 2),
      )!,
    ).withValue(1.0).toColor();

    final Color onPrimary = primary.computeLuminance() > 0.5 ? Colors.black : Colors.white;

    return base.copyWith(
      primary: primary,
      onPrimary: onPrimary,
    );
  }
}
