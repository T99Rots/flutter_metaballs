import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/animation.dart';
import 'package:meta/meta.dart';
import 'package:metaball_demo/widgets/drawer/cards/effects/effects_card.dart';
import 'package:metaballs/metaballs.dart';

part 'effects_state.dart';

class EffectsCubit extends Cubit<EffectState> {
  EffectsCubit() : super(const NoEffectState());

  void setEffectType(EffectType type) {
    emit(switch (type) {
      EffectType.attract => const AttractEffectState(
          effect: AttractEffect(),
        ),
      EffectType.follow => const FollowEffectState(
          effect: FollowEffect(),
        ),
      EffectType.grow => const GrowEffectState(
          effect: GrowEffect(),
        ),
      EffectType.ripple => const RippleEffectState(
          effect: RippleEffect(),
        ),
      EffectType.speedup => const SpeedupEffectState(
          effect: SpeedupEffect(),
        ),
      EffectType.none => const NoEffectState(),
    });
  }

  void setDuration(Duration newValue) {
    final EffectState state = this.state;
    if (state is! FollowEffectState) {
      return;
    }

    emit(
      FollowEffectState(
        effect: state.effect.copyWith(duration: newValue),
      ),
    );
  }

  void setCurve(Curve newValue) {
    final EffectState state = this.state;
    if (state is! FollowEffectState) {
      return;
    }

    emit(
      FollowEffectState(
        effect: state.effect.copyWith(curve: newValue),
      ),
    );
  }

  void setRadius(double newValue) {
    final EffectState state = this.state;
    if (state is! FollowEffectState) {
      return;
    }

    emit(
      FollowEffectState(
        effect: state.effect.copyWith(radius: newValue),
      ),
    );
  }

  void setPointerSmoothing(double newValue) {
    final EffectState state = this.state;
    if (state is! FollowEffectState) {
      return;
    }

    emit(
      FollowEffectState(
        effect: state.effect.copyWith(pointerSmoothing: newValue),
      ),
    );
  }
}
