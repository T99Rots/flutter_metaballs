import 'package:flutter/material.dart';
import 'package:metaballs/metaballs.dart';

import '_utils.dart';

class CodeGenerator {
  CodeGenerator({
    required this.selectedPreset,
    required this.alignment,
    required this.speed,
    required this.size,
    required this.metaballs,
    required this.selectedEffect,
    required this.bounceIntensity,
    required this.glowIntensity,
    required this.glowRadius,
  });

  final ColorPreset selectedPreset;
  final Alignment alignment;
  final Range speed;
  final Range size;
  final int metaballs;
  final MetaballsEffect? selectedEffect;
  final double bounceIntensity;
  final double glowIntensity;
  final double glowRadius;

  String generate() {
    return '''Metaballs(
  config: MetaballsConfig(
    gradient: const LinearGradient(
      colors: <Color>[
        Color(0x${selectedPreset.startColor.value.toRadixString(16)}),
        Color(0x${selectedPreset.endColor.value.toRadixString(16)}),
      ],
      begin: ${_getAlignment(-alignment)},
      end: ${_getAlignment(alignment)},
    ),
    bounceIntensity: $bounceIntensity,
    metaballs: $metaballs,
    glowIntensity: $glowIntensity,
    glowRadius: $glowRadius,
    radius: const Range(min: ${size.min}, max: ${size.max}),
    speed: const Range(min: ${speed.min}, max: ${speed.max}),${_getEffects()}
  ),
);''';
  }

  String _getAlignment(Alignment alignment) {
    if (alignment == Alignment.topLeft) return 'Alignment.topLeft';
    if (alignment == Alignment.topCenter) return 'Alignment.topCenter';
    if (alignment == Alignment.topRight) return 'Alignment.topRight';
    if (alignment == Alignment.centerLeft) return 'Alignment.centerLeft';
    if (alignment == Alignment.centerRight) return 'Alignment.centerRight';
    if (alignment == Alignment.bottomLeft) return 'Alignment.bottomLeft';
    if (alignment == Alignment.bottomCenter) return 'Alignment.bottomCenter';
    return 'Alignment.bottomRight';
  }

  String _getEffects() {
    String? effect;

    if (selectedEffect is MetaballsFollowMouseEffect) effect = 'MetaballsEffect.follow()';
    if (selectedEffect is MetaballsMouseGrowEffect) effect = 'MetaballsEffect.grow()';
    if (selectedEffect is MetaballsSpeedupEffect) effect = 'MetaballsEffect.speedup()';
    if (selectedEffect is MetaballsTabRippleEffect) effect = 'MetaballsEffect.ripple()';

    if (effect == null) return '';

    return '''
    effects: <MetaballsEffect>[
      $effect,
    ],''';
  }
}
