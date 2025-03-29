import 'package:yocut/data/models/examList.dart';
import 'package:yocut/data/repositories/reportRepository.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

abstract class OnlineExamReportState {}

class OnlineExamReportInitial extends OnlineExamReportState {}

class OnlineExamReportFetchInProgress extends OnlineExamReportState {}

class OnlineExamReportFetchFailure extends OnlineExamReportState {
  final String errorMessage;

  OnlineExamReportFetchFailure(this.errorMessage);
}

class OnlineExamReportFetchSuccess extends OnlineExamReportState {
  final ExamList examList;
  final int? totalExams;
  final int? attempted;
  final int? missedExams;
  final String? totalMarks;
  final String? totalObtainedMarks;
  final String? percentage;
  final int? classSubjectId;
  final bool fetchMoreOnlineExamReportInProgress;
  final bool moreOnlineExamReportFetchError;
  final int currentPage;
  final int totalPage;

  OnlineExamReportFetchSuccess({
    required this.attempted,
    required this.missedExams,
    required this.totalObtainedMarks,
    required this.percentage,
    required this.totalExams,
    required this.examList,
    required this.totalMarks,
    required this.classSubjectId,
    required this.fetchMoreOnlineExamReportInProgress,
    required this.moreOnlineExamReportFetchError,
    required this.currentPage,
    required this.totalPage,
  });

  OnlineExamReportFetchSuccess copyWith({
    ExamList? newExamList,
    bool? newFetchMoreOnlineExamReportInProgress,
    bool? newMoreFetchError,
    int? newCurrentPage,
    int? newTotalPage,
  }) {
    return OnlineExamReportFetchSuccess(
      attempted: attempted,
      examList: newExamList ?? examList,
      fetchMoreOnlineExamReportInProgress:
          newFetchMoreOnlineExamReportInProgress ??
              fetchMoreOnlineExamReportInProgress,
      totalObtainedMarks: totalObtainedMarks,
      totalMarks: totalMarks,
      percentage: percentage,
      totalExams: totalExams,
      missedExams: missedExams,
      classSubjectId: classSubjectId,
      moreOnlineExamReportFetchError:
          newMoreFetchError ?? moreOnlineExamReportFetchError,
      currentPage: newCurrentPage ?? examList.currentPage!,
      totalPage: newTotalPage ?? examList.lastPage!,
    );
  }
}

class OnlineExamReportCubit extends Cubit<OnlineExamReportState> {
  final ReportRepository reportRepository;

  OnlineExamReportCubit(this.reportRepository)
      : super(OnlineExamReportInitial());

  Future<void> getExamOnlineReport({
    required int classSubjectId,
    required int childId,
    required bool useParentApi,
  }) async {
    emit(OnlineExamReportFetchInProgress());
    try {
      final OnlineExamReportDetails =
          await reportRepository.getExamOnlineReport(
        classSubjectId: classSubjectId,
        childId: childId,
        useParentApi: useParentApi,
      );

      ExamList examList = OnlineExamReportDetails['examList'];
      final int attempted = OnlineExamReportDetails['attempted'];
      final int missedExams = OnlineExamReportDetails['missedExams'];
      final int totalExams = OnlineExamReportDetails['totalExams'];
      final String percentage = OnlineExamReportDetails['percentage'];

      final String totalObtainedMarks =
          OnlineExamReportDetails['totalObtainedMarks'];
      final String totalMarks = OnlineExamReportDetails['totalMarks'];
      emit(
        OnlineExamReportFetchSuccess(
          examList: examList,
          attempted: attempted,
          missedExams: missedExams,
          totalObtainedMarks: totalObtainedMarks,
          percentage: percentage,
          totalExams: totalExams,
          totalMarks: totalMarks,
          classSubjectId: classSubjectId,
          fetchMoreOnlineExamReportInProgress: false,
          moreOnlineExamReportFetchError: false,
          currentPage: examList.currentPage!,
          totalPage: examList.lastPage!,
        ),
      );
    } catch (e) {
      emit(OnlineExamReportFetchFailure(e.toString()));
    }
  }

  bool hasMore() {
    if (state is OnlineExamReportFetchSuccess) {
      return (state as OnlineExamReportFetchSuccess).currentPage <
          (state as OnlineExamReportFetchSuccess).totalPage;
    }
    return false;
  }

  Future<void> getMoreExamOnlineReport({
    required int childId,
    required bool useParentApi,
  }) async {
    if (state is OnlineExamReportFetchSuccess) {
      if ((state as OnlineExamReportFetchSuccess)
          .fetchMoreOnlineExamReportInProgress) {
        return;
      }
      try {
        emit(
          (state as OnlineExamReportFetchSuccess)
              .copyWith(newFetchMoreOnlineExamReportInProgress: true),
        );

        final moreOnlineExamReport = await reportRepository.getExamOnlineReport(
          childId: childId,
          useParentApi: useParentApi,
          page:
              (state as OnlineExamReportFetchSuccess).examList.currentPage! + 1,
          classSubjectId:
              (state as OnlineExamReportFetchSuccess).classSubjectId!,
        );

        final currentState = state as OnlineExamReportFetchSuccess;
        ExamList examsList = currentState.examList;

        //add more examsList into existing examsList
        examsList.data!.addAll([examsList].first.data!);
        emit(
          OnlineExamReportFetchSuccess(
            fetchMoreOnlineExamReportInProgress: false,
            classSubjectId: currentState.classSubjectId,
            examList: examsList,
            moreOnlineExamReportFetchError: false,
            currentPage: examsList.currentPage!,
            totalPage: examsList.lastPage!,
            attempted: moreOnlineExamReport['attempted'],
            missedExams: moreOnlineExamReport['missedExams'],
            percentage: moreOnlineExamReport['percentage'],
            totalExams: moreOnlineExamReport['totalExams'],
            totalMarks: moreOnlineExamReport['totalMarks'],
            totalObtainedMarks: moreOnlineExamReport['totalObtainedMarks'],
          ),
        );
      } catch (e) {
        emit(
          (state as OnlineExamReportFetchSuccess).copyWith(
            newFetchMoreOnlineExamReportInProgress: false,
            newMoreFetchError: true,
          ),
        );
      }
    }
  }
}
