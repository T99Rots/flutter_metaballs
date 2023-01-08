import 'package:metaballs/metaballs.dart';

class EffectPreset {
  EffectPreset({
    required this.effect,
    required this.name,
  });

  final MetaballsEffect effect;
  final String name;
}

final List<EffectPreset> effectPresets = <EffectPreset>[
  EffectPreset(
    effect: MetaballsEffect.follow(),
    name: 'Follow Cursor',
  ),
  EffectPreset(
    effect: MetaballsEffect.follow(),
    name: 'Grow radius',
  ),
  EffectPreset(
    effect: MetaballsEffect.follow(),
    name: 'Speedup with movement',
  ),
  EffectPreset(
    effect: MetaballsEffect.follow(),
    name: 'Interaction Ripple',
  ),
];
