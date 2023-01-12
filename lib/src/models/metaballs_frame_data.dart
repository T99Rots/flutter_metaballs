import 'package:flutter/widgets.dart';
import 'package:metaballs/src/effects/_effects.dart';
import 'package:metaballs/src/models/_models.dart';
import 'package:metaballs/src/widgets/_widgets.dart';

/// All data required to render a metaball for a single frame.
class MetaballFrameData {
  MetaballFrameData({
    required this.canvasSize,
    required this.frameTime,
    required this.time,
    required this.config,
    required this.speedMultiplier,
    required this.effects,
    required this.pointers,
  });

  /// The size of the canvas used to render the metaballs.
  final Size canvasSize;

  /// The time in ms since the last frame.
  final double frameTime;

  /// The time in ms since the start of the metaballs rendering.
  final double time;

  /// A multiplier which will be applied to the metaballs speed, based on the
  /// frameTime.
  final double speedMultiplier;

  /// The metaballs config.
  final MetaballsConfig config;

  /// The effect states.
  final List<MetaballsEffectState<MetaballsEffect>> effects;

  final List<Pointer> pointers;
}
