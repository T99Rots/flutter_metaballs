import 'package:flutter/material.dart';
import 'package:metaball_demo/widgets/card_with_title.dart';
import 'package:metaball_demo/widgets/slider_wrapper.dart';

class GeneralCard extends StatelessWidget {
  const GeneralCard({super.key});

  @override
  Widget build(BuildContext context) {
    return CardWithTitle.list(
      title: 'General',
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: <Widget>[
          SliderWrapper(
            label: 'Metaballs count',
            value: '40',
            slider: Slider(
              value: 0.5,
              onChanged: (_) {},
            ),
          ),
          SliderWrapper(
            label: 'Glow threshold',
            value: '40',
            slider: Slider(
              value: 0.5,
              onChanged: (_) {},
            ),
          ),
          SliderWrapper(
            label: 'Glow intensity',
            value: '40',
            slider: Slider(
              value: 0.5,
              onChanged: (_) {},
            ),
          ),
        ],
      ),
    );
  }
}
