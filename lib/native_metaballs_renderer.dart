import 'dart:math';
import 'dart:ui';

import 'package:flutter/widgets.dart';
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
  late Future<FragmentShader> _initFuture;

  @override
  void initState() {
    _initFuture = _init();
    super.initState();
  }

  Future<FragmentShader> _init() async {
    final program = await FragmentProgram.fromAsset(
      'packages/metaballs/lib/metaballs_shader.frag',
    );

    return program.fragmentShader();
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<FragmentShader>(
        future: _initFuture,
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            final FragmentShader shader = snapshot.data!;

            shader.setFloat(0, widget.time);
            shader.setFloat(1, min(max(1 - widget.glowRadius, 0), 1));
            shader.setFloat(2, min(max(widget.glowIntensity, 0), 1));
            shader.setFloat(3, widget.metaballs.length.toDouble());

            for (int i = 0; i < widget.metaballs.length; i++) {
              final int offset = (i * 3) + 4;
              final metaball = widget.metaballs[i];
              shader.setFloat(offset, metaball.x);
              shader.setFloat(offset + 1, metaball.y);
              shader.setFloat(offset + 2, metaball.r);
            }

            return ShaderMask(
              blendMode: BlendMode.dstATop,
              shaderCallback: (bounds) {
                return shader;
              },
              child: AnimatedContainer(
                duration: widget.animationDuration,
                decoration: BoxDecoration(gradient: widget.gradient, color: widget.color),
              ),
            );
          } else {
            return Container();
          }
        });
  }
}
