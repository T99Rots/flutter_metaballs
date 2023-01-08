import 'package:example/example.dart';
import 'package:flutter/material.dart';

void main() {
  // enable dithering to smooth out the gradients and metaballs
  Paint.enableDithering = true;
  runApp(const ExampleApp());
}
