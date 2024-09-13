import 'dart:math';

import 'package:flutter/scheduler.dart';
import 'package:flutter/widgets.dart';
import 'package:metaballs/src/effects/interface/metaballs_effect.dart';
import 'package:metaballs/src/models/metaball.dart';
import 'package:metaballs/src/models/visual_metaball.dart';
import 'package:metaballs/src/physics/interface/metaball_physics_state.dart';
import 'package:metaballs/src/physics/interface/metaballs_physics.dart';
import 'package:metaballs/src/physics/interface/metaballs_physics_scene.dart';
import 'package:metaballs/src/pointer.dart';

typedef MetaballsVisitor = void Function(Metaball metaball);

class MetaballsScene with ChangeNotifier {
  MetaballsScene({
    required TickerProvider vsync,
    required MetaballsEffect effect,
    required MetaballsPhysics physics,
    required int count,
  }) {
    _ticker = vsync.createTicker(_tick)..start();

    _physicsScene = physics.createScene();
    _physicsScene.attach(this, physics);
    _physics = physics;

    _effect = effect;
    _effectState = effect.createState();
    _effectState.attach(this, effect);

    for (int i = 0; i < count; i++) {
      final Metaball metaball = _createMetaball();
      _metaballs.add(metaball);
      _physicsScene.adoptMetaball(metaball, null);
    }
  }

  late final Ticker _ticker;
  final Random _random = Random();
  final List<Metaball> _metaballs = <Metaball>[];

  late MetaballsEffectStateAny _effectState;
  late MetaballsEffect _effect;

  late MetaballsPhysicsSceneAny _physicsScene;
  late MetaballsPhysics _physics;

  Duration lastFrame = Duration.zero;

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

  void _tick(Duration elapsed) {
    Duration frameTime = elapsed - lastFrame;
    if (frameTime > Duration(milliseconds: 100)) {
      frameTime = Duration(milliseconds: 100);
    }

    lastFrame = elapsed;
    _effectState.beforePhysics(this);
    final double timeScale = _effectState.getTimeScale();
    _physicsScene.tick(frameTime * timeScale);
    _effectState.beforePhysics(this);
    notifyListeners();
  }

  void update({
    required MetaballsEffect effect,
    required MetaballsPhysics physics,
    required int count,
  }) {
    if (effect != _effect) {
      if (effect.runtimeType == _effect.runtimeType) {
        _effectState.update(effect);
      } else {
        _effectState.detach();
        _effectState = effect.createState();
        _effectState.attach(this, effect);
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
  }

  @override
  void dispose() {
    _ticker.dispose();
    super.dispose();
  }

  void handlePointer(Pointer pointer) {
    _effectState.handlePointer(this, pointer);
  }

  List<VisualMetaball> get metaballs => _metaballs;
}
