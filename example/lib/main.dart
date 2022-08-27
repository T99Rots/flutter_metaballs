import 'package:flutter/material.dart';
import 'package:metaballs/metaballs.dart';

List<List<Color>> colorStops = [
  [
    const Color.fromARGB(255, 255, 21, 0),
    const Color.fromARGB(255, 255, 153, 0),
  ],
  [
    const Color.fromARGB(255, 0, 255, 106),
    const Color.fromARGB(255, 255, 251, 0),
  ],
  [
    const Color.fromARGB(255, 90, 60, 255),
    const Color.fromARGB(255, 120, 255, 255),
  ],
  [
    const Color.fromARGB(255, 255, 60, 120),
    const Color.fromARGB(255, 237, 120, 255),
  ]
];

List<MetaballsEffect?> effects = [
  MetaballsEffect.grow(),
  MetaballsEffect.ripple(
    width: 1.5,
    speed: 2,
    growthFactor: 0.125
  ),
  null
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
  int colorIndex = 0;
  int effectIndex = 0;

  @override
  Widget build(BuildContext context) {
    double width = MediaQuery.of(context).size.width;

    return Material(
      child: GestureDetector(
        onLongPress: () {
          setState(() {
            effectIndex=(effectIndex+1)%effects.length;
          });
        },
        onTap: () {
          setState(() {
            colorIndex=(colorIndex+1)%colorStops.length;
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
              ]
            )
          ),
          child: Metaballs(
            effect: MetaballsEffect.follow(
              growthFactor: 1,
              radius: 0.5,
              smoothing: 1
            ),
            glowRadius: 1,
            glowIntensity: 0.6,
            maxBallRadius: 40,
            minBallRadius: 17,
            metaballs: 60,
            color: Colors.grey,
            gradient: LinearGradient(
              colors: colorStops[colorIndex],
              begin: Alignment.bottomRight,
              end: Alignment.topLeft
            ),
            child: Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Text(
                    'METABALLS',
                    style: TextStyle(
                      shadows: [
                        Shadow(
                          color: Colors.black.withOpacity(0.6),
                          blurRadius: 80
                        )
                      ],
                      fontSize: 50 * width / 400,
                      fontWeight: FontWeight.w900
                    ),
                  ),
                  Text(
                    'TAP TO CHANGE COLOR',
                    style: TextStyle(
                      shadows: [
                        Shadow(
                          color: Colors.black.withOpacity(0.6),
                          blurRadius: 80
                        )
                      ],
                      fontSize: 18 * width / 400,
                      fontWeight: FontWeight.w900
                    ),
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