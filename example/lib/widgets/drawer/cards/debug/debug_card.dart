import 'package:flutter/material.dart';
import 'package:metaball_demo/widgets/card_with_title.dart';

class DebugCard extends StatelessWidget {
  const DebugCard({super.key});

  @override
  Widget build(BuildContext context) {
    return CardWithTitle.list(
      title: 'Debugging',
      child: Column(
        children: <Widget>[
          SwitchListTile(
            title: const Text('Effects debugging'),
            value: true,
            onChanged: (_) {},
          ),
          SwitchListTile(
            title: const Text('Physics debugging'),
            value: true,
            onChanged: (_) {},
          ),
        ],
      ),
    );
  }
}
