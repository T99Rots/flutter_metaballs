import 'package:metaballs/src/effects/interface/metaballs_effect.dart';

class OrbitEffect extends MetaballsEffect {
  const OrbitEffect();

  @override
  OrbitEffectState createState() => OrbitEffectState();
}

class OrbitEffectState extends MetaballsEffectState<OrbitEffect> {}
