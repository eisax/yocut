import 'package:equatable/equatable.dart';
import 'package:yocut/data/models/timeTableSlot.dart';
import 'package:yocut/data/repositories/studentRepository.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

abstract class TimeTableState extends Equatable {}

class TimeTableInitial extends TimeTableState {
  @override
  List<Object?> get props => [];
}

class TimeTableFetchInProgress extends TimeTableState {
  @override
  List<Object?> get props => [];
}

class TimeTableFetchSuccess extends TimeTableState {
  final List<TimeTableSlot> timeTable;

  TimeTableFetchSuccess({required this.timeTable});
  @override
  List<Object?> get props => [timeTable];
}

class TimeTableFetchFailure extends TimeTableState {
  final String errorMessage;

  TimeTableFetchFailure(this.errorMessage);

  @override
  List<Object?> get props => [errorMessage];
}

class TimeTableCubit extends Cubit<TimeTableState> {
  final StudentRepository _studentRepository;

  TimeTableCubit(this._studentRepository) : super(TimeTableInitial());

  void fetchStudentTimeTable({required bool useParentApi, int? childId}) {
    emit(TimeTableFetchInProgress());
    _studentRepository
        .fetchTimeTable(childId: childId ?? 0, useParentApi: useParentApi)
        .then((value) => emit(TimeTableFetchSuccess(timeTable: value)))
        .catchError((e) => emit(TimeTableFetchFailure(e.toString())));
  }
}
