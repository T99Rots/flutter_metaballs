library metaballs;

import 'dart:math';

import 'package:flutter/gestures.dart';
import 'package:flutter/widgets.dart';
import 'package:metaballs/native_metaballs_renderer.dart'
    if (dart.library.html) 'package:metaballs/web_metaballs_renderer.dart';
import 'package:metaballs/types.dart';

abstract class MetaballsEffect {
  MetaballsEffect();

  /// This effect makes all metaballs increase and then decrease their radius in an outgoing ripple from a tab / mouse click
  factory MetaballsEffect.ripple(
          {double speed = 1, double width = 1, double growthFactor = 1, Duration fade = const Duration(seconds: 2)}) =>
      MetaballsTabRippleEffect(fade: fade, growthFactor: growthFactor, speed: speed, width: width);

  /// This effect increases the radius of all metaballs based on how close they are to the mouse cursor or a touch
  factory MetaballsEffect.grow({
    double radius = 0.5,
    double growthFactor = 0.5,
    double smoothing = 1,
  }) =>
      MetaballsMouseGrowEffect(
        radius: radius,
        growthFactor: growthFactor,
        smoothing: smoothing,
      );

  /// This effect makes all metaballs speedup relative to how fast you move your mouse or swipe on your touchscreen
  factory MetaballsEffect.speedup({double speedup = 1}) => MetaballsSpeedupEffect(speedup: speedup);

  /// This effect adds a metaball for every cursor / touch and then follows that cursor / touch around
  factory MetaballsEffect.follow({double smoothing = 1, double growthFactor = 1, double? radius}) =>
      MetaballsFollowMouseEffect(smoothing: smoothing, growthFactor: growthFactor, radius: radius);
}

/// This effect adds a metaball for every cursor / touch and then follows that cursor / touch around
class MetaballsFollowMouseEffect extends MetaballsEffect {
  /// The amount the metaballs movement gets smoothed
  final double smoothing;

  /// The size of the following metaballs where 0 is the minBallRadius and 1 is the maxBallRadius
  final double? radius;

  /// The amount the metaballs grow relative to their movement speed
  final double growthFactor;

  MetaballsFollowMouseEffect({
    this.smoothing = 1,
    this.radius,
    this.growthFactor = 1,
  })  : assert(smoothing >= 0),
        assert(growthFactor >= 0),
        assert(radius == null || radius >= 0);

  @override
  bool operator ==(Object other) =>
      other is MetaballsFollowMouseEffect &&
      other.smoothing == smoothing &&
      other.radius == radius &&
      other.growthFactor == growthFactor;

  @override
  int get hashCode => Object.hash(smoothing, radius, growthFactor);
}

/// This effect makes all metaballs speedup relative to how fast you move your mouse or swipe on your touchscreen
class MetaballsSpeedupEffect extends MetaballsEffect {
  /// The amount the metaballs speed up relative to the mouse / swipe speed
  final double speedup;

  MetaballsSpeedupEffect({this.speedup = 1}) : assert(speedup > 0);

  @override
  bool operator ==(Object other) => other is MetaballsSpeedupEffect && other.speedup == speedup;

  @override
  int get hashCode => speedup.hashCode;
}

/// This effect increases the radius of all metaballs based on how close they are to the mouse cursor or a touch
class MetaballsMouseGrowEffect extends MetaballsEffect {
  /// The radius around the mouse / touch in which the metaballs get scaled up
  final double radius;

  /// The amount by which the metaballs increase in size
  final double growthFactor;

  /// The amount the movement gets smoothed
  final double smoothing;

  MetaballsMouseGrowEffect({
    this.radius = 0.5,
    this.growthFactor = 0.5,
    this.smoothing = 1,
  })  : assert(smoothing >= 0 && smoothing <= 1),
        assert(radius > 0),
        assert(growthFactor > 0);

  @override
  bool operator ==(Object other) =>
      other is MetaballsMouseGrowEffect &&
      other.growthFactor == growthFactor &&
      other.radius == radius &&
      other.smoothing == smoothing;

