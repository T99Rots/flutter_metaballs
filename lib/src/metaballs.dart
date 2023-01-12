library metaballs;

import 'dart:math';

import 'package:flutter/widgets.dart';
import 'package:metaballs/src/effects/_effects.dart';
import 'package:metaballs/src/models/_models.dart';
import 'package:metaballs/src/utils/_utils.dart';
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
  final List<Pointer> pointers = <Pointer>[];
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

    if (widget.config.effects != null) {
      _effectStates.addAll(
        widget.config.effects!.map(
          (MetaballsEffect effect) {
            final MetaballsEffectState<MetaballsEffect> state = effect.createState();
            state.updateEffect(effect);
            return state;
          },
        ),
      );
    }

    print(_effectStates);
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
    if (widget.config.effects != null) {
      for (final MetaballsEffect effect in widget.config.effects!) {
        _getOrCreateEffectState(effect, effect.createState);
      }
      _effectStates.removeWhere(
        <E extends MetaballsEffect>(
          MetaballsEffectState<E> state,
        ) {
          return !widget.config.effects!.any(
            (MetaballsEffect effect) => effect is E,
          );
        },
      );
    } else {
      _effectStates.clear();
    }
    super.didUpdateWidget(oldWidget);
  }

  /// Check if a effect state exists, if not create new instance. Also check if
  /// Effect has changed, if so update effect on state.
  void _getOrCreateEffectState<T extends MetaballsEffectState<E>, E extends MetaballsEffect>(
    E effect,
    T Function() createState,
  ) {
    T? state = _effectStates.firstWhereType<T>();

    if (state == null) {
      state = createState();
      _effectStates.add(state);
    }

    if (state.effect != effect) {
      state.updateEffect(effect);
    }
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
              pointers: pointers,
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

    // if (widget.config.effects != null && widget.config.effects!.isNotEmpty) {
    resultWidget = CombinedListener(
      animation: _controller,
      onPointerAdded: (Pointer pointer) {
        print('added');
        for (final MetaballsEffectState<dynamic> effect in _effectStates) {
          effect.onPointerAdded(pointer);
        }

        pointers.add(pointer);

        pointer.listen(
          (_) {},
          onDone: () {
            pointers.remove(pointer);
          },
        );
      },
      onTap: (TapEvent tabEvent) {
        print('tap');
        for (final MetaballsEffectState<dynamic> effect in _effectStates) {
          effect.onTap(tabEvent);
        }
      },
      child: resultWidget,
    );
    // }

    return resultWidget;
  }
}
