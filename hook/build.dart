import 'package:flutter_gpu_shaders/build.dart';
import 'package:hooks/hooks.dart';

Future<void> main(List<String> args) async {
  await build(args, (BuildInput input, BuildOutputBuilder output) async {
    await buildShaderBundleJson(
      buildInput: input,
      buildOutput: output,
      manifestFileName: 'shaders/metaballs.shaderbundle.json',
      // Keep the asset key used by ShaderProgramProvider and pubspec.yaml.
      assetMode: ShaderBundleAssetMode.legacyOnly,
    );
  });
}
