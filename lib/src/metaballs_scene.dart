import 'dart:math';

import 'package:flutter/scheduler.dart';
import 'package:flutter/widgets.dart';
import 'package:metaballs/src/effects/metaballs_effect.dart';
import 'package:metaballs/src/models/metaball.dart';
import 'package:metaballs/src/models/metaball_render_data.dart';
import 'package:metaballs/src/models/transform.dart';
import 'package:metaballs/src/physics/metaballs_physics.dart';
import 'package:metaballs/src/scalers/metaball_scaler.dart';

import 'models/equalized_aspect_ratio.dart';

typedef MetaballsVisitor = void Function(Metaball metaball);

class MetaballsScene with ChangeNotifier {
  MetaballsScene({
    required TickerProvider vsync,
    required MetaballsEffect? effect,
    required MetaballsPhysics physics,
    required int count,
    required MetaballScaler scaler,
  })  : _effect = effect,
        _effectState = effect?.createState(),
        _physics = physics,
        _scaler = scaler {
    _ticker = vsync.createTicker(_tick)..start();
    _effectState?.attach(this, effect!);

    for (int i = 0; i < count; i++) {
      final Metaball metaball = _createMetaball();

      final MetaballStateAny state = physics.createState();
      state.attach(this, physics, metaball);
      state.initState(null);
      metaball.physicsState = state;
      _metaballs.add(metaball);
    }
  }

  late final Ticker _ticker;
  final Random _random = Random();
  final List<MetaballRenderData> renderData = <MetaballRenderData>[];
  final List<Metaball> _metaballs = <Metaball>[];

  MetaballScaler _scaler;

  MetaballsEffectStateAny? _effectState;
  MetaballsEffect? _effect;

  // MetaballsPhysicsSceneAny _physicsScene;
  MetaballsPhysics _physics;

  Size? _viewportSize;
  Duration _lastFrame = Duration.zero;
  Duration _frameTime = Duration.zero;
  MetaballRenderStage _stage = MetaballRenderStage.none;

  Metaball _createMetaball() {
    return Metaball(
      position: Offset(
        _random.nextDouble(),
        _random.nextDouble(),
      ),
      radius: _random.nextDouble(),
      createdAt: Duration.zero,
    );
  }

  void visitMetaballs(MetaballsVisitor visitor) {
    for (final Metaball metaball in _metaballs) {
      visitor(metaball);
    }
  }

  void _applyRenderTransform(Size viewportSize) {
    _effectState?.beforeTransform();
    for (final Metaball metaball in _metaballs) {
      metaball.transform.reset();
    }

    final Transform1D radiusTransform = _scaler.getTransform(this);

    for (final Metaball metaball in _metaballs) {
      final double renderRadius = radiusTransform.apply(metaball.radius);

      metaball.transform
        ..scale(
          viewportSize.width - renderRadius,
          viewportSize.height - renderRadius,
        )
        ..translate(
          renderRadius / 2,
          renderRadius / 2,
        );
    }
    _effectState?.beforeComposition();
    _stage = MetaballRenderStage.composition;

    renderData.clear();
    for (final Metaball metaball in _metaballs) {
      renderData.add(MetaballRenderData(
        position: metaball.transform.apply(metaball.position),
        radius: radiusTransform.apply(metaball.radius),
      ));
    }
    _effectState?.beforeRender();
    _stage = MetaballRenderStage.render;
  }

  void _tick(Duration elapsed) {
    _frameTime = elapsed - _lastFrame;
    _lastFrame = elapsed;
    if (_frameTime > const Duration(milliseconds: 100)) {
      _frameTime = const Duration(milliseconds: 100);
    }
    _frameTime *= _effectState?.getTimeScale() ?? 1;

    _stage = MetaballRenderStage.physics;
    _effectState?.beforePhysics();
    for (final Metaball metaball in _metaballs) {
      metaball.physicsState!.tick(frameTime);
    }
    _effectState?.afterPhysics();
    _stage = MetaballRenderStage.transform;

    final Size? viewportSize = _viewportSize;
    if (viewportSize != null) {
      _applyRenderTransform(viewportSize);
    }
    notifyListeners();
  }

