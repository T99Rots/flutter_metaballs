import 'package:flutter/scheduler.dart';
import 'package:flutter/widgets.dart';
import 'package:metaballs/src/controller/_controller.dart';
import 'package:metaballs/src/interfaces/_interfaces.dart';

class DefaultMetaballsController with ChangeNotifier implements MetaballsController {
  DefaultMetaballsController({
    required TickerProvider vsync,
    this.physics = const DefaultMetaballsPhysics(),
  }) {
    _ticker = vsync.createTicker(_onTick);
  }

  late final Ticker _ticker;
  final MetaballsPhysics physics;

  @override
  void dispose() {
    _ticker.dispose();
    super.dispose();
  }

  void _onTick(Duration elapsed) {
    notifyListeners();
  }
}
