import 'dart:async';
import 'dart:js_interop';
import 'dart:typed_data';

import 'package:flutter/services.dart';
import 'package:web/web.dart' hide Float32List;

import 'metaball_fragment_shader.dart';

class ShaderProgramProvider {
  static const String _fragmentShaderPath = 'packages/metaballs/assets/shaders/metaballs_web.frag';
  static const String _vertexShaderPath = 'packages/metaballs/assets/shaders/metaballs_web.vert';

  static Future<MetaballFragmentShader> createShaderInstance(WebGL2RenderingContext context) async {
    final [
      WebGLShader fragmentShader,
      WebGLShader vertexShader,
    ] = await Future.wait(<Future<WebGLShader>>[
      _compileShader(context, _fragmentShaderPath, WebGL2RenderingContext.VERTEX_SHADER),
      _compileShader(context, _vertexShaderPath, WebGL2RenderingContext.VERTEX_SHADER),
    ]);

    final WebGLProgram? program = context.createProgram();
    if (program == null) {
      throw Exception('Unable to create shader program');
    }

    context.attachShader(program, vertexShader);
    context.attachShader(program, fragmentShader);
    context.linkProgram(program);
    context.useProgram(program);

    final Float32List vertexData = Float32List.fromList(<double>[
      -1.0, 1.0, // top left
      -1.0, -1.0, // bottom left
      1.0, 1.0, // top right
      1.0, -1.0, // bottom right
    ]);
    final WebGLBuffer? vertexDataBuffer = context.createBuffer();
    context.bindBuffer(
      WebGL2RenderingContext.ARRAY_BUFFER,
      vertexDataBuffer,
    );
    context.bufferData(
      WebGL2RenderingContext.ARRAY_BUFFER,
      vertexData.toJS,
      WebGL2RenderingContext.STATIC_DRAW,
    );

    final GLint positionHandle = _getAttribLocation(
      context,
      program,
      'position',
    );

    context.enableVertexAttribArray(
      positionHandle,
    );

    context.vertexAttribPointer(
        positionHandle,
        2, // position is a vec2
        WebGL2RenderingContext.FLOAT, // each component is a float
        false, // don't normalize values
        2 * 4, // two 4 byte float components per vertex
        0 // offset into each span of vertex data
        );

    return MetaballFragmentShader(
      context: context,
      program: program,
    );
  }

  static Future<WebGLShader> _compileShader(
    WebGL2RenderingContext context,
    String shaderPath,
    int shaderType,
  ) async {
    final String source = await rootBundle.loadString(_fragmentShaderPath);

    final WebGLShader? shader = context.createShader(shaderType);
    if (shader == null) {
      throw Exception('Unable to create shader');
    }

    context.shaderSource(shader, source);
    context.compileShader(shader);

    if (!(context.getShaderParameter(shader, WebGL2RenderingContext.COMPILE_STATUS) as GLboolean)) {
      throw Exception(
        'Shader compile failed with: ${context.getShaderInfoLog(shader) ?? ''}',
      );
    }

    return shader;
  }

  static GLint _getAttribLocation(
    WebGL2RenderingContext context,
    WebGLProgram program,
    String name,
  ) {
    final GLint attributeLocation = context.getAttribLocation(program, name);
    if (attributeLocation == -1) {
      throw 'Can not find attribute ' + name + '.';
    }
    return attributeLocation;
  }
}
