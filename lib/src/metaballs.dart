library metaballs;

import 'dart:math';

import 'package:flutter/widgets.dart';
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
  late List<Metaball> _metaBalls;
  late AnimationController _controller;
  final Map<int, Pointer> _pointers = <int, Pointer>{};
  final GlobalKey _key = GlobalKey();
  final Random _random = Random();

  double _lastFrame = 0;

  @override
  void initState() {
    _controller = AnimationController.unbounded(
      duration: const Duration(days: 365),
      vsync: this,
    )..animateTo(const Duration(days: 365).inSeconds.toDouble());

    _metaBalls = List<Metaball>.generate(
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
    if (_metaBalls.length != widget.config.metaballs) {
      final int difference = widget.config.metaballs - _metaBalls.length;
      if (difference < 0) {
        _metaBalls.removeRange(_metaBalls.length + difference, _metaBalls.length);
      } else {
        for (int i = 0; i < difference; i++) {
          _metaBalls.add(Metaball.withRandomValues());
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

            final List<MetaballShaderData> computedMetaballs = _metaBalls
                .map((Metaball metaball) => metaball.computeShaderData(MetaballFrameData(
                      canvasSize: size,
                      frameTime: frameTime,
                      speedMultiplier: frameTime,
                      time: time,
                      config: widget.config,
                    )))
                .toList();

            for (final Pointer pointer in _pointers.values) {
              pointer.delta = const Offset(0, 0);
            }

            return MetaballsRenderer(
              key: _key,
              time: time,
              size: size,
              pixelRatio: pixelRatio,
              metaballsData: computedMetaballs,
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
        onPress: (PointerEvent event) {},
        onMove: (PointerEvent event) {
          if (event.delta.distance > 0 && _pointers.containsKey(event.pointer)) {
            _pointers[event.pointer]!
              ..delta = event.delta
              ..position = event.position;
          }
        },
        onAdd: (PointerEvent event) {
          if (!_pointers.containsKey(event.pointer)) {
            _pointers[event.pointer] = Pointer(
              created: _controller.value,
              delta: event.delta,
              position: event.localPosition,
              kind: event.kind,
            );
          }
        },
        onRemove: (PointerEvent event) {
          _pointers.remove(event.pointer)?.timeDeleted = _controller.value;
        },
        child: resultWidget,
      );
    }

    return resultWidget;
  }
}
