import 'package:flutter/material.dart';
import 'package:metaball_demo/widgets/card_with_title.dart';

class DebugCard extends StatelessWidget {
  const DebugCard({super.key});

  @override
  Widget build(BuildContext context) {
    return const CardWithTitle(
      title: 'Debugging',
      child: Column(
        children: <Widget>[],
      ),
    );
  }
}
