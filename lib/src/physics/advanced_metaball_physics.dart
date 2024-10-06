import 'package:flutter/foundation.dart';
import 'package:flutter/rendering.dart';
import 'package:metaballs/src/models/equalized_aspect_ratio.dart';
import 'package:metaballs/src/models/metaball.dart';

import 'metaballs_physics.dart';

class AdvancedMetaballPhysicsState extends MetaballPhysicsState {
  AdvancedMetaballPhysicsState({
    required this.mass,
    this.netForce = Offset.zero,
    this.velocity = Offset.zero,
  });

  final List<VectorDebugData> debugForceVectors = <VectorDebugData>[];
  Offset velocity;
  Offset netForce;
  double mass;

  void reset() {
    debugForceVectors.clear();
    netForce = Offset.zero;
  }

  void applyForce(Offset force, Color debugColor) {
    netForce += force;
    assert(() {
      debugForceVectors.add(VectorDebugData(
        debugColor: debugColor,
        vector: force,
      ));

      return true;
    }());
  }

  void applyResistance({
    required EqualizedAspectRatio aspectRatio,
    required double friction,
  }) {
    final Offset vector = Offset(
      -velocity.dx * friction * aspectRatio.x,
      -velocity.dy * friction * aspectRatio.y,
    );
    netForce += vector;
    assert(() {
      debugForceVectors.add(VectorDebugData(
        debugColor: const Color(0x80ff0000),
        vector: vector,
      ));

      return true;
    }());
  }

  Offset getUpdatedPosition({
    required EqualizedAspectRatio aspectRatio,
    required Duration frameTime,
    required Offset position,
  }) {
    final double deltaTime = frameTime.inMicroseconds / 1e6;

    final Offset acceleration = Offset(
      netForce.dx / mass / aspectRatio.x,
      netForce.dy / mass / aspectRatio.y,
    );

    velocity += Offset(
      acceleration.dx * deltaTime,
      acceleration.dy * deltaTime,
    );

    return Offset(
      position.dx + velocity.dx * deltaTime,
      position.dy + velocity.dy * deltaTime,
    );
  }
}

mixin AdvancedMetaballPhysicsSceneMixin<Physics extends MetaballsPhysics, State extends AdvancedMetaballPhysicsState>
    on MetaballsPhysicsScene<Physics, State> {
  double get debugForceScale;

  double get friction;

  @override
  @mustCallSuper
  void tickMetaball(Duration frameTime, Metaball metaball, State? state) {
    if (state == null) {
      return;
    }

    final EqualizedAspectRatio aspectRatio = scene.aspectRatio;

    state.reset();

    applyMetaballForces(metaball, state);

    state.applyResistance(
      aspectRatio: aspectRatio,
      friction: friction,
    );

    metaball.position = state.getUpdatedPosition(
      aspectRatio: aspectRatio,
      frameTime: frameTime,
      position: metaball.position,
    );
  }

  void applyMetaballForces(Metaball metaball, State? state);

  @override
  @mustCallSuper
  void debugPaint(PaintingContext context, Offset offset) {
    assert(() {
      final Canvas canvas = context.canvas;
      final Paint forcePaint = Paint()..strokeWidth = 2;
      final double scale = debugForceScale;

      visitMetaballs((Metaball metaball, AdvancedMetaballPhysicsState? state) {
        if (state == null) {
          return;
        }

        for (int i = 0; i < state.debugForceVectors.length; i++) {
          final VectorDebugData vectorData = state.debugForceVectors[i];
          final Offset realPosition = metaball.transform.apply(metaball.position) + offset;
          forcePaint.color = vectorData.debugColor;

          canvas.drawLine(
            realPosition,
            realPosition + (vectorData.vector * scale),
            forcePaint,
          );
        }
      });

      return true;
    }());
  }
}

class VectorDebugData {
  const VectorDebugData({
    required this.debugColor,
    required this.vector,
  });

  final Color debugColor;
  final Offset vector;
}
