import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';

class ColorPreset with EquatableMixin {
  const ColorPreset({
    required this.name,
    required this.startColor,
    required this.endColor,
  });

  static const List<ColorPreset> presets = <ColorPreset>[
    ColorPreset(
      name: 'Crimson Glow',
      startColor: Color.fromARGB(255, 255, 21, 0),
      endColor: Color.fromARGB(255, 255, 153, 0),
    ),
    ColorPreset(
      name: 'Neon Acid',
      startColor: Color.fromARGB(255, 0, 255, 106),
      endColor: Color.fromARGB(255, 255, 251, 0),
    ),
    ColorPreset(
      name: 'Enchanted Amethyst',
      startColor: Color.fromARGB(255, 90, 60, 255),
      endColor: Color.fromARGB(255, 120, 255, 255),
    ),
    ColorPreset(
      name: 'Fantasy Fuchsia',
      startColor: Color(0xFFFF3C78),
      endColor: Color.fromARGB(255, 237, 120, 255),
    ),
    ColorPreset(
      name: 'Icy Tundra',
      startColor: Color.fromARGB(255, 120, 217, 255),
      endColor: Color.fromARGB(255, 255, 234, 214),
    ),
  ];

  final String name;
  final Color startColor;
  final Color endColor;

  @override
  List<Object?> get props => <Object?>[
        name,
        startColor,
        endColor,
      ];
}
