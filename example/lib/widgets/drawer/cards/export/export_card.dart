import 'package:flutter/material.dart';
import 'package:metaball_demo/widgets/card_with_title.dart';

class ExportCard extends StatelessWidget {
  const ExportCard({super.key});

  @override
  Widget build(BuildContext context) {
    return CardWithTitle(
      title: 'Export',
      child: Column(
        children: <Widget>[
          OutlinedButton(
            onPressed: () {},
            child: const Text('Export Configuration'),
          )
        ],
      ),
    );
  }
}
