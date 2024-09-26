import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:metaball_demo/widgets/drawer/cards/color_gradient/cubit/color_gradient_cubit.dart';
import 'package:metaball_demo/widgets/drawer/cards/debug/cubit/debug_cubit.dart';
import 'package:metaball_demo/widgets/drawer/cards/effects/cubit/effects_cubit.dart';
import 'package:metaball_demo/widgets/drawer/cards/general/cubit/general_cubit.dart';
import 'package:metaball_demo/widgets/drawer/cards/physics/cubit/physics_cubit.dart';
import 'package:metaball_demo/widgets/drawer/cards/size/cubit/size_cubit.dart';
import 'package:metaballs/metaballs.dart';

class MetaballsBuilder extends StatelessWidget {
  const MetaballsBuilder({
    super.key,
    required this.child,
  });

  final Widget child;

  @override
  Widget build(BuildContext context) {
    final ColorGradientCubitState colorState = context.watch<ColorGradientCubit>().state;
    final EffectState effectState = context.watch<EffectsCubit>().state;
    final PhysicsState physicsState = context.watch<PhysicsCubit>().state;
    final GeneralState generalState = context.watch<GeneralCubit>().state;
    final DebugState debugState = context.watch<DebugCubit>().state;
    final SizeState sizeState = context.watch<SizeCubit>().state;

    return Metaballs(
      gradient: LinearGradient(
        colors: <Color>[
          colorState.preset.startColor,
          colorState.preset.endColor,
        ],
        begin: colorState.alignment,
        end: -colorState.alignment,
      ),
      effect: effectState.effect,
      physics: physicsState.physics,
      count: generalState.count,
      glowThreshold: generalState.glowThreshold,
      glowIntensity: generalState.glowIntensity,
      effectsDebugging: debugState.effectsDebugging,
      physicsDebugging: debugState.physicsDebugging,
      size: sizeState.scaler,
      child: child,
    );
  }
}
