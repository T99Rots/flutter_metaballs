import 'package:flutter/material.dart';

class ColorPreset {
  ColorPreset({
    required this.name,
    required this.startColor,
    required this.endColor,
  });

  final String name;
  final Color startColor;
  final Color endColor;
}

final List<ColorPreset> colorPresets = <ColorPreset>[
  ColorPreset(
    name: 'Crimson Glow',
    startColor: const Color.fromARGB(255, 255, 21, 0),
    endColor: const Color.fromARGB(255, 255, 153, 0),
  ),
  ColorPreset(
    name: 'Neon Acid',
    startColor: const Color.fromARGB(255, 0, 255, 106),
    endColor: const Color.fromARGB(255, 255, 251, 0),
  ),
  ColorPreset(
    name: 'Enchanted Amethyst',
    startColor: const Color.fromARGB(255, 90, 60, 255),
    endColor: const Color.fromARGB(255, 120, 255, 255),
  ),
  ColorPreset(
    name: 'Fantasy Fuchsia',
    startColor: const Color.fromARGB(255, 255, 60, 120),
    endColor: const Color.fromARGB(255, 237, 120, 255),
  ),
  ColorPreset(
    name: 'Icy Tundra',
    startColor: const Color.fromARGB(255, 120, 217, 255),
    endColor: const Color.fromARGB(255, 255, 234, 214),
  ),
];
