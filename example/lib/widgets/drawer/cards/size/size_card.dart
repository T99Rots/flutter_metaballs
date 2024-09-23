import 'package:flutter/material.dart';
import 'package:metaball_demo/widgets/card_with_title.dart';
import 'package:metaball_demo/widgets/slider_wrapper.dart';

class SizeCard extends StatelessWidget {
  const SizeCard({super.key});

  @override
  Widget build(BuildContext context) {
    return CardWithTitle.list(
      title: 'Size',
      child: Column(
        children: <Widget>[
          SliderWrapper(
            label: 'Metaball size',
            value: '40px',
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
