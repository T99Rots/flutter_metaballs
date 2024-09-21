import 'metaballs_effect.dart';

class OrbitEffect extends MetaballsEffect {
  const OrbitEffect();

  @override
  OrbitEffectState createState() => OrbitEffectState();
}

class OrbitEffectState extends MetaballsEffectState<OrbitEffect> {}
