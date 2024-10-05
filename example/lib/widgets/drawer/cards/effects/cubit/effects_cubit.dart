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

  // region FollowEffect

  void setFollowEffectDuration(Duration newValue) {
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

  void setFollowEffectCurve(Curve newValue) {
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

  void setFollowEffectRadius(double newValue) {
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

  void setFollowEffectPointerSmoothing(double newValue) {
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

  // endregion

  // region GrowEffect

  void setGrowEffectDuration(Duration newValue) {
    final EffectState state = this.state;
    if (state is! GrowEffectState) {
      return;
    }

    emit(
      GrowEffectState(
        effect: state.effect.copyWith(duration: newValue),
      ),
    );
  }

  void setGrowEffectCurve(Curve newValue) {
    final EffectState state = this.state;
    if (state is! GrowEffectState) {
      return;
    }

    emit(
      GrowEffectState(
        effect: state.effect.copyWith(curve: newValue),
      ),
    );
  }

  void setGrowEffectMultiplier(double newValue) {
    final EffectState state = this.state;
    if (state is! GrowEffectState) {
      return;
    }

    emit(
      GrowEffectState(
        effect: state.effect.copyWith(multiplier: newValue),
      ),
    );
  }

  void setGrowEffectRadius(double newValue) {
    final EffectState state = this.state;
    if (state is! GrowEffectState) {
      return;
    }

    emit(
      GrowEffectState(
        effect: state.effect.copyWith(radius: newValue),
      ),
    );
  }

  void setGrowEffectMovementSmoothing(double newValue) {
    final EffectState state = this.state;
    if (state is! GrowEffectState) {
      return;
    }

    emit(
      GrowEffectState(
        effect: state.effect.copyWith(pointerSmoothing: newValue),
      ),
    );
  }

  // endregion

  // region AttractEffect

  void setAttractEffectDuration(Duration newValue) {
    final EffectState state = this.state;
    if (state is! AttractEffectState) {
      return;
    }

    emit(
      AttractEffectState(
        effect: state.effect.copyWith(duration: newValue),
      ),
    );
  }

  void setAttractEffectCurve(Curve newValue) {
    final EffectState state = this.state;
    if (state is! AttractEffectState) {
      return;
    }

    emit(
      AttractEffectState(
        effect: state.effect.copyWith(curve: newValue),
      ),
    );
  }

  void setAttractEffectPointerSmoothing(double newValue) {
    final EffectState state = this.state;
    if (state is! AttractEffectState) {
      return;
    }

    emit(
      AttractEffectState(
        effect: state.effect.copyWith(pointerSmoothing: newValue),
      ),
    );
  }

  // endregion

  // region RippleEffect

  void setRippleEffectSpeed(double newValue) {
    final EffectState state = this.state;
    if (state is! RippleEffectState) {
      return;
    }

    emit(
      RippleEffectState(
        effect: state.effect.copyWith(speed: newValue),
      ),
    );
  }

  void setRippleEffectWidth(double newValue) {
    final EffectState state = this.state;
    if (state is! RippleEffectState) {
      return;
    }

    emit(
      RippleEffectState(
        effect: state.effect.copyWith(width: newValue),
      ),
    );
  }

  void setRippleEffectRadiusMultiplier(double newValue) {
    final EffectState state = this.state;
    if (state is! RippleEffectState) {
      return;
    }

    emit(
      RippleEffectState(
        effect: state.effect.copyWith(radiusMultiplier: newValue),
      ),
    );
  }

  void setRippleEffectDistanceMultiplier(double newValue) {
    final EffectState state = this.state;
    if (state is! RippleEffectState) {
      return;
    }

    emit(
      RippleEffectState(
        effect: state.effect.copyWith(distanceMultiplier: newValue),
      ),
    );
  }

  void setRippleEffectPunch(double newValue) {
    final EffectState state = this.state;
    if (state is! RippleEffectState) {
      return;
    }

    emit(
      RippleEffectState(
        effect: state.effect.copyWith(punch: newValue),
      ),
    );
  }

  // endregion

  // region SpeedupEffect

  void setSpeedupEffectMaxSpeedup(double newValue) {
    final EffectState state = this.state;
    if (state is! SpeedupEffectState) {
      return;
    }

    emit(
      SpeedupEffectState(
        effect: state.effect.copyWith(maxSpeedup: newValue),
      ),
    );
  }

  void setSpeedupEffectSpeedupRate(double newValue) {
    final EffectState state = this.state;
    if (state is! SpeedupEffectState) {
      return;
    }

    emit(
      SpeedupEffectState(
        effect: state.effect.copyWith(speedupRate: newValue),
      ),
    );
  }

  // endregion
}
