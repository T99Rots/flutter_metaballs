import 'dart:js_interop';
import 'dart:typed_data';

import 'package:web/web.dart' hide Float32List;

class MetaballFragmentShader {
  MetaballFragmentShader({
    required WebGL2RenderingContext context,
    required WebGLProgram program,
  })  : _context = context,
        _gradientTypeHandle = _getUniformLocation(
          context,
          program,
          'gradientType',
        ),
        _colorsHandle = _getUniformLocation(
          context,
          program,
          'colors',
        ),
        _stopsHandle = _getUniformLocation(
          context,
          program,
          'stops',
        ),
        _gradientStopsHandle = _getUniformLocation(
          context,
          program,
          'gradientStops',
        ),
        _tileModeHandle = _getUniformLocation(
          context,
          program,
          'tileMode',
        ),
        _gradientStartHandle = _getUniformLocation(
          context,
          program,
          'gradientStart',
        ),
        _gradientEndHandle = _getUniformLocation(
          context,
          program,
          'gradientEnd',
        ),
        _radiusHandle = _getUniformLocation(
          context,
          program,
          'radius',
        ),
        _biasHandle = _getUniformLocation(
          context,
          program,
          'bias',
        ),
        _scaleHandle = _getUniformLocation(
          context,
          program,
          'scale',
        ),
        _metaballsHandle = _getUniformLocation(
          context,
          program,
          'metaballs',
        ),
        _metaballCountHandle = _getUniformLocation(
          context,
          program,
          'metaballCount',
        ),
        _glowThresholdHandle = _getUniformLocation(
          context,
          program,
          'glowThreshold',
        ),
        _glowIntensityHandle = _getUniformLocation(
          context,
          program,
          'glowIntensity',
        ),
        _timeHandle = _getUniformLocation(
          context,
          program,
          'time',
        );

  static WebGLUniformLocation _getUniformLocation(
    WebGL2RenderingContext context,
    WebGLProgram program,
    String name,
  ) {
    final WebGLUniformLocation? uniformLocation = context.getUniformLocation(program, name);
    if (uniformLocation == null || uniformLocation == -1) {
      throw Exception('Can not find uniform $name.');
    }

    return uniformLocation;
  }

  final WebGL2RenderingContext _context;
  final WebGLUniformLocation _gradientTypeHandle;
  final WebGLUniformLocation _colorsHandle;
  final WebGLUniformLocation _stopsHandle;
  final WebGLUniformLocation _gradientStopsHandle;
  final WebGLUniformLocation _tileModeHandle;
  final WebGLUniformLocation _gradientStartHandle;
  final WebGLUniformLocation _gradientEndHandle;
  final WebGLUniformLocation _radiusHandle;
  final WebGLUniformLocation _biasHandle;
  final WebGLUniformLocation _scaleHandle;
  final WebGLUniformLocation _metaballsHandle;
  final WebGLUniformLocation _metaballCountHandle;
  final WebGLUniformLocation _glowThresholdHandle;
  final WebGLUniformLocation _glowIntensityHandle;
  final WebGLUniformLocation _timeHandle;

  void setGradientType(int x) {
    _context.uniform1i(_gradientTypeHandle, x);
  }

  void setColors(Float32List list) {
    _context.uniform4fv(_colorsHandle, list.toJS);
  }

  void setStops(Float32List list) {
    _context.uniform1fv(_stopsHandle, list.toJS);
  }

  void setGradientStops(int x) {
    _context.uniform1i(_gradientStopsHandle, x);
  }

  void setTileMode(int x) {
    _context.uniform1i(_tileModeHandle, x);
  }

  void setGradientStart(double x, double y) {
    _context.uniform2f(_gradientStartHandle, x, y);
  }

  void setGradientEnd(double x, double y) {
    _context.uniform2f(_gradientEndHandle, x, y);
  }

  void setRadius(double x) {
    _context.uniform1f(_radiusHandle, x);
  }

  void setBias(double x) {
    _context.uniform1f(_biasHandle, x);
  }

  void setScale(double x) {
    _context.uniform1f(_scaleHandle, x);
  }

  void setMetaballs(Float32List list) {
    _context.uniform3fv(_metaballsHandle, list.toJS);
  }

  void setMetaballCount(int x) {
    _context.uniform1i(_metaballCountHandle, x);
  }

  void setGlowThreshold(double x) {
    _context.uniform1f(_glowThresholdHandle, x);
  }

  void setGlowIntensity(double x) {
    _context.uniform1f(_glowIntensityHandle, x);
  }

  void setTime(double x) {
    _context.uniform1f(_timeHandle, x);
  }
}
