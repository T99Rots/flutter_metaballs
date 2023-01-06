import 'dart:math';
import 'dart:ui';

import 'package:flutter/widgets.dart';
import 'package:metaballs/src/models/_models.dart';

class MetaballsRenderer extends StatefulWidget {
  const MetaballsRenderer({
    super.key,
    required this.size,
    required this.time,
    required this.pixelRatio,
    required this.config,
    required this.metaballsData,
  });

  /// The configuration used to color and style the metaballs.
  final MetaballsConfig config;

  /// Value that increments over time used as a random component in dithering
  final double time;

  /// A list with computed metaball states passed on to the shader
  final List<MetaballShaderData> metaballsData;

  /// Size of the rendering canvas
  final Size size;

  /// The device pixel ratio, only used on web to increase the resolution of
  /// the output on the canvas
  final double pixelRatio;

  @override
  State<MetaballsRenderer> createState() => _MetaballsRendererState();
}

class _MetaballsRendererState extends State<MetaballsRenderer> {
  late Future<FragmentShader> _shaderFuture;

  @override
  void initState() {
    _shaderFuture = _getShader();
    super.initState();
  }

  Future<FragmentShader> _getShader() async {
    final FragmentProgram fragmentProgram = await FragmentProgram.fromAsset('shaders/flutter/metaballs.frag');
    return fragmentProgram.fragmentShader();
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<FragmentShader>(
      future: _shaderFuture,
      builder: (BuildContext context, AsyncSnapshot<FragmentShader> snapshot) {
        if (snapshot.hasData) {
          final FragmentShader shader = snapshot.data!;

          shader.setFloat(0, widget.time);
          shader.setFloat(1, min(max(1 - widget.config.glowRadius, 0), 1));
          shader.setFloat(2, min(max(widget.config.glowIntensity, 0), 1));
          shader.setFloat(3, widget.metaballsData.length.toDouble());

          for (int i = 0; i < widget.metaballsData.length; i++) {
            final int offset = (i * 3) + 4;
            final MetaballShaderData metaball = widget.metaballsData[i];
            shader.setFloat(offset, metaball.x);
            shader.setFloat(offset + 1, metaball.y);
            shader.setFloat(offset + 2, metaball.radius);
          }

          return ShaderMask(
            blendMode: BlendMode.dstATop,
            shaderCallback: (Rect bounds) {
              return shader;
            },
            child: AnimatedContainer(
              duration: widget.config.animationDuration,
              decoration: BoxDecoration(
                gradient: widget.config.gradient,
                color: widget.config.color,
              ),
            ),
          );
        } else {
          return Container();
        }
      },
    );
  }
}
