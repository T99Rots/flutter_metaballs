import 'package:flutter/material.dart';
import 'package:metaball_demo/screens/metaballs_builder.dart';
import 'package:metaball_demo/widgets/drawer/metaballs_drawer.dart';
import 'package:metaball_demo/widgets/theme_brightness_button/theme_brightness_button.dart';

import 'example_layout_builder.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Builder(builder: (BuildContext context) {
          TextStyle style = DefaultTextStyle.of(context).style;

          if (style.color!.computeLuminance() > 0.5) {
            style = style.copyWith(
              shadows: <Shadow>[
                const Shadow(
                  color: Colors.black54,
                  blurRadius: 8,
                ),
              ],
            );
          }

          return Text(
            'Metaballs Demo',
            style: style,
          );
        }),
        actions: const <Widget>[
          ThemeBrightnessButton(),
        ],
        surfaceTintColor: Colors.transparent,
        backgroundColor: Colors.transparent,
      ),
      body: const MetaballsBuilder(
        child: ExampleLayoutBuilder(),
      ),
      drawer: const MetaballsDrawer(),
      extendBodyBehindAppBar: true,
    );
  }
}