  @override
  int get hashCode => Object.hash(growthFactor, radius, smoothing);
}

/// This effect makes all metaballs increase and then decrease their radius in an outgoing ripple from a tab / mouse click
class MetaballsTabRippleEffect extends MetaballsEffect {
  /// The speed of the ripple effect
  final double speed;

  /// The the ripple width
  final double width;

  /// The amount by which the metaballs grow
  final double growthFactor;

  /// The time before the ripple is completely faded away
  final Duration fade;

  MetaballsTabRippleEffect(
      {this.speed = 1, this.width = 1, this.growthFactor = 1, this.fade = const Duration(milliseconds: 1200)})
      : assert(speed > 0),
        assert(width > 0),
        assert(growthFactor > 0);

  @override
  bool operator ==(Object other) =>
      other is MetaballsTabRippleEffect &&
      other.speed == speed &&
      other.width == width &&
      other.growthFactor == growthFactor &&
      other.fade == fade;

  @override
  int get hashCode => Object.hash(speed, width, growthFactor, fade);
}

class _Ripple {
  final Offset origin;
  final double creationTime;

  _Ripple({
    required this.creationTime,
    required this.origin,
  });
}

class _Pointer {
  final double created;
  Offset position;
  Offset delta;
  double timeDeleted = -1;
  PointerDeviceKind kind;

  _Pointer({
    required this.created,
    required this.delta,
    required this.position,
    required this.kind,
  });
}

class _FollowEntry {
  Offset position;
  double radius;
  double random;
  _Pointer pointer;

  _FollowEntry({
    required this.position,
    required this.radius,
    required this.random,
    required this.pointer,
  });
}

class _MetaBall {
  late double _x;
  late double _y;
  late double _vx;
  late double _vy;
  late double _r;
  late double _vxm;
  late double _vym;
  double _rm = 1;

  _MetaBall() {
    final random = Random();
    _x = random.nextDouble();
    _y = random.nextDouble();
    _vxm = random.nextBool() ? 1 : -1;
    _vym = random.nextBool() ? 1 : -1;
    _vx = random.nextDouble();
    _vy = random.nextDouble();
    _r = random.nextDouble();
  }

  MetaBallComputedState update({
    required double minRadius,
    required double maxRadius,
    required Size canvasSize,
    required double frameTime,
    required double time,
    required double speedMultiplier,
    required double bounceStiffness,
    required List<_Ripple> ripples,
    required List<_Pointer> pointers,
    MetaballsEffect? effect,
  }) {
    assert(maxRadius >= minRadius);

    // update the meta ball position
    final speed = frameTime * speedMultiplier * sqrt(canvasSize.aspectRatio);
    _x += ((_vx * _vxm) / canvasSize.aspectRatio) * 0.07 * speed;
    _y += (_vy * _vym) * 0.07 * speed;
    final m = speed * 100 * bounceStiffness;
    if (_x < 0) {
      _vxm += m * -_x;
    } else if (_x > 1) {
      _vxm -= m * (_x - 1);
    } else if (_vxm > 0 && _vxm < 1) {
      _vxm += m;
    } else if (_vxm < 0 && _vxm > -1) {
      _vxm -= m;
    }
    if (_y < 0) {
      _vym += m * -_y;
    } else if (_y > 1) {
      _vym -= m * (_y - 1);
    } else if (_vym > 0 && _vym < 1) {
      _vym += m;
    } else if (_vym < 0 && _vym > -1) {
      _vym -= m;
    }
    if (_vxm > 1) {
      _vxm = 1;
    } else if (_vxm < -1) {
      _vxm = -1;
    }
    if (_vym > 1) {
      _vym = 1;
    } else if (_vym < -1) {
      _vym = -1;
    }

    // transform the local state relative to canvas
    final scale = sqrt(canvasSize.width * canvasSize.height) / 1000;
    double r = (((maxRadius - minRadius) * _r) + minRadius) * scale;
    final d = r * 2;
    final x = ((canvasSize.width - d) * _x) + r;
    final y = ((canvasSize.height - d) * _y) + r;

    // apply effect transformations
    if (effect is MetaballsMouseGrowEffect) {
      double target = 1;
      for (final pointer in pointers) {
        final dx = pointer.position.dx - x;
        final dy = pointer.position.dy - y;
        final newTarget = 1 +
            effect.growthFactor -
            ((sqrt(dx * dx + dy * dy) / (canvasSize.shortestSide * effect.radius)) * effect.growthFactor);
        if (newTarget > target) target = newTarget;
      }
      _rm += (target - _rm) * frameTime * (1 / (effect.smoothing / 5));
      r *= _rm;
    } else if (effect is MetaballsTabRippleEffect) {
      double smooth(double t) => (sin((pi / 2) * ((t * 2) - 1)) / 2) + 0.5;
      for (final ripple in ripples) {
        final timeElapsed = time - ripple.creationTime;
        final timeMultiplier = 1 - smooth(timeElapsed / (effect.fade.inMilliseconds / 1000));

        final dx = ripple.origin.dx - x;
        final dy = ripple.origin.dy - y;
        final distInverted = max(0, 1 - (sqrt(dx * dx + dy * dy) / canvasSize.shortestSide));
        final scaledWidth = (1 / effect.width) * 5;
        final distAndTime = ((distInverted - 1) * scaledWidth) + (timeElapsed * effect.speed * 5);
        final target = smooth(max(0, distAndTime > 1 ? 2 - distAndTime : distAndTime));
        r *= 1 + (target * effect.growthFactor) * timeMultiplier;
      }
    }

    return MetaBallComputedState(x: x, y: y, r: r);
  }
}

