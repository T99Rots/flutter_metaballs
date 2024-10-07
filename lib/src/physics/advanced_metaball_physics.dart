import 'package:flutter/foundation.dart';
import 'package:flutter/rendering.dart';
import 'package:metaballs/src/models/equalized_aspect_ratio.dart';

import 'metaballs_physics.dart';

abstract class AdvancedMetaballPhysicsState<Physics extends MetaballsPhysics> extends MetaballState<Physics> {
  AdvancedMetaballPhysicsState();

  final List<VectorDebugData> debugForceVectors = <VectorDebugData>[];
  Offset velocity = Offset.zero;
  Offset netForce = Offset.zero;

  @override
  void tick(Duration frameTime) {
    final EqualizedAspectRatio aspectRatio = scene.aspectRatio;
    final double deltaTime = frameTime.inMicroseconds / 1e6;

    netForce = Offset.zero;

    applyForces();

    final Offset vector = Offset(
      -velocity.dx * friction * aspectRatio.x,
      -velocity.dy * friction * aspectRatio.y,
    );
    netForce += vector;
    assert(() {
      debugForceVectors.clear();
      debugForceVectors.add(VectorDebugData(
        debugColor: const Color(0x80ff0000),
        vector: vector,
      ));

      return true;
    }());

    final Offset acceleration = Offset(
      netForce.dx / mass / aspectRatio.x,
      netForce.dy / mass / aspectRatio.y,
    );
    velocity += Offset(
      acceleration.dx * deltaTime,
      acceleration.dy * deltaTime,
    );
    metaball.position = Offset(
      metaball.position.dx + velocity.dx * deltaTime,
      metaball.position.dy + velocity.dy * deltaTime,
    );
  }

  void applyForces();

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

  @override
  @mustCallSuper
  void debugPaint(PaintingContext context, Offset offset) {
    assert(() {
      final Canvas canvas = context.canvas;
      final Paint forcePaint = Paint()..strokeWidth = 2;
      final double scale = debugForceScale;

      for (int i = 0; i < debugForceVectors.length; i++) {
        final VectorDebugData vectorData = debugForceVectors[i];
        forcePaint.color = vectorData.debugColor;

        canvas.drawLine(
          offset,
          offset + (vectorData.vector * scale),
          forcePaint,
        );
      }

      return true;
    }());
  }

  double get debugForceScale;

  double get mass;

  double get friction;
}

class VectorDebugData {
  const VectorDebugData({
    required this.debugColor,
    required this.vector,
  });

  final Color debugColor;
  final Offset vector;
}
