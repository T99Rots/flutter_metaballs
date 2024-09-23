import 'package:flutter/material.dart';
import 'package:metaball_demo/widgets/card_with_title.dart';

class InfoCard extends StatelessWidget {
  const InfoCard({super.key});

  @override
  Widget build(BuildContext context) {
    final TextStyle linkStyle = DefaultTextStyle.of(context).style.copyWith(
          color: Theme.of(context).colorScheme.primary,
        );

    return CardWithTitle(
      title: 'Info',
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          RichText(
            text: TextSpan(
              children: <InlineSpan>[
                const TextSpan(text: 'This library was created by '),
                TextSpan(
                  text: '@T99Rots',
                  style: linkStyle,
                  mouseCursor: SystemMouseCursors.click,
                ),
                const TextSpan(
                  text: ' on GitHub. If you are interested in hiring a remote '
                      'flutter developer specialized in rendering and '
                      'implementing user and developer friendly custom designed'
                      ' components, pleas contact me through ',
                ),
                TextSpan(
                  text: 'Linkedin',
                  style: linkStyle,
                  mouseCursor: SystemMouseCursors.click,
                ),
                const TextSpan(text: '.'),
              ],
            ),
          ),
          const SizedBox(height: 10),
          OutlinedButton(
            onPressed: () {},
            child: const Text('GitHub Repository'),
          ),
          OutlinedButton(
            onPressed: () {},
            child: const Text('API Docs'),
          ),
          OutlinedButton(
            onPressed: () {},
            child: const Text('pub.dev'),
          ),
        ],
      ),
    );
  }
}
