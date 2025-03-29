import 'package:yocut/data/models/sliderDetails.dart';
import 'package:yocut/data/repositories/schoolRepository.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

abstract class SlidersState {}

class SlidersInitial extends SlidersState {}

class SlidersFetchInProgress extends SlidersState {}

class SlidersFetchSuccess extends SlidersState {
  final List<SliderDetails> sliders;

  SlidersFetchSuccess({required this.sliders});
}

class SlidersFetchFailure extends SlidersState {
  final String errorMessage;

  SlidersFetchFailure(this.errorMessage);
}

class SlidersCubit extends Cubit<SlidersState> {
  final SchoolRepository _schoolRepository;

  SlidersCubit(this._schoolRepository) : super(SlidersInitial());

  Future<void> fetchSliders({required bool useParentApi, int? childId}) async {
    emit(SlidersFetchInProgress());
    try {
      final sliders = await _schoolRepository.fetchSliders(
          useParentApi: useParentApi, childId: childId);
      emit(SlidersFetchSuccess(sliders: sliders));
    } catch (e) {
      emit(SlidersFetchFailure(e.toString()));
    }
  }
}
