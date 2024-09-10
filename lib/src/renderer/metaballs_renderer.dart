import 'dart:ui';

import 'package:flutter/rendering.dart';
import 'package:flutter/services.dart';
import 'package:metaballs/src/controller/metaballs_scene_implementation.dart';
import 'package:metaballs/src/interfaces/metaball.dart';
import 'package:metaballs/src/pointer.dart';

import 'shader_program_provider.dart';

class MetaballsRenderer extends RenderBox implements MouseTrackerAnnotation {
  MetaballsRenderer({
    required this.gradient,
    required this.glowThreshold,
    required this.glowIntensity,
    required this.color,
    required MetaballsSceneImplementation scene,
  })  : _scene = scene,
        assert(glowThreshold >= 0 && glowThreshold <= 1),
        assert(glowIntensity >= 0 && glowIntensity <= 1);

  Color color;
  Gradient? gradient;
  double glowThreshold;
  double glowIntensity;

  MetaballsSceneImplementation _scene;
  MetaballsSceneImplementation get scene => _scene;
  set scene(MetaballsSceneImplementation newScene) {
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
  final Map<int, Pointer> _pointers = <int, Pointer>{};
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

    final Rect rect = offset & size;

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
    final List<Metaball> metaballs = _scene.metaballs;
    int index = 0;

    shader.setFloat(index++, glowThreshold);
    shader.setFloat(index++, glowIntensity);
    shader.setFloat(index++, metaballs.length.toDouble());

    for (final Metaball metaball in metaballs) {
      shader.setFloat(index++, metaball.position.dx);
      shader.setFloat(index++, metaball.position.dy);

      // Due to the algorithm used, the radius of the rendered metaball will be
      // double the radius it was given. We divide by 2 so we don't need to do
      // this on the GPU.
      shader.setFloat(index++, metaball.radius / 2);
    }
  }

  @override
  void handleEvent(PointerEvent event, covariant BoxHitTestEntry entry) {
    _pointers[event.pointer]?.handleEvent(event);
  }

  @override
  MouseCursor get cursor => MouseCursor.defer;

  @override
  PointerEnterEventListener? get onEnter => _handleOnEnter;
  void _handleOnEnter(PointerEnterEvent event) {
    final Pointer pointer = Pointer(
      position: event.localPosition,
      delta: event.localDelta,
      kind: event.kind,
      id: event.pointer,
    );
    _pointers[event.pointer] = pointer;
    _scene.handlePointer(pointer);
  }

  @override
  PointerExitEventListener? get onExit => _handleOnExit;
  void _handleOnExit(PointerExitEvent event) {
    _pointers.remove(event.pointer);
  }

  @override
  bool get validForMouseTracker => true;
}
