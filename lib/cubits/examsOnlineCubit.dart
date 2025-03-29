import 'package:yocut/data/models/examOnline.dart';
import 'package:yocut/data/repositories/onlineExamRepository.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

abstract class ExamsOnlineState {}

class ExamsOnlineInitial extends ExamsOnlineState {}

class ExamsOnlineFetchInProgress extends ExamsOnlineState {}

class ExamsOnlineFetchSuccess extends ExamsOnlineState {
  final List<ExamOnline> examList;
  final int totalPage;
  final int currentPage;
  final bool moreExamsFetchError;
  //if subjectId is null then fetch all exams else fetch exams based on subjectId
  final int? classSubjectId;
  final bool fetchMoreExamsInProgress;

  ExamsOnlineFetchSuccess({
    required this.examList,
    this.classSubjectId,
    required this.fetchMoreExamsInProgress,
    required this.moreExamsFetchError,
    required this.currentPage,
    required this.totalPage,
  });

  ExamsOnlineFetchSuccess copyWith({
    List<ExamOnline>? newExamList,
    bool? newFetchMoreExamsInProgress,
    bool? newMoreExamsFetchError,
    int? newCurrentPage,
    int? newTotalPage,
  }) {
    return ExamsOnlineFetchSuccess(
      classSubjectId: classSubjectId,
      examList: newExamList ?? examList,
      fetchMoreExamsInProgress:
          newFetchMoreExamsInProgress ?? fetchMoreExamsInProgress,
      moreExamsFetchError: newMoreExamsFetchError ?? moreExamsFetchError,
      currentPage: newCurrentPage ?? currentPage,
      totalPage: newTotalPage ?? totalPage,
    );
  }
}

class ExamsOnlineFetchFailure extends ExamsOnlineState {
  final String errorMessage;
  final int? page;
  final int? classSubjectId;

  ExamsOnlineFetchFailure(this.errorMessage, this.page, this.classSubjectId);
}

class ExamsOnlineCubit extends Cubit<ExamsOnlineState> {
  final OnlineExamRepository examRepository;

  ExamsOnlineCubit(this.examRepository) : super(ExamsOnlineInitial());

  Future<void> getExamsOnline({
    int? page,
    required int classSubjectId,
    required int childId,
    required bool useParentApi,
  }) async {
    emit(ExamsOnlineFetchInProgress());
    try {
      examRepository
          .getExamsOnline(
            classSubjectId: classSubjectId,
            page: page,
            childId: childId,
            useParentApi: useParentApi,
          )
          .then(
            (value) => emit(
              ExamsOnlineFetchSuccess(
                classSubjectId: classSubjectId,
                examList: value['examList'],
                currentPage: value['currentPage'],
                totalPage: value['totalPage'],
                fetchMoreExamsInProgress: false,
                moreExamsFetchError: false,
              ),
            ),
          )
          .catchError(
            (e) => emit(
                ExamsOnlineFetchFailure(e.toString(), page, classSubjectId)),
          );
    } catch (e) {
      if (kDebugMode) {
        print(e);
      }
      emit(ExamsOnlineFetchFailure(e.toString(), page, classSubjectId));
    }
  }

  Future<void> getMoreExamsOnline({
    required int childId,
    required bool useParentApi,
  }) async {
    if (state is ExamsOnlineFetchSuccess) {
      if ((state as ExamsOnlineFetchSuccess).fetchMoreExamsInProgress) {
        return;
      }
      try {
        emit(
          (state as ExamsOnlineFetchSuccess)
              .copyWith(newFetchMoreExamsInProgress: true),
        );

        final moreAssignmentsResult = await examRepository.getExamsOnline(
          page: (state as ExamsOnlineFetchSuccess).currentPage + 1,
          classSubjectId: (state as ExamsOnlineFetchSuccess).classSubjectId!,
          childId: childId,
          useParentApi: useParentApi,
        );

        final currentState = state as ExamsOnlineFetchSuccess;
        List<ExamOnline> exams = currentState.examList;

        exams.addAll(moreAssignmentsResult['examList']);

        emit(
          ExamsOnlineFetchSuccess(
            fetchMoreExamsInProgress: false,
            classSubjectId: currentState.classSubjectId,
            examList: exams,
            moreExamsFetchError: false,
            currentPage: moreAssignmentsResult['currentPage'],
            totalPage: moreAssignmentsResult['totalPage'],
          ),
        );
      } catch (e) {
        emit(
          (state as ExamsOnlineFetchSuccess).copyWith(
            newFetchMoreExamsInProgress: false,
            newMoreExamsFetchError: true,
          ),
        );
      }
    }
  }

  bool hasMore() {
    if (state is ExamsOnlineFetchSuccess) {
      return (state as ExamsOnlineFetchSuccess).currentPage <
          (state as ExamsOnlineFetchSuccess).totalPage;
    }
    return false;
  }
}
