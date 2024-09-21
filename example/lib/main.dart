import 'dart:math';
import 'dart:typed_data';
import 'dart:ui' as ui;

import 'package:flutter/material.dart';
import 'package:metaballs/metaballs.dart';

void main() {
  // enable dithering to smooth out the gradients and metaballs
  // Paint.enableDithering = true;
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Metaballs Demo',
      theme: ThemeData.dark(),
      home: const HomePage(),
      debugShowCheckedModeBanner: false,
    );
  }
}

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  int colorEffectIndex = 0;

  @override
  Widget build(BuildContext context) {
    return const Stack(
      children: [
        Positioned.fill(
          child: DecoratedBox(
            decoration: BoxDecoration(
              gradient: RadialGradient(
                center: Alignment.bottomCenter,
                radius: 1.5,
                colors: [
                  Color.fromARGB(255, 13, 35, 61),
                  Colors.black,
                ],
              ),
            ),
          ),
        ),
        Metaballs(
          gradient: LinearGradient(
            colors: [
              Color.fromARGB(255, 255, 21, 0),
              Color.fromARGB(255, 255, 153, 0),
            ],
            begin: Alignment.bottomRight,
            end: Alignment.topLeft,
          ),
          effect: RippleEffect(),
        ),
      ],
    );
  }
}

class RipplePainterWidget extends StatefulWidget {
  const RipplePainterWidget({Key? key}) : super(key: key);

  @override
  _RipplePainterWidgetState createState() => _RipplePainterWidgetState();
}

class _RipplePainterWidgetState extends State<RipplePainterWidget> {
  ui.Image? rippleImage;

  @override
  void initState() {
    super.initState();
    _generateRippleImage();
  }

  double _getWavePoint(double x, double punch) {
    if (x < 0 || x > 1) {
      return 0;
    }

    // Skew the x value based on the punchiness
    double skewedX = pow(x, punch).toDouble();

    // Apply the cosine wave to the skewed value
    return (cos(pi + (skewedX * pi * 2)) + 1) / 2;
  }

  // Function to generate the ripple image
  void _generateRippleImage() async {
    const int width = 400;
    const int height = 50;

    // Create pixel data using Uint8List (width * height * 4 for RGBA)
    Uint8List pixels = Uint8List(width * height * 4);

    for (int x = 0; x < width; x++) {
      double n = x / 60;
      double t = _getWavePoint(n, 10);

      for (int y = 0; y < height; y++) {
        int pixelIndex = (x + y * width) * 4;
        if (y > 45) {
          int color = n.floor() % 2 == 0 ? 255 : 0;

          pixels[pixelIndex] = 0; // R
          pixels[pixelIndex + 1] = color; // R
          pixels[pixelIndex + 2] = 0; // R
          pixels[pixelIndex + 3] = 255; // A (fully opaque)
        } else {
          int color = (t * 255 * 0.5).floor();
          pixels[pixelIndex] = color; // R
          pixels[pixelIndex + 1] = color; // R
          pixels[pixelIndex + 2] = color; // R
          pixels[pixelIndex + 3] = 255; // A (fully opaque)
        }
      }
    }

    // Convert the Uint8List to an image
    ui.decodeImageFromPixels(
      pixels,
      width,
      height,
      ui.PixelFormat.rgba8888,
      (ui.Image img) {
        setState(() {
          rippleImage = img; // Update the image in the widget
        });
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return rippleImage != null
        ? CustomPaint(
            size: const Size(400, 50),
            painter: ImagePainter(rippleImage!),
          )
        : const CircularProgressIndicator(); // Show a loading indicator while generating the image
  }
}

// CustomPainter to paint the generated image
class ImagePainter extends CustomPainter {
  final ui.Image image;

  ImagePainter(this.image);

  @override
  void paint(Canvas canvas, Size size) {
    canvas.drawImage(image, Offset.zero, Paint());
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) {
    return false;
  }
}
