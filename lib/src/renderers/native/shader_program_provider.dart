import 'dart:ui';

/// Provides the metaballs shader from cache.
class ShaderProgramProvider {
  const ShaderProgramProvider._();

  static const String _path = 'packages/metaballs/assets/shaders/metaballs.frag';
  static Future<FragmentProgram>? _programFuture;

  static Future<FragmentShader> createShaderInstance() async {
    final Future<FragmentProgram> programFuture = _programFuture ??= FragmentProgram.fromAsset(_path);
    final FragmentProgram program = await programFuture;

    return program.fragmentShader();
  }
}
