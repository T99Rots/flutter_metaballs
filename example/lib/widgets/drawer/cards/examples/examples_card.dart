import 'package:flutter/material.dart';
import 'package:metaball_demo/widgets/better_dropdown.dart';
import 'package:metaball_demo/widgets/card_with_title.dart';

class ExamplesCard extends StatelessWidget {
  const ExamplesCard({super.key});

  @override
  Widget build(BuildContext context) {
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
        value: ExampleLayouts.none,
        onChange: (_) {},
        label: 'Select Example Layout',
      ),
    );
  }
}

enum ExampleLayouts {
  none,
  login,
}
