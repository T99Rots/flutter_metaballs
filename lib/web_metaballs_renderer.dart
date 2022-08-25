library metaballs;
// ignore: avoid_web_libraries_in_flutter
import 'dart:html';
import 'dart:math';
import 'dart:typed_data';
import 'package:metaballs/metaballs_web_shader.frag.dart';
import 'package:metaballs/metaballs_web_shader.vert.dart';
import 'package:metaballs/webgl_types.dart';

import 'dart_ui_shim.dart' as ui;

import 'package:flutter/widgets.dart' hide Element;
import 'package:metaballs/metaballs.dart';

int counter = 0;

class BiasScaleResult {
  final double bias;
  final double scale;

  BiasScaleResult({
    required this.bias,
    required this.scale,
  });
}

class MetaballsRenderer extends StatefulWidget {
  final double time;
  final Gradient? gradient;
  final Color color;
  final List<MetaBallComputedState> metaballs;
  final double glowRadius;
  final double glowIntensity;
  final Duration animationDuration;
  final Size size;
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

class _MetaballsRendererState extends State<MetaballsRenderer> with TickerProviderStateMixin {
  late CanvasElement _canvasElement;
  late String _id;
  late WebGL2RenderingContext _gl;
  
  // basic coloring requirements
  late UniformLocation _gradientTypeHandle;
  late UniformLocation _colorsHandle;
  late UniformLocation _stopsHandle;
  late UniformLocation _gradientStopsHandle;
  late UniformLocation _tileModeHandle;
  
  // required for linear gradient
  late UniformLocation _gradientStartHandle;
  late UniformLocation _gradientEndHandle;
  
  // required for radial gradient
  late UniformLocation _radiusHandle;
  
  // required for sweeping gradient
  late UniformLocation _biasHandle;
  late UniformLocation _scaleHandle;
  
  // metaball values 
  late UniformLocation _metaballsHandle;
  late UniformLocation _metaballCountHandle;
  late UniformLocation _minimumGlowSumHandle;
  late UniformLocation _glowIntensityHandle;
  late UniformLocation _timeHandle;
  late Size _scaledSize;

  late Color targetColor;
  late Gradient? targetGradient;
  late Color startColor;
  late Gradient? startGradient;

  void _setScaledSize () {
    _scaledSize = widget.size * widget.pixelRatio;
  }

  @override
  void initState() {
    targetColor = widget.color;
    targetGradient = widget.gradient;

    _setScaledSize();

    _canvasElement = CanvasElement(
      width: _scaledSize.width.toInt(),
      height: _scaledSize.height.toInt(),
    );
    
    _gl = WebGL2RenderingContext(
      context: _canvasElement.getContext('webgl2')
    );

    _setup();
    _draw();

    _id = 'metaballs/instance:$counter';
    counter++;
    _canvasElement.width = _scaledSize.width.floor();
    _canvasElement.height = _scaledSize.height.floor();

    ui.platformViewRegistry.registerViewFactory(
      _id,
      (int viewId) => _canvasElement
    );

    super.initState();
  }

  Shader _compileShader(shaderSource, shaderType) {
    final shader = _gl.createShader(shaderType);
    _gl.shaderSource(shader, shaderSource);
    _gl.compileShader(shader);

    if(!(_gl.getShaderParameter(shader, _gl.COMPILE_STATUS)?? false)) {
      throw Exception("Shader compile failed with: ${_gl.getShaderInfoLog(shader) ?? 'Unknown error'}");
    }

    return shader;
  }

  UniformLocation _getUniformLocation(Program program, String name) {
    final location = _gl.getUniformLocation(program, name);
    if(location == null) {
      throw Exception('Can not find uniform $name.');
    }
    return location;
  }

  int _getAttribLocation(Program program, String name) {
    final location = _gl.getAttribLocation(program, name);
    if(location == -1) {
      throw Exception('Can not find attribute $name.');
    }
    return location;
  }

  void _setup() {
    final vertexShader = _compileShader(vertexShaderSource, _gl.VERTEX_SHADER);
    final fragmentShader = _compileShader(fragmentShaderSource, _gl.FRAGMENT_SHADER);

    final program = _gl.createProgram();

    _gl.attachShader(program, vertexShader);
    _gl.attachShader(program, fragmentShader);
    _gl.linkProgram(program);
    _gl.useProgram(program);

    final vertexData = Float32List.fromList([
      -1.0, 1.0, // top left
      -1.0, -1.0, // bottom left
      1.0, 1.0, // top right
      1.0, -1.0, // bottom right
    ]);

    final vertexDataBuffer = _gl.createBuffer();
    _gl.bindBuffer(_gl.ARRAY_BUFFER, vertexDataBuffer);
    _gl.bufferData(_gl.ARRAY_BUFFER, vertexData, _gl.STATIC_DRAW);

    final position = _getAttribLocation(program, 'position');
    _gl.enableVertexAttribArray(position);
    _gl.vertexAttribPointer(
      position,
      2, // position is a vec2
      _gl.FLOAT, // each component is a float
      false, // don't normalize values
      2 * 4, // two 4 byte float components per vertex
      0 // offset into each span of vertex data
    );

    // // basic coloring requirements
    _gradientTypeHandle = _getUniformLocation(program, 'gradientType');
    _colorsHandle = _getUniformLocation(program, 'colors');
    _stopsHandle = _getUniformLocation(program, 'stops');
    _gradientStopsHandle = _getUniformLocation(program, 'gradientStops');
    _tileModeHandle = _getUniformLocation(program, 'tileMode');
    
    // required for linear gradient
    _gradientStartHandle = _getUniformLocation(program, 'gradientStart');
    _gradientEndHandle = _getUniformLocation(program, 'gradientEnd');
    
    // required for radial gradient
    _radiusHandle = _getUniformLocation(program, 'radius');
    
    // required for sweeping gradient
    _biasHandle = _getUniformLocation(program, 'bias');
    _scaleHandle = _getUniformLocation(program, 'scale');
    
    // metaball values 
    _metaballsHandle = _getUniformLocation(program, 'metaballs');
    _metaballCountHandle = _getUniformLocation(program, 'metaballCount');
    _minimumGlowSumHandle = _getUniformLocation(program, 'minimumGlowSum');
    _glowIntensityHandle = _getUniformLocation(program, 'glowIntensity');
    _timeHandle = _getUniformLocation(program, 'time');
  }

