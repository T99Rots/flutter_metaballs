import 'package:flutter/material.dart';

abstract class CardWithTitle extends StatelessWidget {
  const factory CardWithTitle({
    required Widget child,
    Key? key,
    required String title,
  }) = _CardWithTitleDefault;

  const factory CardWithTitle.list({
    required Widget child,
    Key? key,
    required String title,
  }) = _CardWithTitleList;

  const CardWithTitle._({
    super.key,
    required this.child,
    required this.title,
  });

  final Widget child;
  final String title;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(
        left: 10,
        bottom: 10,
        right: 10,
      ),
      child: Card.filled(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: <Widget>[
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 10),
              child: Text(
                title,
                style: Theme.of(context).textTheme.titleMedium,
              ),
            ),
            const Divider(
              height: 1,
            ),
            buildChild(context),
          ],
        ),
      ),
    );
  }

  Widget buildChild(BuildContext context);
}

class _CardWithTitleDefault extends CardWithTitle {
  const _CardWithTitleDefault({
    super.key,
    required super.child,
    required super.title,
  }) : super._();

  @override
  Widget buildChild(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 15),
      child: child,
    );
  }
}

class _CardWithTitleList extends CardWithTitle {
  const _CardWithTitleList({
    super.key,
    required super.child,
    required super.title,
  }) : super._();

  @override
  Widget buildChild(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 15),
      child: child,
    );
  }
}
