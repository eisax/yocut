import 'package:equatable/equatable.dart';
import 'package:yocut/data/models/holiday.dart';
import 'package:yocut/data/repositories/systemInfoRepository.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

abstract class HolidaysState extends Equatable {}

class HolidaysInitial extends HolidaysState {
  @override
  List<Object?> get props => [];
}

class HolidaysFetchInProgress extends HolidaysState {
  @override
  List<Object?> get props => [];
}

class HolidaysFetchSuccess extends HolidaysState {
  final List<Holiday> holidays;

  HolidaysFetchSuccess({required this.holidays});
  @override
  List<Object?> get props => [holidays];
}

class HolidaysFetchFailure extends HolidaysState {
  final String errorMessage;

  HolidaysFetchFailure(this.errorMessage);

  @override
  List<Object?> get props => [errorMessage];
}

class HolidaysCubit extends Cubit<HolidaysState> {
  final SystemRepository _systemRepository;

  HolidaysCubit(this._systemRepository) : super(HolidaysInitial());

  Future<void> fetchHolidays({int? childId}) async {
    emit(HolidaysFetchInProgress());
    try {
      emit(
        HolidaysFetchSuccess(
          holidays: await _systemRepository.fetchHolidays(childId: childId),
        ),
      );
    } catch (e) {
      emit(HolidaysFetchFailure(e.toString()));
    }
  }

  List<Holiday> holidays() {
    if (state is HolidaysFetchSuccess) {
      return (state as HolidaysFetchSuccess).holidays;
    }
    return [];
  }
}