  void _draw() {
    final metaballData = Float32List(3*128);
    final int metaballCount = widget.metaballs.length;

    for(int i = 0; i < metaballCount; i++) {
      final int offset = i*3;
      final metaball = widget.metaballs[i];
      metaballData[offset] = metaball.x * widget.pixelRatio;
      metaballData[offset + 1] = metaball.y * widget.pixelRatio;
      metaballData[offset + 2] = metaball.r * widget.pixelRatio;
    }

    _gl.uniform3fv(_metaballsHandle, metaballData);
    _gl.uniform1i(_metaballCountHandle, metaballCount);
    _gl.uniform1f(_minimumGlowSumHandle, min(max(1-widget.glowRadius, 0), 1));
    _gl.uniform1f(_glowIntensityHandle, min(max(widget.glowIntensity, 0), 1));
    _gl.uniform1f(_timeHandle, widget.time);

    if(widget.gradient == null) {
      _gl.uniform1i(_gradientTypeHandle, 3);
      _gl.uniform4fv(_colorsHandle, Float32List.fromList([
        widget.color.red / 255,
        widget.color.green / 255,
        widget.color.blue / 255,
        widget.color.alpha / 255
      ]));
    } else {
      final gradient = widget.gradient!;

      final colorData = Float32List(4 * 32);
      final stopsData = Float32List(32);
      final stopCount = gradient.colors.length;
      final hasStops = gradient.stops != null;

      for(int i = 0; i < stopCount; i++) {
        final color = gradient.colors[i];
        final offset = i * 4;
        colorData[offset] = color.red / 255;
        colorData[offset + 1] = color.green / 255;
        colorData[offset + 2] = color.blue / 255;
        colorData[offset + 3] = color.alpha / 255;

        if(hasStops) {
          stopsData[i] = gradient.stops![i];
        } else {
          stopsData[i] = min(i / (stopCount - 1), 1);
        }
      }

      _gl.uniform4fv(_colorsHandle, colorData);
      _gl.uniform1fv(_stopsHandle, stopsData);

      _gl.uniform1i(_gradientStopsHandle, stopCount);

      int mapTileMode(TileMode tileMode) {
        switch(tileMode) {
          case TileMode.clamp:
            return 0;
          case TileMode.repeated:
            return 1;
          case TileMode.mirror:
            return 2;
          case TileMode.decal:
            return 3;
        }
      }

      final shortestSide = min(_scaledSize.width, _scaledSize.height);

      Offset convertAlignment (AlignmentGeometry alignment) {
        final resolved = alignment.resolve(TextDirection.ltr);
        return Offset(
          (_scaledSize.width * ((resolved.x * 0.5) + 0.5)),
          (_scaledSize.height * ((-resolved.y * 0.5) + 0.5)),
        );
      }

      if(gradient is LinearGradient) {
        _gl.uniform1i(_tileModeHandle, mapTileMode(gradient.tileMode));
        _gl.uniform1i(_gradientTypeHandle, 0);
        final begin = convertAlignment(gradient.begin);
        final end = convertAlignment(gradient.end);
        _gl.uniform2f(_gradientStartHandle, begin.dx, begin.dy);
        _gl.uniform2f(_gradientEndHandle, end.dx, end.dy);
      } else if(gradient is RadialGradient) {
        _gl.uniform1i(_tileModeHandle, mapTileMode(gradient.tileMode));
        _gl.uniform1i(_gradientTypeHandle, 1);
        final center = convertAlignment(gradient.center);
        _gl.uniform2f(_gradientStartHandle, center.dx, center.dy);
        _gl.uniform1f(_radiusHandle, shortestSide * gradient.radius);
      } else if(gradient is SweepGradient) {
        _gl.uniform1i(_tileModeHandle, mapTileMode(gradient.tileMode));
        _gl.uniform1i(_gradientTypeHandle, 2);
        final center = convertAlignment(gradient.center);
        _gl.uniform2f(_gradientStartHandle, center.dx, center.dy);
        final bias = -(gradient.startAngle / 360);
        final scale = 1 / ((gradient.endAngle / 360) + bias);
        _gl.uniform1f(_biasHandle, bias);
        _gl.uniform1f(_scaleHandle, scale);
      } else {
        throw Exception('unsupported implementation of gradient');
      }
    }

    _gl.drawArrays(_gl.TRIANGLE_STRIP, 0, 4);
  }

  @override
  void didUpdateWidget(covariant MetaballsRenderer oldWidget) {
    _draw();
    _setScaledSize();
    _canvasElement.width = _scaledSize.width.floor();
    _canvasElement.height = _scaledSize.height.floor();
    super.didUpdateWidget(oldWidget);
  }

  @override
  Widget build(BuildContext context) {
    return HtmlElementView(viewType: _id);
  }
}