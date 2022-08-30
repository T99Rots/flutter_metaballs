<!-- 
This README describes the package. If you publish this package to pub.dev,
this README's contents appear on the landing page for your package.

For information about how to write a good package README, see the guide for
[writing package pages](https://dart.dev/guides/libraries/writing-package-pages). 

For general information about developing packages, see the Dart guide for
[creating packages](https://dart.dev/guides/libraries/create-library-packages)
and the Flutter guide for
[developing packages and plugins](https://flutter.dev/developing-packages). 
-->

# Animated Metaballs for Flutter
[![Pub Version](https://img.shields.io/pub/v/metaballs?color=3c90ff)](https://pub.dev/packages/metaballs) [![Live Example](https://img.shields.io/badge/Github%20Pages-Live%20Example-%236200ee?logo=github)](https://t99rots.github.io/flutter_metaballs/)

<p align="center">
  <img src="https://raw.githubusercontent.com/T99Rots/readme_data/main/flutter/metaballs/metaballs.webp" width="360px">
</p>

## About
This library makes it easy to add well performing, highly configurable metaballs to your flutter project. The metaballs automatically scale to any screen size so you don't have to manually adjust the parameters for different devices. The metaballs have been implemented in shaders for the best performance across all devices. All available effects have been optimized for both mouse and touch input and should not interfere with any gesture detectors

<br>

## Installing:
```yaml
dependencies:
  metaballs: ^1.4.2
```
```dart
import 'package:metaballs/metaballs.dart';
```
<br>

## Usage:
```dart
Metaballs(
  color: const Color.fromARGB(255, 66, 133, 244),
  effect: MetaballsEffect.follow(
    growthFactor: 1,
    smoothing: 1,
    radius: 0.5,
  ),
  gradient: LinearGradient(
    colors: [
      const Color.fromARGB(255, 90, 60, 255),
      const Color.fromARGB(255, 120, 255, 255),
    ],
    begin: Alignment.bottomRight,
    end: Alignment.topLeft
  ),
  metaballs: 40,
  animationDuration: const Duration(milliseconds: 200),
  speedMultiplier: 1,
  bounceStiffness: 3,
  minBallRadius: 15,
  maxBallRadius: 40,
  glowRadius: 0.7,
  glowIntensity: 0.6,
  child: Text('METABALLS')
)
```
<br>

| Property                      | Default value                 | Accepted values | Description                                                      |
|-------------------------------|-------------------------------|-----------------|------------------------------------------------------------------|
| `Color? color`                | `Color(0xff4285F4)`           |                 | The color of the metaballs                                       |
| `MetaballsEffect? effect`     |                               |                 | The animated effect applied to the metaballs                     |
| `Gradient? gradient`          |                               |                 | A gradient for coloring the metaballs, overwrites color          |
| `int? metaballs`              | `40`                          | 1 to 128        | The amount of metaballs                                          |
| `Duration? animationDuration` | `Duration(milliseconds: 200)` |                 | The duration of the color changing animation                     |
| `double? speedMultiplier`     | `1`                           | Above 0         | A multiplier of the ball movement speed                          |
| `double? bounceStiffness`     | `3`                           | Above 0         | A multiplier to change the speed at which balls change direction |
| `double? minBallRadius`       | `15`                          | 0 or more       | The minimum size of a ball                                       |
| `double? maxBallRadius`       | `40`                          | Above min       | The maximum size of a ball                                       |
| `double? glowRadius`          | `0.7`                         | 0 to 1          | A multiplier to indicate the radius of the glow                  |
| `double? glowIntensity`       | `0.6`                         | 0 to 1          | The brightness of the glow around the ball                       |
| `Widget? child`               |                               |                 | A widget to be placed on top of the Metaballs widget             |

<br>

## Effects
<br>

### `MetaballsEffect.follow()`
This effect adds a metaball for every cursor / touch and then follows that cursor / touch around

| Property               | Default value | Accepted values | Description                                                                                |
|------------------------|---------------|-----------------|--------------------------------------------------------------------------------------------|
| `double? smoothing`    | `1`           | 0 or more       | The amount the metaballs movement gets smoothed                                            |
| `double? growthFactor` | `1`           | 0 or more       | The amount the metaballs grow relative to their movement speed                             |
| `double? radius`       |               | 0 or more       | The size of the following metaball where 0 is the minBallRadius and 1 is the maxBallRadius |

<br>
<br>

### `MetaballsEffect.speedup()`
This effect makes all metaballs speedup relative to how fast you move your mouse or swipe on your touchscreen

| Property          | Default value | Accepted values | Description                                                           |
|-------------------|---------------|-----------------|-----------------------------------------------------------------------|
| `double? speedup` | `1`           | Above 0         | The amount the metaballs speed up relative to the mouse / swipe speed |

<br>
<br>

### `MetaballsEffect.grow()`
This effect increases the radius of all metaballs based on how close they are to the mouse cursor or a touch

| Property               | Default value | Accepted values | Description                                                              |
|------------------------|---------------|-----------------|--------------------------------------------------------------------------|
| `double? radius`       | `0.5`         | Above 0         | The radius around the mouse / touch in which the metaballs get scaled up |
| `double? growthFactor` | `0.5`         | Above 0         | The amount by which the metaballs increase in size                       |
| `double? smoothing`    | `1`           | 0 or more       | The amount the movement gets smoothed                                    |

<br>
<br>

### `MetaballsEffect.ripple()`
This effect makes all metaballs increase and then decrease their radius in an outgoing ripple from a tab / mouse click

| Property               | Default value                  | Accepted values | Description                                         |
|------------------------|--------------------------------|-----------------|-----------------------------------------------------|
| `double? speed`        | `1`                            | Above 0         | The speed of the ripple effect                      |
| `double? width`        | `1`                            | Above 0         | The the ripple width                                |
| `double? growthFactor` | `1`                            | Above 0         | The amount by which the metaballs grow              |
| `Duration? fade`       | `Duration(milliseconds: 1200)` |                 | The time before the ripple is completely faded away |

<br>
<br>

## Web support
On web the gradients are currently manually implemented in webgl because `ShaderMask` is currently not supported on web. Because of that certain gradient features are currently not implemented like the `focal` and `focalRadius` options on the `RadialGradient` and the transform matrix on all gradients. Support for these options will probably be added in a later release but currently don't have high priority. If you depend on these features feel free to open a feature request or pull request on github.