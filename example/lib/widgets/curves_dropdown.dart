import 'package:flutter/material.dart';
import 'package:metaball_demo/widgets/better_dropdown.dart';

class CurvesDropdown extends StatelessWidget {
  const CurvesDropdown({
    super.key,
    required this.curve,
    required this.onChanged,
  });

  final Curve curve;
  final ValueChanged<Curve> onChanged;

  @override
  Widget build(BuildContext context) {
    return BetterDropdown<Curve>(
      label: 'Select Animation Curve',
      items: const <DropdownMenuItem<Curve>>[
        DropdownMenuItem<Curve>(
          value: Curves.linear,
          child: Text('Linear'),
        ),
        DropdownMenuItem<Curve>(
          value: Curves.ease,
          child: Text('Ease'),
        ),
        DropdownMenuItem<Curve>(
          value: Curves.easeIn,
          child: Text('Ease in'),
        ),
        DropdownMenuItem<Curve>(
          value: Curves.easeOut,
          child: Text('Ease out'),
        ),
        DropdownMenuItem<Curve>(
          value: Curves.easeInOut,
          child: Text('Ease in out'),
        ),
      ],
      value: curve,
      onChange: (Curve? value) {
        if (value == null) {
          return;
        }

        onChanged(value);
      },
    );
  }
}
