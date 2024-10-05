import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:meta/meta.dart';
import 'package:metaball_demo/widgets/drawer/cards/size/size_card.dart';
import 'package:metaballs/metaballs.dart';

part 'size_state.dart';

class SizeCubit extends Cubit<SizeState> {
  SizeCubit()
      : super(
          const SizeDynamicRangeState(
            scaler: MetaballDynamicRangeScaler(
              minPercentage: 0.1,
              maxPercentage: 1,
            ),
          ),
        );

  void setScaler(ScalerType scalerType) {
    emit(switch (scalerType) {
      ScalerType.dynamic => const SizeDynamicState(
          scaler: MetaballDynamicScaler(),
        ),
      ScalerType.dynamicRange => const SizeDynamicRangeState(
          scaler: MetaballDynamicRangeScaler(),
        ),
      ScalerType.static => const SizeStaticState(
          scaler: MetaballStaticScaler(),
        ),
      ScalerType.staticRange => const SizeStaticRangeState(
          scaler: MetaballStaticRangeScaler(),
        ),
    });
  }

  void setDynamicRange(double min, double max) {
    emit(SizeDynamicRangeState(
      scaler: MetaballDynamicRangeScaler(
        minPercentage: min,
        maxPercentage: max,
      ),
    ));
  }

  void setDynamic(double value) {
    emit(SizeDynamicState(
      scaler: MetaballDynamicScaler(
        percentage: value,
      ),
    ));
  }

  void setStatic(double value) {
    emit(SizeStaticState(
      scaler: MetaballStaticScaler(
        size: value,
      ),
    ));
  }

  void setStaticRange(double min, double max) {
    emit(SizeStaticRangeState(
      scaler: MetaballStaticRangeScaler(
        min: min,
        max: max,
      ),
    ));
  }
}
