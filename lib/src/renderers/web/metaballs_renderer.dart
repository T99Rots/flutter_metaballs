import 'dart:math';
import 'dart:typed_data';
import 'dart:ui_web' as ui;

import 'package:flutter/rendering.dart';
import 'package:flutter/services.dart';
import 'package:metaballs/src/metaballs_scene.dart';
import 'package:metaballs/src/models/metaball.dart';
import 'package:metaballs/src/models/metaball_render_data.dart';
import 'package:metaballs/src/renderers/web/metaball_fragment_shader.dart';
import 'package:metaballs/src/renderers/web/shader_program_provider.dart';
import 'package:web/web.dart' hide Float32List;

class MetaballsRenderer extends RenderBox {
  MetaballsRenderer({
    required this.gradient,
    required this.glowThreshold,
    required this.glowIntensity,
    required this.color,
    required MetaballsScene scene,
  })  : _scene = scene,
        assert(glowThreshold >= 0 && glowThreshold <= 1),
        assert(glowIntensity >= 0 && glowIntensity <= 1) {
    ui.platformViewRegistry.registerViewFactory(_idString, (int viewId) {
      _id = viewId;
      _idString = 'metaballs_canvas:$_id';
      _canvas = HTMLCanvasElement();
      _context = _canvas.getContext('webgl2') as WebGL2RenderingContext;
      _canvas.id = _idString;
      _canvas.style
        ..width = '100%'
        ..height = '100%'
        ..pointerEvents = 'none';
      _createArgs = <String, dynamic>{
        'id': _id,
        'viewType': _idString,
        'params': null,
      };
      return _canvas;
    });
  }

  final Float32List _metaballsBuffer = Float32List(3 * 256);
  final Float32List _colorsBuffer = Float32List(32);
  final Float32List _stopsBuffer = Float32List(32);

