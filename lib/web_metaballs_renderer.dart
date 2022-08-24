library metaballs;
import 'dart:html';
import 'dart:math';
import 'dart:typed_data';
import 'package:metaballs/web_metaballs_api.dart';

import 'dart_ui_shim.dart' as ui;

import 'package:flutter/widgets.dart';
import 'package:metaballs/metaballs.dart';

int counter = 0;
bool scriptInjected = false;

class MetaballsRenderer extends StatefulWidget {
  final double time;
  final Gradient? gradient;
  final Color color;
  final List<MetaBallComputedState> metaballs;
  final double glowRadius;
  final double glowIntensity;
  final Duration animationDuration;
  final Size size;

  const MetaballsRenderer({
    Key? key,
    required this.size,
    required this.time,
    required this.color,
    required this.metaballs,
    required this.glowRadius,
    required this.glowIntensity,
    required this.animationDuration,
    this.gradient,
  }) : super(key: key);

  @override
  State<MetaballsRenderer> createState() => _MetaballsRendererState();
}

class _MetaballsRendererState extends State<MetaballsRenderer> {
  late CanvasElement _canvasElement;
  late String _id;
  late FLutterMetaballsWebRenderer _renderer;
  
  @override
  void initState() {
    if(!scriptInjected) {
      scriptInjected = true;
      document.body!.append(ScriptElement()
        ..src = 'assets/packages/metaballs/assets/metaballs_renderer.js'
        ..type = 'application/javascript'
        ..defer = true
      );
    }

    _canvasElement = CanvasElement();
    _id = 'metaballs/instance:$counter';
    counter++;
    _renderer = FLutterMetaballsWebRenderer(_canvasElement);
    _canvasElement.width = widget.size.width.floor();
    _canvasElement.height = widget.size.height.floor();

    ui.platformViewRegistry.registerViewFactory(
      _id,
      (int viewId) => _canvasElement
    );

    super.initState();
  }

  void _draw() {
    final List<Vec3> metaballs = [];

    for(final metaball in widget.metaballs) {
      metaballs.add(Vec3(
        metaball.x,
        metaball.y,
        metaball.r,
      ));
    }

    late int gradientType;

    final List<Vec4> colors = [];
    final List<double> stops = [];
    int tileMode = 0;
    Vec2 gradientStart = Vec2(0, 0);
    Vec2 gradientEnd = Vec2(0, 0);
    double radius = 0;
    double bias = 0;
    double scale = 0;

    if(widget.gradient == null) {
      gradientType = 3;
      colors.add(Vec4(
        widget.color.red / 255,
        widget.color.green / 255,
        widget.color.blue / 255,
        widget.color.alpha / 255
      ));
    } else {
      final gradient = widget.gradient!;

      final hasStops = gradient.stops == null;

      for(int i = 0; i < gradient.colors.length; i++) {
        final color = gradient.colors[i];
        colors.add(Vec4(
          color.red / 255,
          color.green / 255,
          color.blue / 255,
          color.alpha / 255
        ));
        if(hasStops) {
          stops.add(gradient.stops![i]);
        } else {
          stops.add(min(i / (gradient.stops!.length - 1), 1));
        }
      }

      int mapTileMode(TileMode tileMode) {
        switch(tileMode) {
          case TileMode.clamp:
            return 0;
          case TileMode.repeated:
            return 1;
          case TileMode.mirror:
            return 2;
          case TileMode.decal:
            return 3;
        }
      }

      final shortestSide = min(widget.size.width, widget.size.height);

      Vec2 convertAlignment (AlignmentGeometry alignment) {
        final resolved = alignment.resolve(TextDirection.ltr);
        return Vec2(
          (widget.size.width * ((resolved.x * 0.5) + 0.5)),
          (widget.size.height * ((-resolved.y * 0.5) + 0.5))
        );
      }

      if(gradient is LinearGradient) {
        tileMode = mapTileMode(gradient.tileMode);
        gradientType = 0;
        gradientStart = convertAlignment(gradient.begin);
        gradientEnd = convertAlignment(gradient.end);
      } else if(gradient is RadialGradient) {
        tileMode = mapTileMode(gradient.tileMode);
        gradientStart = convertAlignment(gradient.center);
        radius = shortestSide * gradient.radius;
        gradientType = 1;
      } else if(gradient is SweepGradient) {
        tileMode = mapTileMode(gradient.tileMode);
        gradientStart = convertAlignment(gradient.center);
        bias = -(gradient.startAngle / 360);
        scale = 1 / ((gradient.endAngle / 360) + bias);
        gradientType = 2;
      }
    }

    _renderer.draw(
      metaballs,
      min(max(1-widget.glowRadius, 0), 1),
      min(max(widget.glowIntensity, 0), 1),
      widget.time,
      gradientType,
      colors,
      stops,
      tileMode,
      gradientStart,
      gradientEnd,
      radius,
      bias,
      scale
    );
  }

  @override
  void didUpdateWidget(covariant MetaballsRenderer oldWidget) {
    _draw();
    _canvasElement.width = widget.size.width.floor();
    _canvasElement.height = widget.size.height.floor();
    super.didUpdateWidget(oldWidget);
  }

  @override
  Widget build(BuildContext context) {
    return HtmlElementView(viewType: _id);
  }
}