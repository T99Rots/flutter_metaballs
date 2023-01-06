import 'package:flutter/material.dart';
import 'package:metaballs/metaballs.dart';

class ColorsEffectPair {
  final List<Color> colors;
  final MetaballsEffect? effect;
  final String name;

  ColorsEffectPair({
    required this.colors,
    required this.name,
    required this.effect,
  });
}

List<ColorsEffectPair> colorsAndEffects = [
  ColorsEffectPair(
    colors: [
      const Color.fromARGB(255, 255, 21, 0),
      const Color.fromARGB(255, 255, 153, 0),
    ],
    effect: MetaballsEffect.follow(),
    name: 'FOLLOW',
  ),
  ColorsEffectPair(
    colors: [
      const Color.fromARGB(255, 0, 255, 106),
      const Color.fromARGB(255, 255, 251, 0),
    ],
    effect: MetaballsEffect.grow(),
    name: 'GROW',
  ),
  ColorsEffectPair(
    colors: [
      const Color.fromARGB(255, 90, 60, 255),
      const Color.fromARGB(255, 120, 255, 255),
    ],
    effect: MetaballsEffect.speedup(),
    name: 'SPEEDUP',
  ),
  ColorsEffectPair(
    colors: [
      const Color.fromARGB(255, 255, 60, 120),
      const Color.fromARGB(255, 237, 120, 255),
    ],
    effect: MetaballsEffect.ripple(),
    name: 'RIPPLE',
  ),
  ColorsEffectPair(
    colors: [
      const Color.fromARGB(255, 120, 217, 255),
      const Color.fromARGB(255, 255, 234, 214),
    ],
    effect: null,
    name: 'NONE',
  ),
];

void main() {
  // enable dithering to smooth out the gradients and metaballs
  Paint.enableDithering = true;
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
    double width = MediaQuery.of(context).size.width;

    return Material(
      child: GestureDetector(
        onDoubleTap: () {
          setState(() {
            colorEffectIndex = (colorEffectIndex + 1) % colorsAndEffects.length;
          });
        },
        child: Container(
          decoration: const BoxDecoration(
            gradient: RadialGradient(
              center: Alignment.bottomCenter,
              radius: 1.5,
              colors: [
                Color.fromARGB(255, 13, 35, 61),
                Colors.black,
              ],
            ),
          ),
          child: Metaballs(
            config: MetaballsConfig(
              effects: colorsAndEffects[colorEffectIndex].effect == null
                  ? null
                  : [colorsAndEffects[colorEffectIndex].effect!],
              glowRadius: 1,
              glowIntensity: 0.6,
              radius: const Range(min: 20, max: 50),
              metaballs: 40,
              color: Colors.grey,
              gradient: LinearGradient(
                colors: colorsAndEffects[colorEffectIndex].colors,
                begin: Alignment.bottomRight,
                end: Alignment.topLeft,
              ),
            ),
            child: Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Text(
                    'METABALLS',
                    style: TextStyle(
                      shadows: [Shadow(color: Colors.black.withOpacity(0.6), blurRadius: 80)],
                      fontSize: 50 * width / 400,
                      fontWeight: FontWeight.w900,
                    ),
                  ),
                  Text(
                    'DOUBLE TAP TO CHANGE EFFECT AND COLOR\nCURRENT EFFECT: ${colorsAndEffects[colorEffectIndex].name}',
                    style: TextStyle(
                      shadows: [Shadow(color: Colors.black.withOpacity(0.6), blurRadius: 80)],
                      fontSize: 16 * width / 400,
                      fontWeight: FontWeight.w900,
                    ),
                    textAlign: TextAlign.center,
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
