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
  final Color color1;
  final Color color2;
  final double glowRadius;
  final double glowIntensity;
  final double minBallRadius;
  final double maxBallRadius;
  final double speedMultiplier;
  final double bounceStiffness;
  final Alignment gradientAlignment;
  final Widget? child;
  final Duration colorChangeDuration;

  const Metaballs({
    Key? key,
    required this.color1,
    required this.color2,
    this.colorChangeDuration = const Duration(milliseconds: 200),
    this.speedMultiplier = 1,
    this.minBallRadius = 15,
    this.maxBallRadius = 40,
    this.glowRadius = 0.7,
    this.glowIntensity = 0.6,
    this.bounceStiffness = 3,
    this.gradientAlignment = Alignment.bottomRight,
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
  late Color _startColor1;
  late Color _startColor2;
  late Color _color1;
  late Color _color2;

  double _lastFrame = 0;

  @override
  void initState() {
    _startColor1 = _color1 = widget.color1;
    _startColor2 = _color2 = widget.color2;
    _colorController = AnimationController(vsync: this, duration: widget.colorChangeDuration);
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
  void didUpdateWidget(covariant Metaballs oldWidget) {
    if(oldWidget.color1 != widget.color1 || oldWidget.color2 != widget.color2) {
      if(_colorController.isAnimating) {
        _startColor1 = Color.lerp(_startColor1, _color1, _colorController.value)!;
        _startColor2 = Color.lerp(_startColor2, _color2, _colorController.value)!;
      } else {
        _startColor1 = _color1;
        _startColor2 = _color2;
      }
      _colorController.forward(from: 0);
      _color1 = widget.color1;
      _color2 = widget.color2;
    }
    super.didUpdateWidget(oldWidget);
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

              return AnimatedBuilder(
                animation: _controller,
                builder: (context, child) {
                  final currentFrame = _controller.value;
                  final frameTime = min(currentFrame - _lastFrame, 0.25);
                  _lastFrame = currentFrame;

                  final computed = _metaBalls.map((metaBall) => metaBall.update(
                    canvasSize: size,
                    frameTime: frameTime,
                    maxRadius: widget.maxBallRadius,
                    minRadius: widget.minBallRadius,
                    speedMultiplier: widget.speedMultiplier,
                    bounceStiffness: widget.bounceStiffness
                  )).toList();

                  Color color1 = _color1;
                  Color color2 = _color2;

                  if(_colorController.isAnimating) {
                    color1 = Color.lerp(_startColor1, color1, _colorController.value)!;
                    color2 = Color.lerp(_startColor2, color2, _colorController.value)!;
                  }

                  return SizedBox.expand(
                    child: CustomPaint(
                      painter: _MetaBallPainter(
                        color1: color1,
                        color2: color2,
                        fragmentProgram: snapshot.data!,
                        metaBalls: computed,
                        glowRadius: widget.glowRadius,
                        glowIntensity: widget.glowIntensity,
                        size: size,
                        gradientAlignment: widget.gradientAlignment
                      ),
                    ),
                  );
                },
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

/// Customer painter that makes use of the shader
class _MetaBallPainter extends CustomPainter {
  _MetaBallPainter({
    required this.fragmentProgram,
    required this.color1,
    required this.color2,
    required this.glowRadius,
    required this.glowIntensity,
    required this.size,
    required this.metaBalls, 
    required this.gradientAlignment
  });

  final FragmentProgram fragmentProgram;
  final Color color1;
  final Color color2;
  final Size size;
  final List<_MetaBallComputedState> metaBalls;
  final double glowRadius;
  final double glowIntensity;
  final Alignment gradientAlignment;

  @override
  void paint(Canvas canvas, Size size) {
    final List<double> doubles = [
      sqrt(size.width * size.width + size.height * size.height),
      color1.red / 255.0,
      color1.green / 255.0,
      color1.blue / 255.0,
      color2.red / 255.0,
      color2.green / 255.0,
      color2.blue / 255.0,
      size.width,
      size.height,
      min(max(1-glowRadius, 0), 1),
      min(max(glowIntensity, 0), 1),
      size.width * ((gradientAlignment.x + 1) / 2),
      size.height * ((gradientAlignment.y + 1) / 2)
    ];

    for(final _MetaBallComputedState metaBall in metaBalls) {
      doubles.add(metaBall.x);
      doubles.add(metaBall.y);
      doubles.add(metaBall.r);
    }

    final paint = Paint()
      ..shader = fragmentProgram.shader(
        floatUniforms: Float32List.fromList(doubles),
      );

    canvas.drawRect(Rect.fromLTWH(0, 0, size.width, size.height), paint);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => true;
}