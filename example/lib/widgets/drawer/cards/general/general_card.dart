import 'package:flutter/material.dart';
import 'package:metaball_demo/widgets/card_with_title.dart';

class GeneralCard extends StatelessWidget {
  const GeneralCard({super.key});

  @override
  Widget build(BuildContext context) {
    return const CardWithTitle(
      title: 'General',
      child: Column(
        children: <Widget>[],
      ),
    );
  }
}
