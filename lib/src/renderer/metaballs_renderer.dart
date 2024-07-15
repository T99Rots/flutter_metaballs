import 'dart:ui';

import 'package:flutter/rendering.dart';
import 'package:metaballs/src/models/metaball.dart';

import 'shader_program_provider.dart';

class MetaballsRenderer extends RenderBox {
  MetaballsRenderer({
    required this.gradient,
    required this.glowThreshold,
    required this.glowIntensity,
    required this.metaballs,
    this.color = const Color(0xff0080ff),
  })  : assert(glowThreshold >= 0 && glowThreshold <= 1),
        assert(glowIntensity >= 0 && glowIntensity <= 1);

  Color color;
  Gradient? gradient;
  double glowThreshold;
  double glowIntensity;
  List<MetaBall> metaballs;

  final Paint _paint = Paint();
  FragmentShader? _shader;

  @override
  void attach(PipelineOwner owner) {
    // Start loading the asset async but don't await, as render object might be
    // scrapped before loading.
    ShaderProgramProvider.createShaderInstance().then(_handleShaderLoaded);

    super.attach(owner);
  }

  @override
  void detach() {
    super.detach();
    _shader = null;
  }

  _handleShaderLoaded(FragmentShader? shader) {
    if (attached) {
      _shader = shader;
      markNeedsPaint();
    }
  }

  @override
  void performLayout() {
    size = constraints.biggest;
  }

  @override
  void paint(PaintingContext context, Offset offset) {
    final shader = _shader;
    if (shader == null) {
      this.layer = null;
      return;
    }

    final rect = offset & size;

    // Ensure the layer is a ShaderMaskLayer.
    Layer? layer = this.layer;
    if (layer is! ShaderMaskLayer) {
      layer = this.layer = ShaderMaskLayer();
    }

    _updateShader(shader);
    layer
      ..shader = _shader
      ..maskRect = rect
      ..blendMode = BlendMode.dstATop;

    context.pushLayer(
      layer,
      _paintColor,
      offset,
    );
  }

  void _paintColor(PaintingContext context, Offset offset) {
    final rect = offset & size;
    final canvas = context.canvas;

    final gradient = this.gradient;
    if (gradient != null) {
      _paint.shader = gradient.createShader(rect);
    } else {
      _paint.shader = null;
      _paint.color = color;
    }

    canvas.drawRect(rect, _paint);
  }

  void _updateShader(FragmentShader shader) {
    int index = 0;

    shader.setFloat(index++, glowThreshold);
    shader.setFloat(index++, glowIntensity);
    shader.setFloat(index++, metaballs.length.toDouble());

    for (final metaball in metaballs) {
      shader.setFloat(index++, metaball.position.dx);
      shader.setFloat(index++, metaball.position.dy);

      // Due to the algorithm used, the radius of the rendered metaball will be
      // double the radius it was given. We divide by 2 so we don't need to do
      // this on the GPU.
      shader.setFloat(index++, metaball.radius / 2);
    }
  }
}
