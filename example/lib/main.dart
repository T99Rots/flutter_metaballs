import 'package:flutter/material.dart';
import 'package:metaballs/metaballs.dart';

List<List<Color>> colorStops = [
  [
    Color(0xffffb000),
    Color(0xffff00ff),
    Color(0xff00ffff),
  ],
  [
    Color(0xff51c26f),
    Color(0xfff2e901),
  ],
  [
    Color(0xff2c6cbc),
    Color(0xff71c3f7),
    Color(0xfff6f6f6),
  ],
  [
    const Color(0xffe5f392),
    const Color(0xffe49e71),
    const Color(0xffd45f97),
  ],
  [
    Color(0xffff00ff),
    Color(0xff6000ff),
    Color(0xff0080ff),
    Color(0xff00ffff),
  ],
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
  int index = 0;

  @override
  Widget build(BuildContext context) {
    double width = MediaQuery.of(context).size.width;

    return Material(
      child: GestureDetector(
        onTap: () {
          setState(() {
            index=(index+1)%colorStops.length;
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
            maxBallRadius: 50,
            minBallRadius: 20,
            color: Colors.grey,
            gradient: LinearGradient(
              colors: colorStops[index],
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