import 'dart:math';

import 'package:flutter/widgets.dart';

double reflectRadian(double theta, Axis axis) {
  switch (axis) {
    case Axis.vertical:
      return pi - theta;
    case Axis.horizontal:
      return -theta;
  }
}
