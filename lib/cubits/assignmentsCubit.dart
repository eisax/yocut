import 'package:yocut/data/models/assignment.dart';
import 'package:yocut/data/repositories/assignmentRepository.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

abstract class AssignmentsState {}

class AssignmentsInitial extends AssignmentsState {}

class AssignmentsFetchInProgress extends AssignmentsState {}

class AssignmentsFetchSuccess extends AssignmentsState {
  final List<Assignment> assignments;
  final int totalPage; //total page of assignments
  final int currentPage; //current assignments page
  final bool moreAssignmentsFetchError;
  //if subjectId is null then fetch all assignments else fetch assignments based on subjectId
  final int? classSubjectId;
  final bool fetchMoreAssignmentsInProgress;

  AssignmentsFetchSuccess({
    required this.assignments,
    this.classSubjectId,
    required this.fetchMoreAssignmentsInProgress,
    required this.moreAssignmentsFetchError,
    required this.currentPage,
    required this.totalPage,
  });

  AssignmentsFetchSuccess copyWith({
    List<Assignment>? newAssignments,
    bool? newFetchMoreAssignmentsInProgress,
    bool? newMoreAssignmentsFetchError,
    int? newCurrentPage,
    int? newTotalPage,
  }) {
    return AssignmentsFetchSuccess(
      classSubjectId: classSubjectId,
      assignments: newAssignments ?? assignments,
      fetchMoreAssignmentsInProgress:
          newFetchMoreAssignmentsInProgress ?? fetchMoreAssignmentsInProgress,
      moreAssignmentsFetchError:
          newMoreAssignmentsFetchError ?? moreAssignmentsFetchError,
      currentPage: newCurrentPage ?? currentPage,
      totalPage: newTotalPage ?? totalPage,
    );
  }
}

class AssignmentsFetchFailure extends AssignmentsState {
  final String errorMessage;
  final int? page;
  final int? classSubjectId;

  AssignmentsFetchFailure({
    required this.errorMessage,
    required this.page,
    required this.classSubjectId,
  });
}

class AssignmentsCubit extends Cubit<AssignmentsState> {
  final AssignmentRepository _assignmentRepository;

  AssignmentsCubit(this._assignmentRepository) : super(AssignmentsInitial());

  void fetchAssignments({
    int? page,
    int? assignmentId,
    int? classSubjectId,
    required int isSubmitted,
    required int childId,
    required bool useParentApi,
  }) {
    emit(AssignmentsFetchInProgress());
    _assignmentRepository
        .fetchAssignments(
          childId: childId,
          useParentApi: useParentApi,
          assignmentId: assignmentId,
          page: page,
          classSubjectId: classSubjectId,
          isSubmitted: isSubmitted,
        )
        .then(
          (value) => emit(
            AssignmentsFetchSuccess(
              fetchMoreAssignmentsInProgress: false,
              classSubjectId: classSubjectId,
              moreAssignmentsFetchError: false,
              assignments: value['assignments'],
              currentPage: value['currentPage'],
              totalPage: value['totalPage'],
            ),
          ),
        )
        .catchError(
          (e) => emit(
            AssignmentsFetchFailure(
              errorMessage: e.toString(),
              page: page,
              classSubjectId: classSubjectId,
            ),
          ),
        );
  }

  List<Assignment> getAssignedAssignments() {
    if (state is AssignmentsFetchSuccess) {
      return (state as AssignmentsFetchSuccess)
          .assignments
          .where((element) => element.assignmentSubmission.id == 0)
          .toList();
    }
    return [];
  }

  List<Assignment> getSubmittedAssignments() {
    if (state is AssignmentsFetchSuccess) {
      return (state as AssignmentsFetchSuccess)
          .assignments
          .where((element) => element.assignmentSubmission.id != 0)
          .toList();
    }
    return [];
  }

  bool hasMore() {
    if (state is AssignmentsFetchSuccess) {
      return (state as AssignmentsFetchSuccess).currentPage <
          (state as AssignmentsFetchSuccess).totalPage;
    }
    return false;
  }

  Future<void> fetchMoreAssignments({
    required int childId,
    required bool useParentApi,
    required int isSubmitted,
  }) async {
    if (state is AssignmentsFetchSuccess) {
      if ((state as AssignmentsFetchSuccess).fetchMoreAssignmentsInProgress) {
        return;
      }
      try {
        emit(
          (state as AssignmentsFetchSuccess)
              .copyWith(newFetchMoreAssignmentsInProgress: true),
        );
        //fetch more assignemnts
        //more assignment result
        final moreAssignmentsResult =
            await _assignmentRepository.fetchAssignments(
          childId: childId,
          useParentApi: useParentApi,
          isSubmitted: isSubmitted,
          page: (state as AssignmentsFetchSuccess).currentPage + 1,
          classSubjectId: (state as AssignmentsFetchSuccess).classSubjectId,
        );

        final currentState = state as AssignmentsFetchSuccess;
        // ignore: prefer_final_locals
        List<Assignment> assignments = currentState.assignments;

        //add more assignments into original assignments list
        assignments.addAll(moreAssignmentsResult['assignments']);

        emit(
          AssignmentsFetchSuccess(
            fetchMoreAssignmentsInProgress: false,
            classSubjectId: currentState.classSubjectId,
            assignments: assignments,
            moreAssignmentsFetchError: false,
            currentPage: moreAssignmentsResult['currentPage'],
            totalPage: moreAssignmentsResult['totalPage'],
          ),
        );
      } catch (e) {
        emit(
          (state as AssignmentsFetchSuccess).copyWith(
            newFetchMoreAssignmentsInProgress: false,
            newMoreAssignmentsFetchError: true,
          ),
        );
      }
    }
  }

  void updateAssignments(Assignment assignment) {
    if (state is AssignmentsFetchSuccess) {
      List<Assignment> updatedAssignments =
          (state as AssignmentsFetchSuccess).assignments;
      final assignmentIndex = updatedAssignments
          .indexWhere((element) => element.id == assignment.id);
      if (assignmentIndex != -1) {
        updatedAssignments[assignmentIndex] = assignment;
        emit(
          (state as AssignmentsFetchSuccess)
              .copyWith(newAssignments: updatedAssignments),
        );
      }
    }
  }

  /* Assignment? getSubmittedAssignmentFromReport(int assignmentId) {
    if (state is AssignmentsFetchSuccess) {
      return (state as AssignmentsFetchSuccess).assignments.firstWhere(
          (element) =>
              element.assignmentSubmission.id != 0 &&
              element.id == assignmentId);
    }
    return null;
  } */
}
