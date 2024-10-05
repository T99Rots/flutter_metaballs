import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:metaball_demo/screens/home_screen.dart';
import 'package:metaball_demo/widgets/drawer/cards/color_gradient/cubit/color_gradient_cubit.dart';
import 'package:metaball_demo/widgets/drawer/cards/debug/cubit/debug_cubit.dart';
import 'package:metaball_demo/widgets/drawer/cards/effects/cubit/effects_cubit.dart';
import 'package:metaball_demo/widgets/drawer/cards/examples/cubit/examples_cubit.dart';
import 'package:metaball_demo/widgets/drawer/cards/general/cubit/general_cubit.dart';
import 'package:metaball_demo/widgets/drawer/cards/physics/cubit/physics_cubit.dart';
import 'package:metaball_demo/widgets/drawer/cards/size/cubit/size_cubit.dart';
import 'package:metaball_demo/widgets/theme_brightness_button/cubit/theme_brightness_cubit.dart';
import 'package:metaball_demo/widgets/theme_provider.dart';
import 'package:nested/nested.dart';

void main() {
  // enable dithering to smooth out the gradients and metaballs
  // Paint.enableDithering = true;
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({
    super.key,
  });

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Metaballs Demo',
      builder: (BuildContext context, Widget? child) {
        return MultiBlocProvider(
          providers: <SingleChildWidget>[
            BlocProvider<ColorGradientCubit>(
              create: (_) => ColorGradientCubit(),
            ),
            BlocProvider<DebugCubit>(
              create: (_) => DebugCubit(),
            ),
            BlocProvider<EffectsCubit>(
              create: (_) => EffectsCubit(),
            ),
            BlocProvider<GeneralCubit>(
              create: (_) => GeneralCubit(),
            ),
            BlocProvider<PhysicsCubit>(
              create: (_) => PhysicsCubit(),
            ),
            BlocProvider<SizeCubit>(
              create: (_) => SizeCubit(),
            ),
            BlocProvider<BrightnessCubit>(
              create: (_) => BrightnessCubit(),
            ),
            BlocProvider<EffectsCubit>(
              create: (_) => EffectsCubit(),
            ),
            BlocProvider<ExamplesCubit>(
              create: (_) => ExamplesCubit(),
            ),
          ],
          child: ThemeProvider(
            child: child!,
          ),
        );
      },
      home: const HomeScreen(),
      debugShowCheckedModeBanner: false,
    );
  }
}
