@JS()
library metaballs;

import 'dart:html';

import 'package:js/js.dart';

@JS()
class FLutterMetaballsWebRenderer {
  external factory FLutterMetaballsWebRenderer(CanvasElement canvas);

  external void draw(
    // metaballs values
    List<Vec3> metaballs,
    double minimumGlowSum,
    double glowIntensity,
    double time,

    // general gradient values
    int gradientType,
    List<Vec4> colors,
    List<double> stops,
    int tileMode,

    // linear gradient values
    Vec2 gradientStart,
    Vec2 gradientEnd,

    // radial gradient values
    double radius,

    // sweep gradient values
    double bias,
    double scale,
  );
}

@JS()
class Vec4 {
  external factory Vec4(double x, double y, double z, double w);
  external double get x;
  external double get y;
  external double get z;
  external double get w;
}

@JS()
class Vec3 {
  external factory Vec3(double x, double y, double z);
  external double get x;
  external double get y;
  external double get z;
}

@JS()
class Vec2 {
  external factory Vec2(double x, double y);
  external double get x;
  external double get y;
}