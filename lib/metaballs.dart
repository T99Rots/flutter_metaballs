library metaballs;
import 'dart:math';
import 'dart:typed_data';
import 'dart:ui';

import 'package:flutter/widgets.dart';
import 'metaballs_shader_sprv.dart';

class _MetaBallComputedState {
  final double x;
  final double y;
  final double r;

  _MetaBallComputedState({
    required this.x,
    required this.y,
    required this.r,
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

  _MetaBallComputedState update({
    required double minRadius,
    required double maxRadius,
    required Size canvasSize,
    required double frameTime,
    required double speedMultiplier,
    required double bounceStiffness,
  }) {
    assert(maxRadius >= minRadius);
    
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
    final r = (((maxRadius - minRadius) * _r) + minRadius) * scale;
    final d = r * 2;
    final x = ((canvasSize.width - d) * _x) + r;
    final y = ((canvasSize.height - d) * _y) + r;
    return _MetaBallComputedState(x: x, y: y, r: r);
  }
}

class Metaballs extends StatefulWidget {
  final Color color;
  final Gradient? gradient;
  final double glowRadius;
  final double glowIntensity;
  final double minBallRadius;
  final double maxBallRadius;
  final double speedMultiplier;
  final double bounceStiffness;
  final Widget? child;
  final Duration animationDuration;

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
    this.child
  }) : super(key: key);

  @override
  State<Metaballs> createState() => _MetaBallsState();
}

class _MetaBallsState extends State<Metaballs> with TickerProviderStateMixin {
  late List<_MetaBall> _metaBalls;
  late AnimationController _controller;
  late AnimationController _colorController;
  late Future<FragmentProgram> _fragmentProgramFuture;

  double _lastFrame = 0;

  @override
  void initState() {
    _controller = AnimationController.unbounded(
      duration: const Duration(days: 365), vsync: this
    )..animateTo(const Duration(days: 365).inSeconds.toDouble());

    _fragmentProgramFuture = metaballsShaderFragmentProgram().catchError((error) {
      // ignore: avoid_print
      print('shader error: $error');
    });

    _metaBalls = List.generate(40, (_) => _MetaBall());
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final futureBuilder = FutureBuilder<FragmentProgram>(
      future: _fragmentProgramFuture,
      builder: (context, snapshot) {
        if(snapshot.hasData) {
          return LayoutBuilder(
            builder: (context, constraints) {
              final size = Size(constraints.maxWidth, constraints.maxHeight);

              return SizedBox.expand(
                child: AnimatedBuilder(
                  animation: _controller,
                  builder: (context, child) {
                    final currentFrame = _controller.value;
                    final frameTime = min(currentFrame - _lastFrame, 0.25);
                    _lastFrame = currentFrame;

                    final List<double> doubles = [
                      _controller.value,
                      size.width,
                      size.height,
                      min(max(1-widget.glowRadius, 0), 1),
                      min(max(widget.glowIntensity, 0), 1),
                    ];

                    for(final metaBall in _metaBalls) {
                      final computed = metaBall.update(
                        canvasSize: size,
                        frameTime: frameTime,
                        maxRadius: widget.maxBallRadius,
                        minRadius: widget.minBallRadius,
                        speedMultiplier: widget.speedMultiplier,
                        bounceStiffness: widget.bounceStiffness
                      );
                      doubles.add(computed.x);
                      doubles.add(computed.y);
                      doubles.add(computed.r);
                    }

                    return ShaderMask(
                      blendMode: BlendMode.dstATop,
                      shaderCallback: (bounds) {
                        return snapshot.data!.shader(
                          floatUniforms: Float32List.fromList(doubles),
                        );
                      },
                      child: AnimatedContainer(
                        duration: widget.animationDuration,
                        decoration: BoxDecoration(
                          gradient: widget.gradient,
                          color: widget.color
                        ),
                      ),
                    );
                  },
                ),
              );
            }
          );
        } else {
          return Container();
        }
      }
    );
    if(widget.child != null) {
      return Stack(
        children: [
          futureBuilder,
          widget.child!,
        ],
      );
    } else {
      return futureBuilder;
    }
  }
}