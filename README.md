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

<p align="center">
  <img src="https://raw.githubusercontent.com/T99Rots/readme_data/main/flutter/metaballs/metaballs.webp" width="360px">
</p>

## Installing:
```yaml
dependencies:
  metaballs: "^0.0.1"
```
```dart
import 'package:metaballs/metaballs.dart';
```
## Usage:
```dart
Metaballs(
  color1: const Color(0xffff54c2),
  color2: const Color(0xffffc242),
  colorAnimationDuration: const Duration(milliseconds: 200),
  speedMultiplier: 1,
  minBallRadius: 15,
  maxBallRadius: 40,
  glowRadius: 0.7,
  glowIntensity: 0.6,
  gradientAlignment: Alignment.bottomRight,
  child: Text('META BALLS')
)
```