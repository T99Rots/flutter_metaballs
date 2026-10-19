# Flutter GPU build-hook migration

This change updates the build-hook integration in draft PR #12. It does not
complete the Flutter GPU renderer or the 2.0 release, and it does not implement
the web compatibility fix tracked separately in issue #13.

## Dependencies and SDK

- `flutter_gpu_shaders: ^0.5.2` and `hooks: ^2.0.0` replace the old shader helper
  and `native_assets_cli` dependency. Both remain regular dependencies because
  the hook must run when another application depends on `metaballs`.
- The package and example require Dart `>=3.10.0 <4.0.0` and Flutter `>=3.38.1`.
  FVM pins Flutter 3.38.1. Flutter 3.38.0 shipped a prerelease Dart SDK that does
  not satisfy the stable Dart 3.10.0 constraint; see
  [Flutter issue #178400](https://github.com/flutter/flutter/issues/178400).
- The old example lockfile was removed because it still resolved the obsolete
  dependencies. Regenerate and commit `example/pubspec.lock` with
  `flutter pub get` in `example/` once a working toolchain is available. A new
  lockfile was not fabricated without a successful dependency resolution.

## Shader bundle contract

`hook/build.dart` uses `package:hooks/hooks.dart`, `BuildInput`, and
`BuildOutputBuilder`, passing `buildInput` to `buildShaderBundleJson`.
`ShaderBundleAssetMode.legacyOnly` explicitly retains the file-based asset
contract documented by
[`flutter_gpu_shaders` 0.5.2](https://pub.dev/packages/flutter_gpu_shaders/versions/0.5.2).

| Stage | Path or name |
| --- | --- |
| Build hook | `hook/build.dart` |
| Manifest | `shaders/metaballs.shaderbundle.json` |
| Vertex entry | `MetaballsVertex` / `shaders/metaballs_gpu.vert` |
| Fragment entry | `MetaballsFragment` / `shaders/metaballs_gpu.frag` |
| Generated bundle and `flutter.assets` entry | `build/shaderbundles/metaballs.shaderbundle` |
| Existing `ShaderLibrary.fromAsset` key | `packages/metaballs/build/shaderbundles/metaballs.shaderbundle` |

The explicit asset entry avoids packaging compiler metadata alongside the
bundle. Shader sources, entry names, and the runtime loader are unchanged.
The helper still declares shader build dependencies and generates the bundle
when compilation succeeds. This migration does not opt in to DataAssets or
change the runtime asset key.

## Validation on 2026-10-19

The published shader-helper archive and `hooks` 2.0.0 API were inspected, and
the manifest, generated filename, asset declaration, and loader key were
checked for consistency.

| Check | Result |
| --- | --- |
| Dependency resolution and Dart analysis | Blocked: the Dart VM aborts during Flutter tool startup on this host with `Failed to retrieve stack bounds`. No successful `pub get` or analysis result is claimed. |
| Shader compilation | Failed on the existing GLSL sources using the standalone Flutter 3.38.1 `impellerc`, with the shader helper's bundle arguments. No bundle was generated. |
| Example build and application launch | Not validated: Flutter tool startup is blocked, and the shader errors below also need fixing. |
| GPU bundle loading on a device | Not validated; the unchanged loader key matches the declared asset path, but runtime loading needs a successfully compiled bundle and a supported device. |

The compiler rejects `attribute` in `metaballs_gpu.vert` because it is no longer
supported in the core profile. Compiling the fragment entry independently also
reports non-opaque uniforms outside a block and an undefined
`FlutterFragCoord()` in `metaballs_gpu.frag`. These failures predate the hook
migration; they require a separate GPU shader port, including uniform layout
and coordinate handling.

## Remaining renderer work

- `lib/src/renderers/metaballs_render_widget.dart` still imports the native
  renderer. Running the existing example would exercise that renderer, not the
  unfinished GPU renderer.
- `lib/src/renderers/flutter_gpu/metaballs_renderer.dart` calls `setFloat` on
  `ShaderLibrary` and assigns that library to `ShaderMaskLayer.shader`.
  `ShaderLibrary` exposes named GPU shaders, not the fragment-shader uniform
  API, and is not a `dart:ui.Shader`. The GPU renderer needs an actual render
  pipeline, uniform buffers, render pass, and presentation path.
- The example's widget test is still the generated counter test, although the
  application no longer contains a counter. It is not a GPU smoke test.
- Debug, profile, and release rendering, supported devices/backends, and web
  behavior remain unverified. A successful native-renderer example run alone
  would not establish Flutter GPU support.

## Follow-up validation with a working toolchain

Use Flutter 3.38.1 or later with stable Dart 3.10.0 or later. Resolve dependencies
at the package root and in `example/`, retain the regenerated example lockfile,
then run `flutter analyze` to capture the outstanding GPU API errors.

After the GPU shaders are ported, run `flutter build bundle` in `example/` to
exercise the build hook, then verify that
`build/flutter_assets/packages/metaballs/build/shaderbundles/metaballs.shaderbundle`
exists in the example build. Run the example on an Impeller-capable device and
record the Flutter/Dart versions, device/backend, and build mode. Once the GPU
renderer is wired in, verify both named shader lookups, uniform values, output
coordinates, and debug/profile/release rendering before declaring the GPU
migration complete.
