import 'dart:math';
import 'dart:typed_data';
import 'dart:ui';

import 'package:flutter/widgets.dart';
import 'package:metaballs/metaballs_shader_sprv.dart';
import 'package:metaballs/types.dart';

class MetaballsRenderer extends StatefulWidget {
  /// Value that increments over time used as a random component in dithering
  final double time;

  /// A gradient for coloring the metaballs, overwrites color
  final Gradient? gradient;

  /// The color of the metaballs
  final Color color;

  /// A list with computed metaball states passed on to the shader
  final List<MetaBallComputedState> metaballs;

  /// A multiplier to indicate the radius of the glow
  final double glowRadius;

  /// The brightness of the glow around the ball
  final double glowIntensity;

  /// The duration of the color changing animation
  final Duration animationDuration;

  /// Size of the rendering canvas
  final Size size;

  /// The device pixel ratio, only used on web to increase the resolution of
  /// the output on the canvas
  final double pixelRatio;

  const MetaballsRenderer({
    Key? key,
    required this.size,
    required this.time,
    required this.color,
    required this.metaballs,
    required this.pixelRatio,
    required this.glowRadius,
    required this.glowIntensity,
    required this.animationDuration,
    this.gradient,
  }) : super(key: key);

  @override
  State<MetaballsRenderer> createState() => _MetaballsRendererState();
}

class _MetaballsRendererState extends State<MetaballsRenderer> {
  late Future<FragmentProgram> _fragmentProgramFuture;

  @override
  void initState() {
    _fragmentProgramFuture = metaballsShaderFragmentProgram().catchError((error) {
      // ignore: avoid_print
      print('shader error: $error');
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<FragmentProgram>(
      future: _fragmentProgramFuture,
      builder: (context, snapshot) {
        if(snapshot.hasData) {
          final List<double> doubles = List.filled(4 + (138 * 3), 0.0);

          doubles[0] = widget.time;
          doubles[1] = min(max(1-widget.glowRadius, 0), 1);
          doubles[2] = min(max(widget.glowIntensity, 0), 1);
          doubles[3] = widget.metaballs.length.toDouble();

          for(int i = 0; i < widget.metaballs.length; i++) {
            final int offset = (i*3)+4;
            final metaball = widget.metaballs[i];
            doubles[offset] = metaball.x;
            doubles[offset + 1] = metaball.y;
            doubles[offset + 2] = metaball.r;
          }

          return ShaderMask(
            blendMode: BlendMode.dstATop,
            shaderCallback: (bounds) {
              return snapshot.data!.shader(
                floatUniforms: Float32List.fromList(doubles),
              );
            },
            child: AnimatedContainer(
              duration: widget.animationDuration,
              decoration: BoxDecoration(
                gradient: widget.gradient,
                color: widget.color
              ),
            ),
          );
        } else {
          return Container();
        }
      }
    );
  }
}