import 'dart:math';

import 'package:flutter/material.dart';

/// A Widget allowing you to select a alignment for a gradient with build in preview.
class DirectionSelectorAndPreview extends StatelessWidget {
  const DirectionSelectorAndPreview({
    super.key,
    required this.gradient,
    required this.alignment,
    required this.onChange,
  });

  final Gradient gradient;
  final Alignment alignment;
  final void Function(Alignment alignment) onChange;

  @override
  Widget build(BuildContext context) {
    return Flexible(
      child: SizedBox(
        height: 150,
        width: 150,
        child: Stack(
          children: <Widget>[
            Padding(
              padding: const EdgeInsets.all(12.0),
              child: AnimatedContainer(
                curve: Curves.easeOut,
                duration: const Duration(milliseconds: 200),
                decoration: BoxDecoration(
                  gradient: gradient,
                  borderRadius: BorderRadius.circular(5),
                ),
              ),
            ),
            Material(
              color: Colors.transparent,
              child: InputDecorator(
                decoration: const InputDecoration(
                  label: Text('Select alignment'),
                  border: OutlineInputBorder(),
                  contentPadding: EdgeInsets.symmetric(horizontal: 15, vertical: 18),
                ),
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(5),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: <Widget>[
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: <Widget>[
                          _DirectionButton(
                            alignment: Alignment.topLeft,
                            currentAlignment: alignment,
                            onChange: onChange,
                          ),
                          _DirectionButton(
                            alignment: Alignment.topCenter,
                            currentAlignment: alignment,
                            onChange: onChange,
                          ),
                          _DirectionButton(
                            alignment: Alignment.topRight,
                            currentAlignment: alignment,
                            onChange: onChange,
                          ),
                        ],
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: <Widget>[
                          _DirectionButton(
                            alignment: Alignment.centerLeft,
                            currentAlignment: alignment,
                            onChange: onChange,
                          ),
                          _DirectionButton(
                            alignment: Alignment.centerRight,
                            currentAlignment: alignment,
                            onChange: onChange,
                          ),
                        ],
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: <Widget>[
                          _DirectionButton(
                            alignment: Alignment.bottomLeft,
                            currentAlignment: alignment,
                            onChange: onChange,
                          ),
                          _DirectionButton(
                            alignment: Alignment.bottomCenter,
                            currentAlignment: alignment,
                            onChange: onChange,
                          ),
                          _DirectionButton(
                            alignment: Alignment.bottomRight,
                            currentAlignment: alignment,
                            onChange: onChange,
                          ),
                        ],
                      )
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _DirectionButton extends StatelessWidget {
  const _DirectionButton({
    required this.currentAlignment,
    required this.onChange,
    required this.alignment,
  });

  final Alignment currentAlignment;
  final Alignment alignment;
  final void Function(Alignment alignment) onChange;

  @override
  Widget build(BuildContext context) {
    final bool selected = currentAlignment == alignment;

    return IconButton(
      onPressed: () {
        onChange(alignment);
      },
      icon: AnimatedScale(
        scale: selected ? 1.0 : 0.6,
        duration: const Duration(milliseconds: 300),
        curve: Curves.elasticOut,
        child: icon,
      ),
    );
  }

  Widget get icon {
    return Transform.rotate(
      angle: atan2(alignment.y, alignment.x),
      child: const Icon(
        Icons.arrow_forward_rounded,
        shadows: <Shadow>[
          Shadow(
            blurRadius: 8,
            color: Colors.black54,
          ),
        ],
      ),
    );
  }
}
