// ignore: avoid_web_libraries_in_flutter
import 'dart:html';
import 'dart:math';
import 'dart:typed_data';
import 'package:metaballs/metaballs_web_shader.frag.dart';
import 'package:metaballs/metaballs_web_shader.vert.dart';
import 'package:metaballs/types.dart';
import 'package:metaballs/webgl_types.dart';
import 'package:metaballs/dart_ui_shim.dart' as ui;
import 'package:flutter/widgets.dart' hide Element;

int _counter = 0;

/// The native metaballs rendering widget
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

  late Color _targetColor;
  late Gradient? _targetGradient;
  late Color _startColor;
  late Gradient? _startGradient;

  late AnimationController _animationController;

  void _setScaledSize () {
    _scaledSize = widget.size * widget.pixelRatio;
  }

  @override
  void initState() {
    _startColor = _targetColor = widget.color;
    _startGradient = _targetGradient = widget.gradient;
    _animationController = AnimationController(vsync: this, duration: widget.animationDuration);

    _setScaledSize();

    _canvasElement = CanvasElement(
      width: _scaledSize.width.toInt(),
      height: _scaledSize.height.toInt(),
    );

    _canvasElement.style.width = '100%';
    _canvasElement.style.height = '100%';

    _gl = WebGL2RenderingContext(
      context: _canvasElement.getContext('webgl2')
    );

    _setup();
    _draw();

    _id = 'metaballs/instance:$_counter';
    _canvasElement.id = _id;
    _canvasElement.style.pointerEvents = 'none';
    _counter++;
    _canvasElement.width = _scaledSize.width.floor();
    _canvasElement.height = _scaledSize.height.floor();

    ui.platformViewRegistry.registerViewFactory(
      _id,
      (int viewId) => _canvasElement
    );

    super.initState();
  }

  ColorAndGradient _getCurrentColorAndGradient() {
    Gradient? gradient;
    Color color;

    if(_animationController.isAnimating) {
      if(_targetGradient != null) {
        if(_startGradient != null) {
          if(_startGradient is LinearGradient && _targetGradient is LinearGradient) {
            gradient = (_startGradient as LinearGradient).lerpTo(_targetGradient as LinearGradient, _animationController.value);
          } else if(_startGradient is RadialGradient && _targetGradient is RadialGradient) {
            gradient = (_startGradient as RadialGradient).lerpTo(_targetGradient as RadialGradient, _animationController.value);
          } else if(_startGradient is LinearGradient && _targetGradient is LinearGradient) {
            gradient = (_startGradient as LinearGradient).lerpTo(_targetGradient as LinearGradient, _animationController.value);
          } else {
            gradient = _targetGradient;
          }
        } else {
          gradient = _targetGradient;
        }
      }
      color = Color.lerp(_startColor, _targetColor, _animationController.value)!;
    } else {
      gradient = _targetGradient;
      color = _targetColor;
    }

    return ColorAndGradient(color: color, gradient: gradient);
  }

  @override
  void didUpdateWidget(covariant MetaballsRenderer oldWidget) {
    if(oldWidget.color != widget.color || oldWidget.gradient != widget.gradient) {
      final colorAndGradient = _getCurrentColorAndGradient();
      _startColor = colorAndGradient.color;
      _startGradient = colorAndGradient.gradient;
      _targetColor = widget.color;
      _targetGradient = widget.gradient;
      _animationController.forward(from: 0);
    }
    if(oldWidget.size != widget.size) {
      _setScaledSize();
      _canvasElement.width = _scaledSize.width.floor();
      _canvasElement.height = _scaledSize.height.floor();
      _gl.viewport(0, 0, _scaledSize.width.floor(), _scaledSize.height.floor());
    }
    if(oldWidget.animationDuration != widget.animationDuration) {
      _animationController.duration = widget.animationDuration;
    }
    _draw();
    super.didUpdateWidget(oldWidget);
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
    final metaballData = Float32List(3*138);
    final int metaballCount = widget.metaballs.length;

    for(int i = 0; i < metaballCount; i++) {
      final int offset = i*3;
      final metaball = widget.metaballs[i];
      metaballData[offset] = metaball.x * widget.pixelRatio;
      metaballData[offset + 1] = (widget.size.height - metaball.y) * widget.pixelRatio;
      metaballData[offset + 2] = metaball.r * widget.pixelRatio;
    }

    _gl.uniform3fv(_metaballsHandle, metaballData);
    _gl.uniform1i(_metaballCountHandle, metaballCount);
    _gl.uniform1f(_minimumGlowSumHandle, min(max(1-widget.glowRadius, 0), 1));
    _gl.uniform1f(_glowIntensityHandle, min(max(widget.glowIntensity, 0), 1));
    _gl.uniform1f(_timeHandle, widget.time);

    final colorAndGradient = _getCurrentColorAndGradient();

    if(colorAndGradient.gradient == null) {
      _gl.uniform1i(_gradientTypeHandle, 3);
      _gl.uniform4fv(_colorsHandle, Float32List.fromList([
        colorAndGradient.color.red / 255,
        colorAndGradient.color.green / 255,
        colorAndGradient.color.blue / 255,
        colorAndGradient.color.alpha / 255
      ]));
    } else {
      final gradient = colorAndGradient.gradient!;

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
  Widget build(BuildContext context) {
    return Stack(
      children: [
        HtmlElementView(viewType: _id),
        // fix for gestures not being passed to widgets up the widget tree
        Container(color: const Color(0x00000000))
      ],
    );
  }
}