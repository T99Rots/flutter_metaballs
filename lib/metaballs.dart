library metaballs;
import 'dart:math';

import 'package:flutter/widgets.dart';
import 'package:metaballs/native_metaballs_renderer.dart'
  if (dart.library.html) 'package:metaballs/web_metaballs_renderer.dart';
import 'package:metaballs/types.dart';

abstract class MetaballsEffect {
  MetaballsEffect();

  /// An effect that increases the size of the metaballs in an outgoing ripple when touching the screen
  factory MetaballsEffect.ripple({
    double speed = 1,
    double width = 1,
    double growthFactor = 1,
    Duration fade = const Duration(seconds: 2)
  }) => MetaballsTabRippleEffect(
    fade: fade,
    growthFactor: growthFactor,
    speed: speed,
    width: width
  );

  /// An effect that increases the size of the metaballs around the mouse cursor
  factory MetaballsEffect.grow({
    double radius = 0.5,
    double growthFactor = 0.5,
    double smoothing = 1,
  }) => MetaballsMouseGrowEffect(
    radius: radius,
    growthFactor: growthFactor,
    smoothing: smoothing,
  );

  /// An effect that speeds up the movement of the metaballs when the mouse moves relative to how fast the mouse moves
  factory MetaballsEffect.speedup({
    double speedup = 1
  }) => MetaballsSpeedupEffect(
    speedup: speedup
  );

  /// Effect with which a single metaball will follow the cursor around the screen
  factory MetaballsEffect.follow({
    double smoothing = 1,
    double growthFactor = 1,
    double? radius
  }) => MetaballsFollowMouseEffect(
    smoothing: smoothing,
    growthFactor: growthFactor,
    radius: radius
  );
}

/// Effect with which a single metaball will follow the cursor around the screen
class MetaballsFollowMouseEffect extends MetaballsEffect {
  /// A smoothing that is applied to the movement of the following metaball
  final double smoothing;

  /// The size of the following metaball where 0 is the minBallRadius and 1 is the maxBallRadius
  final double? radius;

  /// The multiplier of the growing effect of the following metaball when speed
  final double growthFactor;

  MetaballsFollowMouseEffect({
    this.smoothing = 1,
    this.radius,
    this.growthFactor = 1
  }):
    assert(smoothing >= 0),
    assert(growthFactor >= 0),
    assert(radius == null || radius >= 0);
}

/// An effect that speeds up the movement of the metaballs when the mouse moves relative to how fast the mouse moves
class MetaballsSpeedupEffect extends MetaballsEffect {
  /// A multiplier applied to the speedup effect, increasing it will increase the speed of the metaballs more when the mouse moves
  final double speedup;

  MetaballsSpeedupEffect({
    this.speedup = 1
  }): assert(speedup > 0);
}

/// An effect that increases the size of the metaballs around the mouse cursor
class MetaballsMouseGrowEffect extends MetaballsEffect {
  /// The radius around the mouse in which the metaballs get scaled
  final double radius;

  /// The multiplier of the growing effect of the metaballs
  final double growthFactor;

  /// The amount the movement gets smoothed
  final double smoothing;

  MetaballsMouseGrowEffect({
    this.radius = 0.5,
    this.growthFactor = 0.5,
    this.smoothing = 1,
  }):
    assert(smoothing >= 0 && smoothing <= 1),
    assert(radius > 0),
    assert(growthFactor > 0);
}

/// An effect that increases the size of the metaballs in an outgoing ripple when touching the screen
class MetaballsTabRippleEffect extends MetaballsEffect {
  /// The multiplier of the speed of the ripple effect
  final double speed;

  /// The multiplier of the ripple width
  final double width;

  /// The multiplier of the growing effect of the metaballs
  final double growthFactor;

  /// The time before the ripple is completely faded away
  final Duration fade;

  MetaballsTabRippleEffect({
    this.speed = 1,
    this.width = 1,
    this.growthFactor = 1,
    this.fade = const Duration(milliseconds: 1200)
  }):
    assert(speed > 0),
    assert(width > 0),
    assert(growthFactor > 0);
}

class _Ripple {
  final Offset origin;
  final double creationTime;

