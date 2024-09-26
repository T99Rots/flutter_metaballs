import 'package:flutter/material.dart';
import 'package:metaball_demo/widgets/slider_wrapper.dart';

class DurationSlider extends StatelessWidget {
  const DurationSlider({
    super.key,
    required this.value,
    required this.onChanged,
  });

  final Duration value;
  final ValueChanged<Duration> onChanged;

  @override
  Widget build(BuildContext context) {
    return SliderWrapper(
      label: 'Animation Duration',
      value: '${value.inMilliseconds.toStringAsFixed(0)} ms',
      slider: Slider(
        value: value.inMilliseconds.toDouble(),
        max: 1000,
        onChanged: (double ms) => onChanged(
          Duration(
            milliseconds: ms.toInt(),
          ),
        ),
      ),
    );
  }
}
