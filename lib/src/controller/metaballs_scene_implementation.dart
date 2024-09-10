import 'package:flutter/scheduler.dart';
import 'package:flutter/widgets.dart';
import 'package:metaballs/src/interfaces/_interfaces.dart';

typedef MetaballsVisitor = void Function(Metaball metaball);

class MetaballsSceneImplementation with ChangeNotifier {
  MetaballsSceneImplementation({
    required TickerProvider vsync,
  }) {
    _ticker = vsync.createTicker(_tick);
  }

  late final Ticker _ticker;

  final List<Metaball> _metaballs = <Metaball>[];

  void visitMetaballs(MetaballsVisitor visitor) {
    for (final Metaball metaball in _metaballs) {
      visitor(metaball);
    }
  }

  void _tick(Duration elapsed) {
    notifyListeners();
  }

  @override
  void dispose() {
    _ticker.dispose();
    super.dispose();
  }
}
