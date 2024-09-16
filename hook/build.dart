import 'package:flutter_gpu_shaders/build.dart';
import 'package:native_assets_cli/native_assets_cli.dart';

void main(List<String> args) async {
  await build(args, (BuildConfig config, BuildOutput output) async {
    await buildShaderBundleJson(
      buildConfig: config,
      buildOutput: output,
      manifestFileName: 'shaders/metaballs.shaderbundle.json',
    );
  });
}
