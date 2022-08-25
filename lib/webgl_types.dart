import 'dart:typed_data';

class Program {
  final dynamic program;
  Program({this.program});
}

class Shader {
  final dynamic shader;
  Shader({this.shader});
}

class Buffer {
  final dynamic buffer;
  Buffer({this.buffer});
}

class UniformLocation {
  final dynamic uniformLocation;
  UniformLocation({this.uniformLocation});
}

class WebGL2RenderingContext {
  final dynamic context;
  WebGL2RenderingContext({this.context});

  // ignore: non_constant_identifier_names
  int FRAGMENT_SHADER = 0x8B30;
  // ignore: non_constant_identifier_names
  int VERTEX_SHADER = 0x8B31;
  // ignore: non_constant_identifier_names
  int ARRAY_BUFFER = 0x8892;
  // ignore: non_constant_identifier_names
  int STATIC_DRAW = 0x88E4;
  // ignore: non_constant_identifier_names
  int COMPILE_STATUS = 0x8B81;
  // ignore: non_constant_identifier_names
  int FLOAT = 0x1406;
  // ignore: non_constant_identifier_names
  int TRIANGLE_STRIP = 0x0005;

  void attachShader(Program program, Shader shader) {
    context.attachShader(program.program, shader.shader);
  }
  void linkProgram(Program program) {
    context.linkProgram(program.program);
  }
  void useProgram(Program? program) {
    context.useProgram(program?.program);
  }
  void bindBuffer(int target, Buffer? buffer) {
    context.bindBuffer(target, buffer?.buffer);
  }
  void compileShader(Shader shader) {
    context.compileShader(shader.shader);
  }
  void enableVertexAttribArray(int index) {
    context.enableVertexAttribArray(index);
  }
  void vertexAttribPointer(int indx, int size, int type, bool normalized, int stride, int offset) {
    context.vertexAttribPointer(indx, size, type, normalized, stride, offset);
  }
  void shaderSource(Shader shader, String string) {
    context.shaderSource(shader.shader, string);
  }
  void drawArrays(int mode, int first, int count) {
    context.drawArrays(mode, first, count);
  }

  void bufferData(int target, Float32List data, int usage) {
    context.bufferData(target, data, usage);
  }

  Program createProgram() {
    return Program(
      program: context.createProgram()
    );
  }

  Buffer createBuffer() {
    return Buffer(
      buffer: context.createBuffer()
    );
  }

  Shader createShader(int type) {
    return Shader(
      shader: context.createShader(type)
    );
  }

  bool? getShaderParameter(Shader shader, int pname) {
    return context.getShaderParameter(shader.shader, pname);
  }

  String? getShaderInfoLog(Shader shader) {
    return context.getShaderInfoLog(shader.shader);
  }

  UniformLocation? getUniformLocation(Program program, String name) {
    return UniformLocation(
      uniformLocation: context.getUniformLocation(program.program, name)
    );
  }

  int getAttribLocation(Program program, String name) {
    return context.getAttribLocation(program.program, name);
  }

  void viewport(int x, int y, int width, int height) {
    context.viewport(x, y, width, height);
  }

  void uniform1f(UniformLocation? location, num x) {
    context.uniform1f(location?.uniformLocation, x);
  }

  void uniform1fv(UniformLocation? location, Float32List list) {
    context.uniform1fv(location?.uniformLocation, list);
  }

  void uniform1i(UniformLocation? location, int x) {
    context.uniform1i(location?.uniformLocation, x);
  }

  void uniform1iv(UniformLocation? location, Int32List list) {
    context.uniform1iv(location?.uniformLocation, list);
  }

  void uniform2f(UniformLocation? location, num x, num y) {
    context.uniform2f(location?.uniformLocation, x, y);
  }

  void uniform2fv(UniformLocation? location, Float32List list) {
    context.uniform2fv(location?.uniformLocation, list);
  }

  void uniform2i(UniformLocation? location, int x, int y) {
    context.uniform2i(location?.uniformLocation, x, y);
  }

  void uniform2iv(UniformLocation? location, Int32List list) {
    context.uniform2iv(location?.uniformLocation,  list);
  }

  void uniform3f(UniformLocation? location, num x, num y, num z) {
    context.uniform3f(location?.uniformLocation, x, y, z);
  }

  void uniform3fv(UniformLocation? location, Float32List list) {
    context.uniform3fv(location?.uniformLocation, list);
  }

  void uniform3i(UniformLocation? location, int x, int y, int z) {
    context.uniform3i(location?.uniformLocation, x, y, z);
  }

  void uniform3iv(UniformLocation? location, Int32List list) {
    context.uniform3iv(location?.uniformLocation, list);
  }

  void uniform4f(UniformLocation? location, num x, num y, num z, num w) {
    context.uniform4f(location?.uniformLocation, x, y, z, w);
  }

  void uniform4fv(UniformLocation? location, Float32List list) {
    context.uniform4fv(location?.uniformLocation, list);
  }

  void uniform4i(UniformLocation? location, int x, int y, int z, int w) {
    context.uniform4i(location?.uniformLocation, x, y, z, w);
  }

  void uniform4iv(UniformLocation? location, Int32List list) {
    context.uniform4iv(location?.uniformLocation, list);
  }
}