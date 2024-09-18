import 'package:flutter_gpu/gpu.dart';

class ShaderProgramProvider {
  const ShaderProgramProvider._();

  static const String _path = 'packages/metaballs/build/shaderbundles/metaballs.shaderbundle';
  static ShaderLibrary? _instance;

  static ShaderLibrary createShaderInstance() {
    return _instance ??= ShaderLibrary.fromAsset(_path)!;
  }
}
