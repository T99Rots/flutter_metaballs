import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:metaball_demo/widgets/better_dropdown.dart';
import 'package:metaball_demo/widgets/card_with_title.dart';
import 'package:metaball_demo/widgets/drawer/cards/effects/cubit/effects_cubit.dart';
import 'package:metaball_demo/widgets/drawer/cards/effects/views/attract_effect_view.dart';
import 'package:metaball_demo/widgets/drawer/cards/effects/views/follow_effect_view.dart';
import 'package:metaball_demo/widgets/drawer/cards/effects/views/grow_effect_view.dart';
import 'package:metaball_demo/widgets/drawer/cards/effects/views/ripple_effect_view.dart';
import 'package:metaball_demo/widgets/drawer/cards/effects/views/speedup_effect_view.dart';

class EffectsCard extends StatelessWidget {
  const EffectsCard({super.key});

  @override
  Widget build(BuildContext context) {
    final EffectState state = context.watch<EffectsCubit>().state;

    return CardWithTitle.list(
      title: 'Effects',
      child: Column(
        children: <Widget>[
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 15),
            child: BetterDropdown<EffectType>(
              label: 'Select effect type',
              items: const <DropdownMenuItem<EffectType>>[
                DropdownMenuItem<EffectType>(
                  value: EffectType.none,
                  child: Text('None'),
                ),
                DropdownMenuItem<EffectType>(
                  value: EffectType.attract,
                  child: Text('Attract effect'),
                ),
                DropdownMenuItem<EffectType>(
                  value: EffectType.follow,
                  child: Text('Follow effect'),
                ),
                DropdownMenuItem<EffectType>(
                  value: EffectType.grow,
                  child: Text('Grow effect'),
                ),
                DropdownMenuItem<EffectType>(
                  value: EffectType.ripple,
                  child: Text('Ripple effect'),
                ),
                DropdownMenuItem<EffectType>(
                  value: EffectType.speedup,
                  child: Text('Speedup effect'),
                ),
              ],
              value: state.type,
              onChange: (EffectType? value) {
                if (value == null) {
                  return;
                }

                context.read<EffectsCubit>().setEffectType(value);
              },
            ),
          ),
          if (state is NoEffectState)
            const SizedBox()
          else
            Padding(
              padding: const EdgeInsets.only(top: 20),
              child: switch (state) {
                AttractEffectState() => AttractEffectView(state: state),
                FollowEffectState() => FollowEffectView(state: state),
                GrowEffectState() => GrowEffectView(state: state),
                RippleEffectState() => RippleEffectView(state: state),
                SpeedupEffectState() => SpeedupEffectView(state: state),
                _ => const SizedBox(),
              },
            )
        ],
      ),
    );
  }
}

enum EffectType {
  attract,
  follow,
  grow,
  ripple,
  speedup,
  none,
}
