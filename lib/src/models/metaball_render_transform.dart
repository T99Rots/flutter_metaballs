import 'dart:ui';

import 'metaball.dart';
import 'metaball_render_data.dart';

class MetaballRenderTransform {
  double _xTranslation = 0.0;
  double _xScale = 1.0;
  double _yTranslation = 0.0;
  double _yScale = 1.0;
  double _radiusTranslation = 0.0;
  double _radiusScale = 1.0;

  // Scale both x and y
  void scalePosition(double scaleX, double scaleY) {
    _xTranslation *= scaleX;
    _yTranslation *= scaleY;
    _xScale *= scaleX;
    _yScale *= scaleY;
  }

  // Translate both x and y
  void translatePosition(double offsetX, double offsetY) {
    _xTranslation += offsetX;
    _yTranslation += offsetY;
  }

  void scaleSize(double scale) {
    _radiusScale *= scale;
    _radiusTranslation *= scale;
  }

  void translateSize(double offset) {
    _radiusTranslation += offset;
  }

  void reset() {
    _xTranslation = 0.0;
    _xScale = 1.0;
    _yTranslation = 0.0;
    _yScale = 1.0;
    _radiusTranslation = 0.0;
    _radiusScale = 1.0;
  }

  MetaballRenderData transformMetaball(Metaball metaball) {
    return MetaballRenderData(
      position: Offset(
        (metaball.position.dx * _xScale) + _xTranslation,
        (metaball.position.dy * _yScale) + _yTranslation,
      ),
      radius: (metaball.radius * _radiusScale) + _radiusTranslation,
    );
  }

  double transformRadius(double radius) {
    return (radius * _radiusScale) + _radiusTranslation;
  }

  Offset transformPosition(Offset position) {
    return Offset(
      (position.dx * _xScale) + _xTranslation,
      (position.dy * _yScale) + _yTranslation,
    );
  }
}
