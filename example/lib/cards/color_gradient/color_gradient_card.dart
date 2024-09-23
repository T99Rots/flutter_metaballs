import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:metaball_demo/cards/color_gradient/color_presets.dart';
import 'package:metaball_demo/cards/color_gradient/cubit/color_gradient_cubit.dart';
import 'package:metaball_demo/widgets/better_dropdown.dart';
import 'package:metaball_demo/widgets/card_with_title.dart';
import 'package:metaball_demo/widgets/gradient_direction_selector.dart';

class ColorGradientCard extends StatelessWidget {
  const ColorGradientCard({super.key});
  @override
  Widget build(BuildContext context) {
    return BlocBuilder<ColorGradientCubit, ColorGradientCubitState>(
      builder: (BuildContext context, ColorGradientCubitState state) {
        return CardWithTitle(
          title: 'Color & Gradient',
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              BetterDropdown<ColorPreset>(
                items: _getDropdownMenuItems(),
                value: state.preset,
                onChange: (ColorPreset? value) {
                  if (value == null) {
                    return;
                  }
                  context.read<ColorGradientCubit>().setPreset(value);
                },
              ),
              const SizedBox(height: 20),
              Row(
                children: <Widget>[
                  TextButton(
                    style: ButtonStyle(
                      backgroundColor: WidgetStatePropertyAll<Color>(state.preset.startColor),
                    ),
                    onPressed: () {},
                    child: const SizedBox(width: 80),
                  ),
                  const SizedBox(width: 20),
                  TextButton(
                    style: ButtonStyle(
                      backgroundColor: WidgetStatePropertyAll<Color>(
                        state.preset.endColor,
                      ),
                    ),
                    onPressed: () {},
                    child: const SizedBox(width: 80),
                  ),
                ],
              ),
              const SizedBox(height: 20),
              GradientDirectionSelector(
                alignment: state.alignment,
                gradient: LinearGradient(
                  colors: <Color>[
                    state.preset.startColor,
                    state.preset.endColor,
                  ],
                  begin: state.alignment,
                  end: -state.alignment,
                ),
                onChange: (Alignment alignment) {
                  context.read<ColorGradientCubit>().setAlignment(alignment);
                },
              ),
            ],
          ),
        );
      },
    );
  }

  List<DropdownMenuItem<ColorPreset>> _getDropdownMenuItems() {
    final List<DropdownMenuItem<ColorPreset>> items = <DropdownMenuItem<ColorPreset>>[];

    for (final ColorPreset preset in ColorPreset.presets) {
      items.add(
        DropdownMenuItem<ColorPreset>(
          value: preset,
          child: Row(
            children: <Widget>[
              Material(
                borderRadius: BorderRadius.circular(5),
                elevation: 3,
                child: Container(
                  height: 28,
                  width: 28,
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      colors: <Color>[
                        preset.startColor,
                        preset.endColor,
                      ],
                      begin: Alignment.bottomRight,
                      end: Alignment.topLeft,
                    ),
                    borderRadius: BorderRadius.circular(5),
                  ),
                ),
              ),
              const SizedBox(width: 10),
              Text(preset.name),
            ],
          ),
        ),
      );
    }

    return items;
  }
}
