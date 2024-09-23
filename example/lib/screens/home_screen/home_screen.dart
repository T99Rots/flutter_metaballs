import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:metaball_demo/cards/color_gradient/cubit/color_gradient_cubit.dart';
import 'package:metaball_demo/screens/home_screen/widgets/metaballs_drawer.dart';
import 'package:metaballs/metaballs.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Metaballs Demo'),
      ),
      body: BlocBuilder<ColorGradientCubit, ColorGradientCubitState>(
        builder: (BuildContext context, ColorGradientCubitState state) {
          return Metaballs(
            gradient: LinearGradient(
              colors: <Color>[
                state.preset.startColor,
                state.preset.endColor,
              ],
              begin: state.alignment,
              end: -state.alignment,
            ),
          );
        },
      ),
      drawer: const MetaballsDrawer(),
    );
  }
}