  void update({
    required MetaballsEffect? effect,
    required MetaballsPhysics physics,
    required MetaballScaler metaballScaler,
    required int count,
  }) {
    if (effect != _effect) {
      if (effect == null) {
        _effectState?.detach();
        _effectState = null;
      } else if (_effectState == null) {
        _effectState = effect.createState()..attach(this, effect);
      } else if (effect.runtimeType == _effect.runtimeType) {
        _effectState!.update(effect);
      } else {
        _effectState!.detach();
        _effectState = effect.createState();
        _effectState!.attach(this, effect);
      }
    }

    final int oldCount = _metaballs.length;
    final int difference = count - oldCount;
    if (difference != 0) {
      if (difference > 0) {
        for (int i = 0; i < difference; i++) {
          final Metaball metaball = _createMetaball();
          _metaballs.add(metaball);
          if (physics.runtimeType == _physics.runtimeType) {
            final MetaballStateAny state = physics.createState();
            state.attach(this, physics, metaball);
            state.initState(null);
            metaball.physicsState = state;
          }
        }
      } else {
        for (int i = 0; i > difference; i--) {
          final Metaball metaball = _metaballs.removeLast();
          final MetaballStateAny state = metaball.physicsState!;
          state.detach();
        }
      }
    }

    if (physics != _physics) {
      if (physics.runtimeType == _physics.runtimeType) {
        for (final Metaball metaball in _metaballs) {
          metaball.physicsState!.update(physics);
        }
      } else {
        final List<MetaballStateAny?> oldStates = <MetaballStateAny?>[];

        for (int i = 0; i < _metaballs.length; i++) {
          final Metaball metaball = _metaballs[i];
          final MetaballStateAny? oldState;
          if (i < oldCount) {
            oldState = metaball.physicsState;
          } else {
            oldState = null;
          }

          final MetaballStateAny state = physics.createState();
          state.attach(this, physics, metaball);
          state.initState(oldState);
          metaball.physicsState = state;

          oldStates.add(state);
        }
      }
    }

    _effect = effect;
    _physics = physics;
    _scaler = metaballScaler;
  }

  @override
  void dispose() {
    _ticker.dispose();
    super.dispose();
  }

  void handlePointerEvent(PointerEvent event) {
    _effectState?.handlePointerEvent(event);
  }

  void updateViewportSize(Size size) {
    _viewportSize = size;
    if (_stage == MetaballRenderStage.transform) {
      _applyRenderTransform(size);
    }
  }

  void debugPaint({
    required PaintingContext context,
    required Offset offset,
    required bool effectsDebugging,
    required bool physicsDebugging,
  }) {
    assert(() {
      if (physicsDebugging) {
        for (final Metaball metaball in _metaballs) {
          final Offset metaballOffset = metaball.transform.apply(metaball.position) + offset;
          metaball.physicsState!.debugPaint(context, metaballOffset);
        }
      }
      if (effectsDebugging) {
        _effectState?.debugPaint(context, offset);
      }
      return true;
    }());
  }

  List<Metaball> get metaballs => _metaballs;

  Duration get elapsed => _lastFrame;

  Size get viewportSize {
    assert(
      _viewportSize != null,
      'Tried accessing viewportSize before this was available.\n'
      'Most likely you tried doing so from beforePhysics or afterPhysics, try '
      'using beforeRenderTransform instead or check whether size is available '
      'using hasSize.',
    );

    return _viewportSize!;
  }

  bool get hasSize => _viewportSize != null;

  MetaballScaler get scaler => _scaler;

  MetaballsEffect? get effect => _effect;

  MetaballsPhysics get physics => _physics;

  Duration get frameTime => _frameTime;

  EqualizedAspectRatio get aspectRatio => EqualizedAspectRatio.fromRatio(
        _viewportSize?.aspectRatio ?? 1,
      );
}

enum MetaballRenderStage {
  none,
  physics,
  transform,
  composition,
  render,
}
