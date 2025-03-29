// ignore: depend_on_referenced_packages
import 'package:bloc/bloc.dart';
import 'package:yocut/data/models/exam.dart';
import 'package:yocut/data/repositories/studentRepository.dart';

abstract class ExamDetailsState {}

class ExamDetailsInitial extends ExamDetailsState {}

class ExamDetailsFetchSuccess extends ExamDetailsState {
  final List<Exam> examList;

  ExamDetailsFetchSuccess({required this.examList});
}

class ExamDetailsFetchFailure extends ExamDetailsState {
  final String errorMessage;

  ExamDetailsFetchFailure(this.errorMessage);
}

class ExamDetailsFetchInProgress extends ExamDetailsState {}

class ExamDetailsCubit extends Cubit<ExamDetailsState> {
  final StudentRepository _studentRepository;

  ExamDetailsCubit(this._studentRepository) : super(ExamDetailsInitial());

  void fetchStudentExamsList({
    required bool useParentApi,
    required int examStatus,
    int? childId,
  }) {
    emit(ExamDetailsFetchInProgress());
    _studentRepository
        .fetchExamsList(
          childId: childId ?? 0,
          examStatus: examStatus,
          useParentApi: useParentApi,
        )
        .then((value) => emit(ExamDetailsFetchSuccess(examList: value)))
        .catchError(
          (e) => emit(ExamDetailsFetchFailure(e.toString())),
        );
  }
}