/// A metaballs implementation for flutter using webgl on the web and the shader package on other devices
class Metaballs extends StatefulWidget {
  /// The color of the metaballs
  final Color color;

  /// A gradient for coloring the metaballs, overwrites color
  final Gradient? gradient;

  /// A multiplier to indicate the radius of the glow
  final double glowRadius;

  /// The brightness of the glow around the ball
  final double glowIntensity;

  /// The minimum size of a ball
  final double minBallRadius;

  /// The maximum size of a ball
  final double maxBallRadius;

  /// A multiplier of the ball movement speed
  final double speedMultiplier;

  /// A multiplier to change the speed at which balls change direction
  final double bounceStiffness;

  /// A widget to be placed on top of the Metaballs widget
  final Widget? child;

  /// The duration of the color changing animation
  final Duration animationDuration;

  /// The amount of metaballs
  final int metaballs;

  /// The animated effect applied to the metaballs
  final MetaballsEffect? effect;

  const Metaballs({
    Key? key,
    this.color = const Color(0xff4285F4),
    this.gradient,
    this.animationDuration = const Duration(milliseconds: 200),
    this.speedMultiplier = 1,
    this.minBallRadius = 15,
    this.maxBallRadius = 40,
    this.glowRadius = 0.7,
    this.glowIntensity = 0.6,
    this.bounceStiffness = 3,
    this.metaballs = 40,
    this.child,
    this.effect,
  })  : assert(speedMultiplier >= 0),
        assert(bounceStiffness > 0),
        assert(maxBallRadius >= minBallRadius),
        assert(minBallRadius >= 0),
        assert(glowRadius >= 0 && glowRadius <= 1),
        assert(glowIntensity >= 0 && glowIntensity <= 1),
        assert(metaballs > 0 && metaballs <= 128),
        super(key: key);

  @override
  State<Metaballs> createState() => _MetaBallsState();
}

class _MetaBallsState extends State<Metaballs> with TickerProviderStateMixin {
  late List<_MetaBall> _metaBalls;
  late AnimationController _controller;
  final List<_Ripple> _ripples = [];
  final Map<int, _Pointer> _pointers = {};
  final List<_FollowEntry> _pointerFollowerMap = [];
  final GlobalKey _key = GlobalKey();
  final Random _random = Random();

