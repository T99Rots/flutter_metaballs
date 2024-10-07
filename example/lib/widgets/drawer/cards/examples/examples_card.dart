import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:metaball_demo/widgets/better_dropdown.dart';
import 'package:metaball_demo/widgets/card_with_title.dart';
import 'package:metaball_demo/widgets/drawer/cards/examples/cubit/examples_cubit.dart';

class ExamplesCard extends StatelessWidget {
  const ExamplesCard({super.key});

  @override
  Widget build(BuildContext context) {
    final ExamplesCubit cubit = context.watch<ExamplesCubit>();
    final ExampleLayouts state = cubit.state;

    return CardWithTitle(
      title: 'Example Layouts',
      child: BetterDropdown<ExampleLayouts>(
        items: const <DropdownMenuItem<ExampleLayouts>>[
          DropdownMenuItem<ExampleLayouts>(
            value: ExampleLayouts.none,
            child: Text('None'),
          ),
          DropdownMenuItem<ExampleLayouts>(
            value: ExampleLayouts.login,
            child: Text('Login'),
          ),
        ],
        value: state,
        onChange: (ExampleLayouts? value) {
          if (value == null) {
            return;
          }

          cubit.setExample(value);
        },
        label: 'Select Example Layout',
      ),
    );
  }
}

enum ExampleLayouts {
  none,
  login,
}
