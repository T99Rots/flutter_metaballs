library metaballs;

import 'dart:math';

import 'package:flutter/widgets.dart';
import 'package:metaballs/src/effects/_effects.dart';
import 'package:metaballs/src/models/_models.dart';
import 'package:metaballs/src/widgets/_widgets.dart';

/// A metaballs implementation for flutter.
///
/// Based on webgl on the web and on precompiled shaders assets on other devices.
class Metaballs extends StatefulWidget {
  Metaballs({
    super.key,
    this.child,
    MetaballsConfig? config,
  }) : config = config ?? MetaballsConfig();

  /// The config for the metaballs.
  final MetaballsConfig config;

  /// A widget to be placed on top of the Metaballs widget.
  final Widget? child;

  @override
  State<Metaballs> createState() => _MetaBallsState();
}

class _MetaBallsState extends State<Metaballs> with TickerProviderStateMixin {
  final List<MetaballsEffectState<MetaballsEffect>> _effectStates = <MetaballsEffectState<MetaballsEffect>>[];
  final GlobalKey _key = GlobalKey();
  late List<Metaball> _metaballs;
  late AnimationController _controller;

  double _lastFrame = 0;

  @override
  void initState() {
    _controller = AnimationController.unbounded(
      duration: const Duration(days: 365),
      vsync: this,
    )..animateTo(const Duration(days: 365).inSeconds.toDouble());

    _metaballs = List<Metaball>.generate(
      widget.config.metaballs,
      (_) => Metaball.withRandomValues(),
    );
    super.initState();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  void didUpdateWidget(covariant Metaballs oldWidget) {
    if (_metaballs.length != widget.config.metaballs) {
      final int difference = widget.config.metaballs - _metaballs.length;
      if (difference < 0) {
        _metaballs.removeRange(_metaballs.length + difference, _metaballs.length);
      } else {
        for (int i = 0; i < difference; i++) {
          _metaballs.add(Metaball.withRandomValues());
        }
      }
    }
    super.didUpdateWidget(oldWidget);
  }

  @override
  Widget build(BuildContext context) {
    Widget resultWidget = LayoutBuilder(builder: (BuildContext context, BoxConstraints constraints) {
      final Size size = Size(constraints.maxWidth, constraints.maxHeight);
      final double pixelRatio = MediaQuery.of(context).devicePixelRatio;

      return SizedBox.expand(
        child: AnimatedBuilder(
          animation: _controller,
          builder: (BuildContext context, Widget? child) {
            final double time = _controller.value;
            final double frameTime = min(time - _lastFrame, 0.25);
            _lastFrame = time;

            final MetaballFrameData frameData = MetaballFrameData(
              canvasSize: size,
              frameTime: frameTime,
              speedMultiplier: frameTime,
              time: time,
              config: widget.config,
              effects: _effectStates,
            );

            for (final Metaball metaball in _metaballs) {
              metaball.computeNewState(frameData);
            }

            final List<MetaballShaderData> computedShaderData =
                _metaballs.map((Metaball metaball) => metaball.computeShaderData(frameData)).toList();

            return MetaballsRenderer(
              key: _key,
              time: time,
              size: size,
              pixelRatio: pixelRatio,
              metaballsData: computedShaderData,
              config: widget.config,
            );
          },
        ),
      );
    });

    if (widget.child != null) {
      resultWidget = Stack(
        children: <Widget>[
          resultWidget,
          widget.child!,
        ],
      );
    }

    if (widget.config.effects != null && widget.config.effects!.isNotEmpty) {
      resultWidget = CombinedListener(
        onPointerAdded: (Pointer pointer) {},
        onTap: (TapEvent tabEvent) {},
        child: resultWidget,
      );
    }

    return resultWidget;
  }
}