  late final int _id;
  late final String _idString;
  late final HTMLCanvasElement _canvas;
  late final WebGL2RenderingContext _context;
  late final Map<String, dynamic> _createArgs;
  bool _created = false;
  MetaballFragmentShader? _shader;

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
      _scene.removeListener(_updateShader);
      newScene.addListener(_updateShader);
      if (hasSize) {
        newScene.updateViewportSize(size);
      }
    }

    _scene = newScene;
  }

  @override
  void attach(PipelineOwner owner) {
    scene.addListener(_updateShader);
    SystemChannels.platform_views.invokeMethod<void>('create', _createArgs).then((_) => _created = true);
    ShaderProgramProvider.createShaderInstance(_context).then(_handleShaderLoaded);

    super.attach(owner);
  }

  void _handleShaderLoaded(MetaballFragmentShader shader) {
    if (attached) {
      _shader = shader;
      _updateShader();
    }
  }

  void _updateShader() {
    final MetaballFragmentShader? shader = _shader;
    if (shader == null) {
      return;
    }

    final List<Metaball> metaballs = _scene.metaballs;

    int index = 0;
    for (final Metaball metaball in metaballs) {
      final MetaballRenderData renderData = metaball.transform.transformMetaball(metaball);

      _metaballsBuffer[index++] = renderData.x;
      _metaballsBuffer[index++] = renderData.y;

      // Due to the algorithm used, the radius of the rendered metaball will be
      // double the radius it was given. We divide by 2 so we don't need to do
      // this on the GPU.
      _metaballsBuffer[index++] = renderData.radius / 2;
    }

    shader.setMetaballs(_metaballsBuffer);
    shader.setMetaballCount(metaballs.length);
    shader.setGlowThreshold(glowThreshold);
    shader.setGlowIntensity(glowIntensity);
    shader.setTime(_scene.elapsed.inMilliseconds.toDouble());

    final Gradient? gradient = this.gradient;
    if (gradient == null) {
      shader.setGradientType(3);

      int index = 0;
      _colorsBuffer[index++] = color.red / 255;
      _colorsBuffer[index++] = color.green / 255;
      _colorsBuffer[index++] = color.blue / 255;
      _colorsBuffer[index++] = color.alpha / 255;

      shader.setColors(_colorsBuffer);
    } else {
      // create general gradientData
      final int stopCount = gradient.colors.length;
      final List<double>? stops = gradient.stops;

      for (int i = 0; i < stopCount; i++) {
        final int offset = i * 4;
        _colorsBuffer[offset] = color.red / 255;
        _colorsBuffer[offset + 1] = color.green / 255;
        _colorsBuffer[offset + 2] = color.blue / 255;
        _colorsBuffer[offset + 3] = color.alpha / 255;

        if (stops != null) {
          _stopsBuffer[i] = stops[i];
        } else {
          _stopsBuffer[i] = min(i / (stopCount - 1), 1);
        }
      }

      shader.setColors(_colorsBuffer);
      shader.setStops(_stopsBuffer);
      shader.setGradientStops(stopCount);

      // assign TileMode
      void setTileMode(TileMode tileMode) {
        switch (tileMode) {
          case TileMode.clamp:
            shader.setTileMode(0);
            break;
          case TileMode.decal:
            shader.setTileMode(3);
            break;
          case TileMode.mirror:
            shader.setTileMode(2);
            break;
          case TileMode.repeated:
            shader.setTileMode(1);
            break;
        }
      }

      (double, double) convertAlignment(AlignmentGeometry alignment) {
        if (alignment is! Alignment) {
          alignment = Alignment.center;
        }

        return (
          (size.width * ((alignment.x * 0.5) + 0.5)),
          (size.height * ((-alignment.y * 0.5) + 0.5)),
        );
      }

      switch (gradient) {
        case LinearGradient():
          final (double, double) alignmentStart = convertAlignment(gradient.begin);
          final (double, double) alignmentEnd = convertAlignment(gradient.end);
          shader.setGradientType(0);
          shader.setGradientStart(
            alignmentStart.$1,
            alignmentStart.$2,
          );
          shader.setGradientEnd(
            alignmentEnd.$1,
            alignmentEnd.$2,
          );
          break;
        case RadialGradient():
          final (double, double) alignment = convertAlignment(gradient.center);
          shader.setGradientType(1);
          shader.setRadius(gradient.radius * size.shortestSide);
          shader.setGradientStart(
            alignment.$1,
            alignment.$2,
          );
          break;
        case SweepGradient():
          shader.setGradientType(2);
          final (double, double) alignment = convertAlignment(gradient.center);
          final ({double tBias, double tScale}) coeff = _coeffFromAngles(
            gradient.startAngle,
            gradient.endAngle,
          );
          shader.setBias(coeff.tBias);
          shader.setScale(coeff.tScale);
          shader.setGradientStart(
            alignment.$1,
            alignment.$2,
          );
      }
    }
  }

  ({
    double tBias,
    double tScale,
  }) _coeffFromAngles(double startAngle, double endAngle) {
    final double tBias = -(startAngle / (pi * 2));
    final double tScale = 1 / ((endAngle / (pi * 2)) + tBias);
    return (
      tBias: tBias,
      tScale: tScale,
    );
  }

  @override
  void detach() {
    if (_created) {
      SystemChannels.platform_views.invokeMethod<void>('dispose', _id);
    }
    scene.removeListener(_updateShader);
    super.detach();
  }

  @override
  void performLayout() {
    size = constraints.biggest;
    _scene.updateViewportSize(size);
  }

  @override
  void paint(PaintingContext context, Offset offset) {
    context.addLayer(PlatformViewLayer(
      rect: offset & size,
      viewId: _id,
    ));
  }

  @override
  bool get sizedByParent => true;

  @override
  bool get alwaysNeedsCompositing => true;

  @override
  bool get isRepaintBoundary => true;
}
