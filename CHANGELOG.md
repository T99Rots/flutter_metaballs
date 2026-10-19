## Unreleased (Flutter GPU branch)

* Migrate the shader build hook to `hooks` 2.x and `flutter_gpu_shaders` 0.5.2.
* Require Dart 3.10.0 and Flutter 3.38.1 in the package and example, and update the FVM pin.
* Preserve the shader bundle asset path and document the separate shader compilation and GPU renderer blockers in `doc/flutter_gpu_migration.md`.

## 1.0.0

* Initial release

## 1.0.1

* Fixed issue with metaballs going offscreen with excessive frametimes 

## 1.1.0

* Added more extensive coloring configuration options

## 1.1.1

* Fixed some outdated documentation

## 1.1.2

* Fixed some outdated documentation part 2

## 1.1.3

* Fixed an issue with a missing dispose call on a animation controller

## 1.2.0

* Added support for a custom amount of metaballs

## 1.3.0

* Added partial support for web through webgl

## 1.3.1

* Fixed gestures not being passed to widgets up the widget tree on web
* Added more dart docs
* Added live example to readme

## 1.4.0
* Implemented animated effects for the metaballs based on mouse or touch input

## 1.4.1
* Attempt at fixing broken tables in readme on pub.dev

## 1.4.2
* Yet another attempt at fixing broken tables in readme on pub.dev

## 1.5.0
* Updated for compatibility with flutter 3.7.0+
