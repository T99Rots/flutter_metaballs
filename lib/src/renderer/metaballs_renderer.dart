import 'dart:ui';

import 'package:flutter/rendering.dart';
import 'package:metaballs/src/metaballs_scene.dart';
import 'package:metaballs/src/models/visual_metaball.dart';

import 'shader_program_provider.dart';

class MetaballsRenderer extends RenderBox {
  MetaballsRenderer({
    required this.gradient,
    required this.glowThreshold,
    required this.glowIntensity,
    required this.color,
    required MetaballsScene scene,
  })  : _scene = scene,
        assert(glowThreshold >= 0 && glowThreshold <= 1),
        assert(glowIntensity >= 0 && glowIntensity <= 1);

  Color color;
  Gradient? gradient;
  double glowThreshold;
  double glowIntensity;

  MetaballsScene _scene;
  MetaballsScene get scene => _scene;
  set scene(MetaballsScene newScene) {
    if (newScene == _scene) {
      return;
    }

    if (attached) {
      _scene.removeListener(markNeedsPaint);
      newScene.addListener(markNeedsPaint);
    }

    _scene = newScene;
  }

  final Paint _paint = Paint();
  FragmentShader? _shader;

  @override
  void attach(PipelineOwner owner) {
    // Start loading the asset async but don't await, as render object might be
    // scrapped before loading.
    ShaderProgramProvider.createShaderInstance().then(_handleShaderLoaded);
    scene.addListener(markNeedsPaint);

    super.attach(owner);
  }

  @override
  void detach() {
    super.detach();
    scene.removeListener(markNeedsPaint);
    _shader = null;
  }

  void _handleShaderLoaded(FragmentShader? shader) {
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
    final FragmentShader? shader = _shader;
    if (shader == null) {
      this.layer = null;
      return;
    }

    // Ensure the layer is a ShaderMaskLayer.
    Layer? layer = this.layer;
    if (layer is! ShaderMaskLayer) {
      layer = this.layer = ShaderMaskLayer();
    }

    _updateShader(shader);
    layer
      ..shader = _shader
      ..maskRect = offset & size
      ..blendMode = BlendMode.dstATop;

    context.pushLayer(
      layer,
      _paintColor,
      offset,
    );
  }

  void _paintColor(PaintingContext context, Offset offset) {
    final Rect rect = offset & size;
    final Canvas canvas = context.canvas;

    final Gradient? gradient = this.gradient;
    if (gradient != null) {
      _paint.shader = gradient.createShader(rect);
    } else {
      _paint.shader = null;
      _paint.color = color;
    }

    canvas.drawRect(rect, _paint);
  }

  void _updateShader(FragmentShader shader) {
    final List<VisualMetaball> metaballs = _scene.metaballs;
    int index = 0;

    shader.setFloat(index++, 0.2);
    shader.setFloat(index++, 0.5);
    shader.setFloat(index++, metaballs.length.toDouble());

    for (final VisualMetaball metaball in metaballs) {
      shader.setFloat(index++, metaball.visualPosition.dx * size.width);
      shader.setFloat(index++, metaball.visualPosition.dy * size.height);

      // Due to the algorithm used, the radius of the rendered metaball will be
      // double the radius it was given. We divide by 2 so we don't need to do
      // this on the GPU.
      shader.setFloat(index++, ((metaball.visualRadius * 40) + 30) / 2);
      index++;
    }
  }
}
