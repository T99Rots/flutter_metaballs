import 'package:flutter/material.dart';

class SliderWrapper extends StatelessWidget {
  const SliderWrapper({
    super.key,
    required this.label,
    required this.value,
    required this.slider,
  });

  final String label;
  final String value;
  final Widget slider;

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: <Widget>[
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 15),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: <Widget>[
              Text(label),
              Text(value),
            ],
          ),
        ),
        Padding(
          padding: const EdgeInsets.only(top: 12, left: 10, right: 10),
          child: slider,
        ),
      ],
    );
  }
}