  double _lastFrame = 0;

  @override
  void initState() {
    _controller = AnimationController.unbounded(duration: const Duration(days: 365), vsync: this)
      ..animateTo(const Duration(days: 365).inSeconds.toDouble());

    _metaBalls = List.generate(widget.metaballs, (_) => _MetaBall());
    super.initState();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  void didUpdateWidget(covariant Metaballs oldWidget) {
    if (_metaBalls.length != widget.metaballs) {
      final difference = widget.metaballs - _metaBalls.length;
      if (difference < 0) {
        _metaBalls.removeRange(_metaBalls.length + difference, _metaBalls.length);
      } else {
        for (int i = 0; i < difference; i++) {
          _metaBalls.add(_MetaBall());
        }
      }
    }
    super.didUpdateWidget(oldWidget);
  }

  @override
  Widget build(BuildContext context) {
    Widget resultWidget = LayoutBuilder(builder: (context, constraints) {
      final size = Size(constraints.maxWidth, constraints.maxHeight);
      final pixelRatio = MediaQuery.of(context).devicePixelRatio;

      return SizedBox.expand(
        child: AnimatedBuilder(
          animation: _controller,
          builder: (context, child) {
            final time = _controller.value;
            final frameTime = min(time - _lastFrame, 0.25);
            _lastFrame = time;
            double speedMultiplier = widget.speedMultiplier;

            final effect = widget.effect;

            if (effect is MetaballsTabRippleEffect) {
              _ripples.removeWhere((ripple) => (time - ripple.creationTime) > (effect.fade.inMilliseconds / 1000));
            } else if (effect is MetaballsSpeedupEffect) {
              final averageDelta =
                  _pointers.values.fold<double>(0, (total, accumulator) => accumulator.delta.distance + total);
              double multiplier = 1 + ((averageDelta / size.shortestSide) * effect.speedup * 50) / _pointers.length;
              if (multiplier.isNaN) multiplier = 1;
              speedMultiplier *= multiplier;
            }

            final computedMetaballs = _metaBalls
                .map((metaball) => metaball.update(
                      canvasSize: size,
                      frameTime: frameTime,
                      maxRadius: widget.maxBallRadius,
                      minRadius: widget.minBallRadius,
                      speedMultiplier: speedMultiplier,
                      bounceStiffness: widget.bounceStiffness,
                      effect: widget.effect,
                      ripples: _ripples,
                      pointers: _pointers.values.toList(),
                      time: time,
                    ))
                .toList();

            if (effect is MetaballsFollowMouseEffect) {
              int i = 0;
              for (final follower in _pointerFollowerMap.toList()) {
                if (i++ == 9) break;
                final pointer = follower.pointer;

                final oldPosition = follower.position;

                if (effect.smoothing == 0) {
                  follower.position = pointer.position;
                } else {
                  follower.position = Offset(
                    follower.position.dx +
                        (pointer.position.dx - follower.position.dx) * frameTime * (7.5 / effect.smoothing),
                    follower.position.dy +
                        (pointer.position.dy - follower.position.dy) * frameTime * (7.5 / effect.smoothing),
                  );
                }

                final scale = sqrt(size.width * size.height) / 1000;

                double r = (((widget.maxBallRadius - widget.minBallRadius) * (effect.radius ?? follower.random)) +
                        widget.minBallRadius) *
                    scale;

                if (pointer.timeDeleted > 0) {
                  final timeSinceDelete = time - pointer.timeDeleted;
                  if (timeSinceDelete > 0.15) {
                    _pointerFollowerMap.remove(follower);
                    continue;
                  } else {
                    r *= 1 - (timeSinceDelete / 0.15);
                  }
                } else {
                  final timeSinceCreated = time - pointer.created;
                  if (timeSinceCreated < 0.15) {
                    r *= timeSinceCreated / 0.15;
                  }
                }

                if (effect.growthFactor > 0) {
                  final dx = follower.position.dx - oldPosition.dx;
                  final dy = follower.position.dy - oldPosition.dy;
                  final moved = sqrt(dx * dx + dy * dy);
                  final target = r * (1 + ((moved / 50) * effect.growthFactor));
                  follower.radius += (target - follower.radius) * frameTime * (5 + (effect.smoothing * 20));
                } else {
                  follower.radius = r;
                }

                computedMetaballs
                    .add(MetaBallComputedState(x: follower.position.dx, y: follower.position.dy, r: follower.radius));
              }
            }

            for (final pointer in _pointers.values) {
              pointer.delta = const Offset(0, 0);
            }

            return MetaballsRenderer(
                key: _key,
                time: time,
                gradient: widget.gradient,
                color: widget.color,
                animationDuration: widget.animationDuration,
                glowIntensity: widget.glowIntensity,
                glowRadius: widget.glowRadius,
                size: size,
                pixelRatio: pixelRatio,
                metaballs: computedMetaballs);
          },
        ),
      );
    });

    if (widget.child != null) {
      resultWidget = Stack(
        children: [resultWidget, widget.child!],
      );
    }

    if (widget.effect != null) {
      resultWidget = _CombinedListener(
          onPress: (event) {
            if (widget.effect is MetaballsTabRippleEffect) {
              _ripples.add(_Ripple(creationTime: _controller.value, origin: event.localPosition));
            }
          },
          onMove: (PointerEvent event) {
            if (event.delta.distance > 0 && _pointers.containsKey(event.pointer)) {
              _pointers[event.pointer]!
                ..delta = event.delta
                ..position = event.position;
            }
          },
          onAdd: (PointerEvent event) {
            if (!_pointers.containsKey(event.pointer)) {
              final pointer = _pointers[event.pointer] = _Pointer(
                  created: _controller.value, delta: event.delta, position: event.localPosition, kind: event.kind);
              if (widget.effect is MetaballsFollowMouseEffect) {
                _pointerFollowerMap.add(_FollowEntry(
                    position: pointer.position, radius: 0, random: _random.nextDouble(), pointer: pointer));
              }
            }
          },
          onRemove: (event) {
            _pointers.remove(event.pointer)?.timeDeleted = _controller.value;
          },
          child: resultWidget);
    }

    return resultWidget;
  }
}

class _CombinedListener extends StatefulWidget {
  final void Function(PointerEvent event)? onMove;
  final void Function(PointerEvent event)? onAdd;
  final void Function(PointerEvent event)? onRemove;
  final void Function(PointerEvent event)? onPress;
  final Widget? child;

