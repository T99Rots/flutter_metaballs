import 'package:metaballs/src/effects/interface/metaballs_effect.dart';

class DefaultEffect extends MetaballsEffect {
  const DefaultEffect();

  @override
  DefaultEffectState createState() => DefaultEffectState();
}

class DefaultEffectState extends MetaballsEffectState<DefaultEffect> {}
