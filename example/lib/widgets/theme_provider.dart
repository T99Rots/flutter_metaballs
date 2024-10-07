import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:metaball_demo/widgets/drawer/cards/color_gradient/color_presets.dart';
import 'package:metaball_demo/widgets/drawer/cards/color_gradient/cubit/color_gradient_cubit.dart';
import 'package:metaball_demo/widgets/theme_brightness_button/cubit/theme_brightness_cubit.dart';

class ThemeProvider extends StatelessWidget {
  const ThemeProvider({
    super.key,
    required this.child,
  });

  final Widget child;

  @override
  Widget build(BuildContext context) {
    final ColorPreset colorPreset = context.watch<ColorGradientCubit>().state.preset;
    final Brightness brightness = context.watch<BrightnessCubit>().state;

    final HSVColor startColor = HSVColor.fromColor(colorPreset.startColor);
    final HSVColor endColor = HSVColor.fromColor(colorPreset.endColor);

    final HSVColor primaryHSV = HSVColor.fromColor(
      Color.lerp(
        colorPreset.startColor,
        colorPreset.endColor,
        0.5 - ((startColor.saturation - endColor.saturation) / 2),
      )!,
    ).withValue(1.0);

    final Color primary = primaryHSV.toColor();
    final Color onPrimary;
    final Color surface;
    final Color onSurface;
    final Color surfaceDim;
    final Color surfaceBright;
    final Color surfaceContainerLowest;
    final Color surfaceContainerLow;
    final Color surfaceContainer;
    final Color surfaceContainerHigh;
    final Color surfaceContainerHighest;

    if (primary.computeLuminance() > 0.5) {
      onPrimary = primaryHSV.withValue(0.2).toColor();
    } else {
      onPrimary = primaryHSV.withSaturation(0.12).toColor();
    }

    // if (brightness == Brightness.light) {
    //   surface = Colors.white;
    // } else {
    //   surface = primaryHSV.withValue(0.05).toColor();
    // }

    final ThemeData baseTheme = ThemeData(
      colorScheme: ColorScheme.fromSeed(
        seedColor: primary,
        primary: primary,
        brightness: brightness,
        onPrimary: onPrimary,
        // surface: surface,
      ),
    );

    final ThemeData theme = baseTheme.copyWith(
      textTheme: GoogleFonts.nunitoTextTheme(
        baseTheme.textTheme,
      ),
    );

    return AnimatedTheme(
      data: theme.copyWith(
        textSelectionTheme: theme.textSelectionTheme.copyWith(
          selectionColor: ColorScheme.fromSeed(
            seedColor: primary,
            brightness: brightness,
          ).primary.withOpacity(0.25),
        ),
      ),
      child: child,
    );
  }
}
