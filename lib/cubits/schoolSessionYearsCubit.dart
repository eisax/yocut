import 'package:yocut/data/models/sessionYear.dart';
import 'package:yocut/data/repositories/schoolRepository.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

abstract class SchoolSessionYearsState {}

class SchoolSessionYearsInitial extends SchoolSessionYearsState {}

class SchoolSessionYearsFetchInProgress extends SchoolSessionYearsState {}

class SchoolSessionYearsFetchSuccess extends SchoolSessionYearsState {
  final List<SessionYear> sessionYears;

  SchoolSessionYearsFetchSuccess({required this.sessionYears});
}

class SchoolSessionYearsFetchFailure extends SchoolSessionYearsState {
  final String errorMessage;

  SchoolSessionYearsFetchFailure(this.errorMessage);
}

class SchoolSessionYearsCubit extends Cubit<SchoolSessionYearsState> {
  final SchoolRepository _schoolRepository;

  SchoolSessionYearsCubit(this._schoolRepository)
      : super(SchoolSessionYearsInitial());

  void fetchSessionYears({required bool useParentApi, int? childId}) async {
    try {
      emit(SchoolSessionYearsFetchInProgress());
      emit(SchoolSessionYearsFetchSuccess(
          sessionYears: await _schoolRepository.fetchSchoolSessionYears(
              useParentApi: useParentApi, childId: childId)));
    } catch (e) {
      emit(SchoolSessionYearsFetchFailure(e.toString()));
    }
  }
}
