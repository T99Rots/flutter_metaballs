import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:metaball_demo/screens/login_example.dart';
import 'package:metaball_demo/widgets/drawer/cards/examples/cubit/examples_cubit.dart';
import 'package:metaball_demo/widgets/drawer/cards/examples/examples_card.dart';

class ExampleLayoutBuilder extends StatelessWidget {
  const ExampleLayoutBuilder({super.key});

  @override
  Widget build(BuildContext context) {
    final ExampleLayouts state = context.watch<ExamplesCubit>().state;

    return switch (state) {
      ExampleLayouts.none => const SizedBox(),
      ExampleLayouts.login => const LoginExample(),
    };
  }
}
