import 'package:flutter/widgets.dart';
import 'package:metaballs/src/controller/_controller.dart';

abstract interface class MetaballsController implements Listenable {
  factory MetaballsController({
    required TickerProvider vsync,
  }) = DefaultMetaballsController;

  void dispose();
}
