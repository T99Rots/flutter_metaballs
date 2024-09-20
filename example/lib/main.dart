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
          glowIntensity: 0.5,
          glowThreshold: 0.5,
          size: MetaballScaler.dynamicRange(
            maxPercentage: 1.35,
            minPercentage: 0.1,
          ),
          count: 30,
        ),
      ],
    );
  }
}
