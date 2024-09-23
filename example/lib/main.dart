import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:metaball_demo/cards/color_gradient/cubit/color_gradient_cubit.dart';
import 'package:metaball_demo/screens/home_screen/home_screen.dart';
import 'package:metaball_demo/widgets/color_scheme_provider.dart';
import 'package:nested/nested.dart';

void main() {
  // enable dithering to smooth out the gradients and metaballs
  // Paint.enableDithering = true;
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Metaballs Demo',
      theme: ThemeData.dark(
        useMaterial3: true,
      ),
      home: MultiBlocProvider(
        providers: <SingleChildWidget>[
          BlocProvider<ColorGradientCubit>(
            create: (_) => ColorGradientCubit(),
          ),
        ],
        child: const ColorSchemeProvider(
          child: HomeScreen(),
        ),
      ),
      debugShowCheckedModeBanner: false,
    );
  }
}
