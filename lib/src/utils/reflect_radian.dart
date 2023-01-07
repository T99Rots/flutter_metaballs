import 'dart:math';

import 'package:flutter/widgets.dart';
import 'package:metaballs/src/utils/_utils.dart';

double reflectRadian(double theta, Axis axis) {
  switch (axis) {
    case Axis.vertical:
      return normalizeRadian(pi - theta);
    case Axis.horizontal:
      return normalizeRadian(-theta);
  }
}