  const _CombinedListener({
    Key? key,
    this.onMove,
    this.onAdd,
    this.onRemove,
    this.onPress,
    this.child,
  }) : super(key: key);

  @override
  State<_CombinedListener> createState() => _CombinedListenerState();
}

class _CombinedListenerState extends State<_CombinedListener> {
  PointerEvent? _mouseEvent;

  @override
  Widget build(BuildContext context) {
    return MouseRegion(
      onExit: (event) {
        if (_mouseEvent != null) {
          widget.onRemove?.call(event);
          _mouseEvent = null;
        }
      },
      child: Listener(
        onPointerDown: (event) {
          if (event.kind == PointerDeviceKind.touch) {
            widget.onAdd?.call(event);
          }
          widget.onPress?.call(event);
        },
        onPointerMove: (event) {
          if (_mouseEvent != null && event.kind == PointerDeviceKind.mouse) {
            widget.onMove?.call(event.copyWith(pointer: _mouseEvent!.pointer));
          } else {
            widget.onMove?.call(event);
          }
        },
        onPointerCancel: widget.onRemove,
        onPointerUp: widget.onRemove,
        onPointerHover: (event) {
          if (event.kind == PointerDeviceKind.mouse) {
            if (_mouseEvent == null) {
              widget.onAdd?.call(event);
            } else {
              widget.onMove?.call(event);
            }
            _mouseEvent = event;
          }
        },
        child: widget.child,
      ),
    );
  }
}
