import 'package:flutter/material.dart';
import 'package:metaballs/metaballs.dart';

class ColorPair {
  final Color color1;
  final Color color2;

  ColorPair({
    required this.color1,
    required this.color2
  });
}

List<ColorPair> colorPairs = [
  ColorPair(
    color1: const Color.fromARGB(255, 255, 84, 194),
    color2: const Color.fromARGB(255, 255, 194, 66),
  ),
  ColorPair(
    color1: const Color.fromARGB(255, 0, 110, 255),
    color2: const Color.fromARGB(255, 167, 240, 255)
  ),
  ColorPair(
    color1: const Color.fromARGB(255, 0, 110, 255),
    color2: const Color.fromARGB(255, 162, 0, 255)
  ),
  ColorPair(
    color1: Color.fromARGB(255, 163, 255, 188),
    color2: const Color.fromARGB(255, 17, 205, 36)
  ),
];

void main() {
  // enable dithering to smooth out the gradients and meta balls
  Paint.enableDithering = true;
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Meta Balls Demo',
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
  int index = 0;

  @override
  Widget build(BuildContext context) {
    return Material(
      child: GestureDetector(
        onTap: () {
          setState(() {
            index=(index+1)%colorPairs.length;
          });
        },
        child: Container(
          decoration: BoxDecoration(
            gradient: const RadialGradient(
              center: Alignment(-0.5, 1),
              radius: 1.5,
              colors: [
                Color.fromARGB(255, 13, 35, 61),
                Colors.black,
              ]
            ).lerpTo(const RadialGradient(
              center: Alignment(0.5, 1),
              radius: 1.5,
              colors: [
                Color.fromARGB(255, 71, 21, 58),
                Colors.black,
              ]
            ), 0)
          ),
          child: Metaballs(

            glowRadius: 1,
            glowIntensity: 0.6,
            color1: colorPairs[index].color1,
            color2: colorPairs[index].color2,
            child: Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Text(
                    'META BALLS',
                    style: TextStyle(
                      shadows: [
                        Shadow(
                          color: Colors.black.withOpacity(0.6),
                          blurRadius: 80
                        )
                      ],
                      fontSize: 50,
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
                      fontSize: 20,
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