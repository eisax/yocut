import 'package:yocut/data/models/assignmentList.dart';
import 'package:yocut/data/repositories/reportRepository.dart';

import 'package:flutter_bloc/flutter_bloc.dart';

abstract class AssignmentReportState {}

class AssignmentReportInitial extends AssignmentReportState {}

class AssignmentReportFetchInProgress extends AssignmentReportState {}

class AssignmentReportFetchFailure extends AssignmentReportState {
  final String errorMessage;

  AssignmentReportFetchFailure(this.errorMessage);
}

class AssignmentReportFetchSuccess extends AssignmentReportState {
  final int? assignments;
  final int? submittedAssignments;
  final int? unsubmittedAssignments;
  final String? totalPoints;
  final String? totalObtainedPoints;
  final String? percentage;
  final AssignmentList submittedAssignmentWithPointsData;
  final int? classSubjectId;
  final bool fetchMoreAssignmentReportInProgress;
  final bool moreAssignmentReportFetchError;
  final int currentPage;
  final int totalPage;

  AssignmentReportFetchSuccess({
    required this.assignments,
    required this.submittedAssignments,
    required this.unsubmittedAssignments,
    required this.totalPoints,
    required this.totalObtainedPoints,
    required this.percentage,
    required this.submittedAssignmentWithPointsData,
    required this.classSubjectId,
    required this.fetchMoreAssignmentReportInProgress,
    required this.moreAssignmentReportFetchError,
    required this.currentPage,
    required this.totalPage,
  });

  AssignmentReportFetchSuccess copyWith({
    AssignmentList? newAssignmentList,
    bool? newFetchMoreAssignmentReportInProgress,
    bool? newMoreFetchError,
    int? newCurrentPage,
    int? newTotalPage,
  }) {
    return AssignmentReportFetchSuccess(
      classSubjectId: classSubjectId,
      assignments: assignments,
      currentPage: newCurrentPage ?? currentPage,
      fetchMoreAssignmentReportInProgress: false,
      moreAssignmentReportFetchError: false,
      totalPage: newTotalPage ?? totalPage,
      percentage: percentage,
      totalPoints: totalPoints,
      submittedAssignments: submittedAssignments,
      unsubmittedAssignments: unsubmittedAssignments,
      totalObtainedPoints: totalObtainedPoints,
      submittedAssignmentWithPointsData:
          newAssignmentList ?? submittedAssignmentWithPointsData,
    );
  }
}

class AssignmentReportCubit extends Cubit<AssignmentReportState> {
  final ReportRepository _reportRepository;

  AssignmentReportCubit(this._reportRepository)
      : super(AssignmentReportInitial());

  Future<void> getAssignmentReport({
    required int classSubjectId,
    required int childId,
    required bool useParentApi,
  }) async {
    emit(AssignmentReportFetchInProgress());
    try {
      final assignmentDetailed = await _reportRepository.getAssignmentReport(
        classSubjectId: classSubjectId,
        childId: childId,
        useParentApi: useParentApi,
      );

      AssignmentList assignmentList = assignmentDetailed['assignmentList'];

      emit(
        AssignmentReportFetchSuccess(
          assignments:
              int.parse((assignmentDetailed['assignments'] ?? "0").toString()),
          percentage: (assignmentDetailed['percentage'] ?? "").toString(),
          submittedAssignments: int.parse(
              (assignmentDetailed['submittedAssignments'] ?? "0").toString()),
          unsubmittedAssignments: int.parse(
              (assignmentDetailed['unsubmittedAssignments'] ?? "0").toString()),
          submittedAssignmentWithPointsData: assignmentList,
          totalObtainedPoints:
              (assignmentDetailed['totalObtainedPoints'] ?? "").toString(),
          totalPoints: (assignmentDetailed['totalPoints'] ?? "").toString(),
          fetchMoreAssignmentReportInProgress: false,
          moreAssignmentReportFetchError: false,
          currentPage:
              int.parse((assignmentList.currentPage ?? "0").toString()),
          totalPage: int.parse((assignmentList.lastPage ?? "0").toString()),
          classSubjectId: classSubjectId,
        ),
      );
    } catch (e) {
      emit(AssignmentReportFetchFailure(e.toString()));
    }
  }

  bool hasMore() {
    if (state is AssignmentReportFetchSuccess) {
      return (state as AssignmentReportFetchSuccess).currentPage <
          (state as AssignmentReportFetchSuccess).totalPage;
    }
    return false;
  }

  Future<void> getMoreAssignmentReport({
    required int childId,
    required bool useParentApi,
  }) async {
    if (state is AssignmentReportFetchSuccess) {
      if ((state as AssignmentReportFetchSuccess)
          .fetchMoreAssignmentReportInProgress) {
        return;
      }
    }
    try {
      emit(
        (state as AssignmentReportFetchSuccess)
            .copyWith(newFetchMoreAssignmentReportInProgress: true),
      );

      final moreOnlineExamReport = await _reportRepository.getExamOnlineReport(
        childId: childId,
        useParentApi: useParentApi,
        page: (state as AssignmentReportFetchSuccess)
                .submittedAssignmentWithPointsData
                .currentPage! +
            1,
        classSubjectId: (state as AssignmentReportFetchSuccess).classSubjectId!,
      );

      final currentState = state as AssignmentReportFetchSuccess;
      AssignmentList assignmentList =
          currentState.submittedAssignmentWithPointsData;

      //add more assignmentList into existing assignmentList
      assignmentList.data!.addAll([assignmentList].first.data!);
      emit(
        AssignmentReportFetchSuccess(
          fetchMoreAssignmentReportInProgress: false,
          classSubjectId: currentState.classSubjectId,
          moreAssignmentReportFetchError: false,
          currentPage: assignmentList.currentPage!,
          totalPage: assignmentList.lastPage!,
          percentage: moreOnlineExamReport['percentage'],
          assignments: moreOnlineExamReport['assignments'],
          submittedAssignments: moreOnlineExamReport['submittedAssignments'],
          unsubmittedAssignments:
              moreOnlineExamReport['unsubmittedAssignments'],
          submittedAssignmentWithPointsData: assignmentList,
          totalObtainedPoints: moreOnlineExamReport['totalObtainedPoints'],
          totalPoints: moreOnlineExamReport['totalPoints'],
        ),
      );
    } catch (e) {
      emit(
        (state as AssignmentReportFetchSuccess).copyWith(
          newFetchMoreAssignmentReportInProgress: false,
          newMoreFetchError: true,
        ),
      );
    }
  }
}
