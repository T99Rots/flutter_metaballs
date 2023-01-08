import 'package:example/utils/color_presets.dart';
import 'package:example/widgets/_widget.dart';
import 'package:flutter/material.dart';
import 'package:metaballs/metaballs.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  Alignment alignment = Alignment.bottomRight;
  ColorPreset selectedPreset = colorPresets.first;
  int metaballs = 40;
  Range size = const Range(min: 25, max: 40);
  Range speed = const Range(min: 0.33, max: 1);
  ColorPreset? customPreset;
  double bounceIntensity = 10;
  double glowIntensity = 0.6;
  double glowRadius = 1;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: <Widget>[
        SizedBox(
          width: 320,
          child: ExampleDrawer(
            onPresetChange: onPresetChange,
            gradient: gradient,
            alignment: alignment,
            onAlignmentChange: onAlignmentChange,
            speed: speed,
            onSpeedChange: onSpeedChange,
            size: size,
            onSizeChange: onSizeChange,
            metaballs: metaballs,
            onMetaballsChange: onMetaballsChange,
            presets: allPresets,
            selectedPreset: selectedPreset,
            bounceIntensity: bounceIntensity,
            glowIntensity: glowIntensity,
            glowRadius: glowRadius,
            onBounceIntensityChange: onBounceIntensityChange,
            onGlowIntensityChange: onGlowIntensityChange,
            onGlowRadiusChange: onGlowRadiusChange,
          ),
        ),
        Expanded(
          child: Container(
            decoration: const BoxDecoration(
              gradient: RadialGradient(
                center: Alignment.bottomCenter,
                radius: 1.5,
                colors: <Color>[
                  Color.fromARGB(255, 13, 35, 61),
                  Colors.black,
                ],
              ),
            ),
            child: Metaballs(
              config: MetaballsConfig(
                glowRadius: glowRadius,
                glowIntensity: glowIntensity,
                radius: size,
                metaballs: metaballs,
                bounceIntensity: bounceIntensity,
                gradient: gradient,
              ),
            ),
          ),
        ),
      ],
    );
  }

  Gradient get gradient {
    return LinearGradient(
      colors: <Color>[
        selectedPreset.startColor,
        selectedPreset.endColor,
      ],
      begin: -alignment,
      end: alignment,
    );
  }

  List<ColorPreset> get allPresets {
    final List<ColorPreset> returnValue = colorPresets;
    if (customPreset != null) {
      returnValue.add(customPreset!);
    }
    return returnValue;
  }

  void onPresetChange(ColorPreset preset, bool custom) {
    selectedPreset = preset;
    if (custom) {
      customPreset = preset;
    }
    setState(() {});
  }

  void onAlignmentChange(Alignment alignment) {
    this.alignment = alignment;
    setState(() {});
  }

  void onSpeedChange(Range speed) {
    this.speed = speed;
    setState(() {});
  }

  void onSizeChange(Range size) {
    this.size = size;
    setState(() {});
  }

  void onMetaballsChange(int metaballs) {
    this.metaballs = metaballs;
    setState(() {});
  }

  void onBounceIntensityChange(double bounceIntensity) {
    this.bounceIntensity = bounceIntensity;
    setState(() {});
  }

  void onGlowIntensityChange(double glowIntensity) {
    this.glowIntensity = glowIntensity;
    setState(() {});
  }

  void onGlowRadiusChange(double glowRadius) {
    this.glowRadius = glowRadius;
    setState(() {});
  }
}