  _Ripple({
    required this.creationTime,
    required this.origin,
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
    _vxm = random.nextBool()? 1: -1;
    _vym = random.nextBool()? 1: -1;
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
    required Offset mousePosition,
    required Offset mouseDelta,
    required List<_Ripple> ripples,
    required bool hovering,
    MetaballsEffect? effect,
  }) {
    assert(maxRadius >= minRadius);

    if(effect is MetaballsSpeedupEffect) {
      speedMultiplier*=1+((mouseDelta.distance / 30) * effect.speedup);
    }

    // update the meta ball position
    final speed = frameTime*speedMultiplier*sqrt(canvasSize.aspectRatio);
    _x+=((_vx * _vxm) / canvasSize.aspectRatio)*0.07*speed;
    _y+=(_vy * _vym)*0.07*speed;
    final m = speed*100*bounceStiffness;
    if(_x < 0) {
      _vxm+=m*-_x;
    } else if (_x > 1) {
      _vxm-=m*(_x-1);
    } else if (_vxm > 0 && _vxm < 1) {
      _vxm+=m;
    } else if (_vxm < 0 && _vxm > -1) {
      _vxm-=m;
    }
    if(_y < 0) {
      _vym+=m*-_y;
    } else if (_y > 1) {
      _vym-=m*(_y-1);
    } else if (_vym > 0 && _vym < 1) {
      _vym+=m;
    } else if (_vym < 0 && _vym > -1) {
      _vym-=m;
    }
    if(_vxm > 1) {
      _vxm = 1;
    } else if(_vxm < -1) {
      _vxm = -1;
    }
    if(_vym > 1) {
      _vym = 1;
    } else if(_vym < -1) {
      _vym = -1;
    }

    // transform the local state relative to canvas
    final scale = sqrt(canvasSize.width * canvasSize.height) / 1000;
    double r = (((maxRadius - minRadius) * _r) + minRadius) * scale;
    final d = r * 2;
    final x = ((canvasSize.width - d) * _x) + r;
    final y = ((canvasSize.height - d) * _y) + r;

    // apply effect transformations
    if(effect is MetaballsMouseGrowEffect) {
      double target = 1;
      if(hovering) {
        final dx = mousePosition.dx - x;
        final dy = mousePosition.dy - y;
        target = max(
          0,
          effect.growthFactor - (
            (
              sqrt(dx * dx + dy * dy) / (canvasSize.shortestSide * effect.radius)
            ) * effect.growthFactor
          )
        ) + 1;
      }
      _rm+=(target - _rm)*frameTime * (1 / (effect.smoothing / 5));
      r*=_rm;
    } else if(effect is MetaballsTabRippleEffect) {
      double smooth (double t) => (sin((pi/2)*((t*2)-1))/2)+0.5;
      for(final ripple in ripples) {
        final timeElapsed = time - ripple.creationTime;
        final timeMultiplier = 1 - smooth(timeElapsed / (effect.fade.inMilliseconds / 1000));

        final dx = ripple.origin.dx - x;
        final dy = ripple.origin.dy - y;
        final distInverted = max(0, 1 - (sqrt(dx * dx + dy * dy) / canvasSize.shortestSide));
        final scaledWidth = (1 / effect.width) * 5;
        final distAndTime = ((distInverted - 1) * scaledWidth) + (timeElapsed * effect.speed * 5);
        final target = smooth(max(0, distAndTime > 1? 2 - distAndTime: distAndTime));
        r*= 1 + (target * effect.growthFactor) * timeMultiplier;
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

  /// The animated effects applied to the metaballs 
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
  }) : 
    assert(speedMultiplier >= 0),
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
  final GlobalKey _key = GlobalKey();

  Offset _mousePosition = const Offset(0, 0);
  Offset _followPosition = const Offset(0, 0);
  Offset _mouseDelta = const Offset(0, 0);
  double _followRadius = 0;
  double _followRadiusMultiplier = 0;
  double _lastFrame = 0;
  bool _hovering = false;

  @override
  void initState() {
    _followRadiusMultiplier = Random().nextDouble();

    _controller = AnimationController.unbounded(
      duration: const Duration(days: 365), vsync: this
    )..animateTo(const Duration(days: 365).inSeconds.toDouble());

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
    if(_metaBalls.length != widget.metaballs) {
      final difference = widget.metaballs - _metaBalls.length;
      if(difference < 0) {
        _metaBalls.removeRange(_metaBalls.length + difference, _metaBalls.length);
      } else {
        for(int i = 0; i < difference; i++) {
          _metaBalls.add(_MetaBall());
        }
      }
    }
    super.didUpdateWidget(oldWidget);
  }

  @override
  Widget build(BuildContext context) {
    Widget resultWidget = LayoutBuilder(
      builder: (context, constraints) {
        final size = Size(constraints.maxWidth, constraints.maxHeight);
        final pixelRatio = MediaQuery.of(context).devicePixelRatio;

        return SizedBox.expand(
          child: AnimatedBuilder(
            animation: _controller,
            builder: (context, child) {
              final time = _controller.value;
              final frameTime = min(time - _lastFrame, 0.25);
              _lastFrame = time;
              
              final effect = widget.effect;

              if (effect is MetaballsTabRippleEffect) {
                _ripples.removeWhere((ripple) => (time - ripple.creationTime) > (effect.fade.inMilliseconds / 1000));
              }
        
              final computedMetaballs = _metaBalls.map((metaball) => metaball.update(
                canvasSize: size,
                frameTime: frameTime,
                maxRadius: widget.maxBallRadius,
                minRadius: widget.minBallRadius,
                speedMultiplier: widget.speedMultiplier,
                bounceStiffness: widget.bounceStiffness,
                mousePosition: _mousePosition,
                mouseDelta: _mouseDelta,
                effect: widget.effect,
                ripples: _ripples,
                hovering: _hovering,
                time: time
              )).toList();

              if(effect is MetaballsFollowMouseEffect) {
                final oldPosition = _followPosition;

                if(effect.smoothing == 0) {
                  _followPosition = _mousePosition;
                } else {
                  _followPosition = Offset(
                    _followPosition.dx + (_mousePosition.dx - _followPosition.dx)*frameTime * (7.5 / effect.smoothing),
                    _followPosition.dy + (_mousePosition.dy - _followPosition.dy)*frameTime * (7.5 / effect.smoothing),
                  );
                }

                final scale = sqrt(size.width * size.height) / 1000;

                double r = (
                  (
                    (widget.maxBallRadius - widget.minBallRadius) * (effect.radius ?? _followRadiusMultiplier)
                  ) + widget.minBallRadius
                ) * scale;

                if(effect.growthFactor > 0) {
                  final dx = _followPosition.dx - oldPosition.dx ;
                  final dy = _followPosition.dy - oldPosition.dy ;
                  final moved = sqrt(dx * dx + dy * dy);
                  final target = r * (1+((moved / 50) * effect.growthFactor));
                  _followRadius+=(target - _followRadius) * frameTime * (5 + (effect.smoothing * 20));
                } else {
                  _followRadius = r;
                }

                computedMetaballs.add(
                  MetaBallComputedState(
                    x: _followPosition.dx,
                    y: _followPosition.dy,
                    r: _followRadius
                  )
                );
              }

              _mouseDelta = const Offset(0,0);

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
                metaballs: computedMetaballs
              );
            },
          ),
        );
      }
    );

    if(widget.child != null) {
      resultWidget = Stack(
        children: [
          resultWidget,
          widget.child!
        ],
      );
    }

    if(
      widget.effect is MetaballsMouseGrowEffect
      || widget.effect is MetaballsSpeedupEffect
      || widget.effect is MetaballsFollowMouseEffect
    ) {
      resultWidget = MouseRegion(
        onHover: (event) {
          _mousePosition = event.localPosition;
          _mouseDelta = event.delta;
        },
        onEnter: (event) {
          _hovering = true;
        },
        onExit: (event) {
          _hovering = false;
        },
        child: resultWidget
      );
    }

    if(
      widget.effect is MetaballsTabRippleEffect
    ) {
      resultWidget = Listener(
        onPointerDown: (event) {
          _ripples.add(_Ripple(
            creationTime: _controller.value,
            origin: event.localPosition
          ));
        },
        child: resultWidget
      );
    }

    return resultWidget;
  }
}