import 'dart:math';

import 'package:flutter/scheduler.dart';
import 'package:flutter/widgets.dart';
import 'package:metaballs/src/effects/metaballs_effect.dart';
import 'package:metaballs/src/models/metaball.dart';
import 'package:metaballs/src/models/metaball_render_data.dart';
import 'package:metaballs/src/physics/metaballs_physics.dart';
import 'package:metaballs/src/scalers/metaball_scaler.dart';

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
        _physicsScene = physics.createScene(),
        _scaler = scaler {
    _ticker = vsync.createTicker(_tick)..start();
    _physicsScene.attach(this, physics);
    _effectState?.attach(this, effect!);

    for (int i = 0; i < count; i++) {
      final Metaball metaball = _createMetaball();
      _metaballs.add(metaball);
      _physicsScene.adoptMetaball(metaball, null);
    }
  }

  late final Ticker _ticker;
  final Random _random = Random();
  final List<Metaball> _metaballs = <Metaball>[];
  final List<MetaballRenderData> renderData = <MetaballRenderData>[];

  MetaballScaler _scaler;

  MetaballsEffectStateAny? _effectState;
  MetaballsEffect? _effect;

  MetaballsPhysicsSceneAny _physicsScene;
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

    _scaler.applyScaling(this);

    for (final Metaball metaball in _metaballs) {
      final double renderRadius = metaball.transform.transformRadius(metaball.radius);

      metaball.transform
        ..scalePosition(
          viewportSize.width - renderRadius,
          viewportSize.height - renderRadius,
        )
        ..translatePosition(
          renderRadius / 2,
          renderRadius / 2,
        );
    }
    _effectState?.beforeComposition();
    _stage = MetaballRenderStage.composition;

    renderData.clear();
    for (final Metaball metaball in _metaballs) {
      renderData.add(metaball.transform.transformMetaball(metaball));
    }
    _effectState?.beforeRender();
    _stage = MetaballRenderStage.render;
  }

  void _tick(Duration elapsed) {
    _frameTime = elapsed - _lastFrame;
    _lastFrame = elapsed;
    if (_frameTime > Duration(milliseconds: 100)) {
      _frameTime = Duration(milliseconds: 100);
    }
    _frameTime *= _effectState?.getTimeScale() ?? 1;

    _stage = MetaballRenderStage.physics;
    _effectState?.beforePhysics();
    _physicsScene.tick(_frameTime);
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
    final MetaballsEffectStateAny? oldEffectState = _effectState;
    if (effect != _effect) {
      if (effect == null) {
        _effectState?.detach();
        _effectState = null;
      } else if (oldEffectState == null) {
        _effectState = effect.createState()..attach(this, effect);
      } else if (effect.runtimeType == _effect.runtimeType) {
        oldEffectState.update(effect);
      } else {
        oldEffectState.detach();
        _effectState = effect.createState();
        oldEffectState.attach(this, effect);
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
            _physicsScene.adoptMetaball(metaball, null);
          }
        }
      } else {
        for (int i = 0; i > difference; i--) {
          _physicsScene.dropMetaball(_metaballs.removeLast());
        }
      }
    }

    if (physics != _physics) {
      if (physics.runtimeType == _physics.runtimeType) {
        _physicsScene.update(physics);
      } else {
        final List<MetaballPhysicsState?> oldStates = <MetaballPhysicsState?>[];
        final int minCount = min(_metaballs.length, oldCount);

        for (int i = 0; i < minCount; i++) {
          oldStates.add(
            _physicsScene.dropMetaball(
              _metaballs[i],
            ),
          );
        }
        _physicsScene.detach();
        _physicsScene = physics.createScene();
        _physicsScene.attach(this, physics);
        for (int i = 0; i < _metaballs.length; i++) {
          final MetaballPhysicsState? state = i < minCount ? oldStates[i] : null;
          _physicsScene.adoptMetaball(_metaballs[i], state);
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
}

enum MetaballRenderStage {
  none,
  physics,
  transform,
  composition,
  render,
}
