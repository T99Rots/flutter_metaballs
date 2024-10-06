import 'dart:ui';

class Transform2D {
  double _xTranslation = 0.0;
  double _xScale = 1.0;
  double _yTranslation = 0.0;
  double _yScale = 1.0;

  // Scale both x and y
  void scale(double x, double y) {
    _xTranslation *= x;
    _yTranslation *= y;
    _xScale *= x;
    _yScale *= y;
  }

  // Translate both x and y
  void translate(double x, double y) {
    _xTranslation += x;
    _yTranslation += y;
  }

  void reset() {
    _xTranslation = 0.0;
    _xScale = 1.0;
    _yTranslation = 0.0;
    _yScale = 1.0;
  }

  Offset apply(Offset position) {
    return Offset(
      (position.dx * _xScale) + _xTranslation,
      (position.dy * _yScale) + _yTranslation,
    );
  }
}

class Transform1D {
  double _translation = 0.0;
  double _scale = 1.0;

  void scale(double scale) {
    _translation *= scale;
    _scale *= scale;
  }

  void translate(double translation) {
    _translation += translation;
  }

  void reset() {
    _translation = 0.0;
    _scale = 1.0;
  }

  double apply(double value) {
    return (value * _scale) + _translation;
  }
}
