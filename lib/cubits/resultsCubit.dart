import 'package:yocut/data/models/result.dart';
import 'package:yocut/data/repositories/studentRepository.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

abstract class ResultsState {}

class ResultsInitial extends ResultsState {}

class ResultsFetchInProgress extends ResultsState {}

class ResultsFetchSuccess extends ResultsState {
  final List<Result> results;
  final int totalPage;
  final int currentPage;

  final bool moreResultsFetchError;
  final bool fetchMoreResultsInProgress;

  ResultsFetchSuccess({
    required this.fetchMoreResultsInProgress,
    required this.moreResultsFetchError,
    required this.results,
    required this.currentPage,
    required this.totalPage,
  });

  ResultsFetchSuccess copyWith({
    List<Result>? newResults,
    bool? newFetchMoreResultsInProgress,
    bool? newMoreResultsFetchError,
    int? newCurrentPage,
    int? newTotalPage,
  }) {
    return ResultsFetchSuccess(
      results: newResults ?? results,
      fetchMoreResultsInProgress:
          newFetchMoreResultsInProgress ?? fetchMoreResultsInProgress,
      moreResultsFetchError: newMoreResultsFetchError ?? moreResultsFetchError,
      currentPage: newCurrentPage ?? currentPage,
      totalPage: newTotalPage ?? totalPage,
    );
  }
}

class ResultsFetchFailure extends ResultsState {
  final String errorMessage;

  ResultsFetchFailure({required this.errorMessage});
}

class ResultsCubit extends Cubit<ResultsState> {
  final StudentRepository _studentRepository;

  ResultsCubit(this._studentRepository) : super(ResultsInitial());

  Future<void> fetchResults({required bool useParentApi, int? childId}) async {
    try {
      emit(ResultsFetchInProgress());
      final result = await _studentRepository.fetchExamResults(
        childId: childId ?? 0,
        useParentApi: useParentApi,
      );

      emit(
        ResultsFetchSuccess(
          results: result['results'],
          fetchMoreResultsInProgress: false,
          moreResultsFetchError: false,
          currentPage: result['currentPage'] ?? 1,
          totalPage: result['totalPage'] ?? 1,
        ),
      );
    } catch (e) {
      emit(ResultsFetchFailure(errorMessage: e.toString()));
    }
  }

  bool hasMore() {
    if (state is ResultsFetchSuccess) {
      return (state as ResultsFetchSuccess).currentPage <
          (state as ResultsFetchSuccess).totalPage;
    }
    return false;
  }

  Future<void> fetchMoreResults(
      {required bool useParentApi, int? childId,}) async {
    if (state is ResultsFetchSuccess) {
      if ((state as ResultsFetchSuccess).fetchMoreResultsInProgress) {
        return;
      }
      try {
        emit(
          (state as ResultsFetchSuccess)
              .copyWith(newFetchMoreResultsInProgress: true),
        );

        final moreResults = await _studentRepository.fetchExamResults(
          childId: childId ?? 0,
          useParentApi: useParentApi,
          page: (state as ResultsFetchSuccess).currentPage + 1,
        );

        final currentState = state as ResultsFetchSuccess;
        List<Result> results = currentState.results;

        //add more results into original results list
        results.addAll(moreResults['results']);

        emit(
          ResultsFetchSuccess(
            fetchMoreResultsInProgress: false,
            results: results,
            moreResultsFetchError: false,
            currentPage: moreResults['currentPage'],
            totalPage: moreResults['totalPage'],
          ),
        );
      } catch (e) {
        emit(
          (state as ResultsFetchSuccess).copyWith(
            newFetchMoreResultsInProgress: false,
            newMoreResultsFetchError: true,
          ),
        );
      }
    }
  }
}
