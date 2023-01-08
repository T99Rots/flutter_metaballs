import 'dart:math';

double normalizeRadian(double theta) {
  theta = theta % (2 * pi);
  if (theta < -pi) {
    theta += 2 * pi;
  } else if (theta > pi) {
    theta -= 2 * pi;
  }
  return theta;
}
