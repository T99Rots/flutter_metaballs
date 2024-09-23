import 'package:flutter/material.dart';
import 'package:metaball_demo/widgets/drawer/cards/color_gradient/color_gradient_card.dart';
import 'package:metaball_demo/widgets/drawer/cards/debug/debug_card.dart';
import 'package:metaball_demo/widgets/drawer/cards/effects/effects_card.dart';
import 'package:metaball_demo/widgets/drawer/cards/export/export_card.dart';
import 'package:metaball_demo/widgets/drawer/cards/general/general_card.dart';
import 'package:metaball_demo/widgets/drawer/cards/info/info_card.dart';
import 'package:metaball_demo/widgets/drawer/cards/physics/physics_card.dart';
import 'package:metaball_demo/widgets/drawer/cards/size/size_card.dart';

class MetaballsDrawer extends StatelessWidget {
  const MetaballsDrawer({super.key});

  @override
  Widget build(BuildContext context) {
    return Drawer(
      backgroundColor: const Color(0xff141218),
      width: 340,
      child: SafeArea(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: <Widget>[
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
              child: Text(
                'Configuration',
                style: Theme.of(context).textTheme.titleLarge,
              ),
            ),
            Expanded(
              child: ListView(
                children: const <Widget>[
                  GeneralCard(),
                  SizeCard(),
                  PhysicsCard(),
                  EffectsCard(),
                  ColorGradientCard(),
                  ExportCard(),
                  InfoCard(),
                  DebugCard(),
                ],
              ),
            )
          ],
        ),
      ),
    );
  }
}
