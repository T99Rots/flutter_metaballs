import 'dart:math';

import 'package:flutter/scheduler.dart';
import 'package:flutter/widgets.dart';
import 'package:metaballs/src/effects/interface/metaballs_effect.dart';
import 'package:metaballs/src/models/metaball.dart';
import 'package:metaballs/src/models/visual_metaball.dart';
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
    _effectState = effect.createState();
    _physicsScene = physics.createScene();

    for (int i = 0; i < count; i++) {
      _metaballs.add(
        Metaball(
          position: Offset(
            _random.nextDouble(),
            _random.nextDouble(),
          ),
          radius: _random.nextDouble(),
          createdAt: Duration.zero,
        ),
      );
    }
  }

  late final Ticker _ticker;
  final Random _random = Random();
  final List<Metaball> _metaballs = <Metaball>[];
  late MetaballsEffectStateAny _effectState;
  late MetaballsPhysicsSceneAny _physicsScene;
  Duration lastFrame = Duration.zero;

  void visitMetaballs(MetaballsVisitor visitor) {
    for (final Metaball metaball in _metaballs) {
      visitor(metaball);
    }
  }

  void _tick(Duration elapsed) {
    final Duration frameTime = elapsed - lastFrame;
    _effectState.beforePhysics(this);
    final double timeScale = _effectState.getTimeScale();
    _physicsScene.tick(frameTime * timeScale);
    _effectState.beforePhysics(this);
    notifyListeners();
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
