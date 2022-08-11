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
  metaballs: "^1.1.2"
```
```dart
import 'package:metaballs/metaballs.dart';
```
## Usage:
```dart
Metaballs(
  color: const Color.fromARGB(255, 66, 133, 244),
  gradient: LinearGradient(
    colors: [
      const Color.fromARGB(255, 90, 60, 255),
      const Color.fromARGB(255, 120, 255, 255),
    ],
    begin: Alignment.bottomRight,
    end: Alignment.topLeft
  )
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

| property                      | default value                 | description                                                      |
|-------------------------------|-------------------------------|------------------------------------------------------------------|
| `Color? color`                | `Color(0xff4285F4)`           | The color of the metaballs                                       |
| `Gradient? gradient`          |                               | A gradient for coloring the metaballs, overwrites color          |
| `Duration? animationDuration` | `Duration(milliseconds: 200)` | The duration of the color changing animation                     |
| `double? speedMultiplier`     | `1`                           | A multiplier of the ball movement speed                          |
| `double? bounceStiffness`     | `3`                           | A multiplier to change the speed at which balls change direction |
| `double? minBallRadius`       | `15`                          | The minimum size of a ball                                       |
| `double? maxBallRadius`       | `40`                          | The maximum size of a ball                                       |
| `double? glowRadius`          | `0.7`                         | A multiplier to indicate the radius of the glow                  |
| `double? glowIntensity`       | `0.6`                         | The brightness of the glow around the ball                       |
| `Widget? child`               |                               | A widget to be placed on top of the Metaballs widget             |