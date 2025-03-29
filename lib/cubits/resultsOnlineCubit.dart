import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:yocut/data/models/resultOnline.dart';
import 'package:yocut/data/repositories/resultRepository.dart';

abstract class ResultsOnlineState {}

class ResultsOnlineInitial extends ResultsOnlineState {}

class ResultsOnlineFetchInProgress extends ResultsOnlineState {}

class ResultsOnlineFetchSuccess extends ResultsOnlineState {
  final List<ResultOnline> results;
  final int totalPage;
  final int currentPage;

  final bool moreResultsOnlineFetchError;
  final bool fetchMoreResultsOnlineInProgress;

  ResultsOnlineFetchSuccess({
    required this.fetchMoreResultsOnlineInProgress,
    required this.moreResultsOnlineFetchError,
    required this.results,
    required this.currentPage,
    required this.totalPage,
  });

  ResultsOnlineFetchSuccess copyWith({
    List<ResultOnline>? newResultsOnline,
    bool? newFetchMoreResultsOnlineInProgress,
    bool? newMoreResultsOnlineFetchError,
    int? newCurrentPage,
    int? newTotalPage,
  }) {
    return ResultsOnlineFetchSuccess(
      results: newResultsOnline ?? results,
      fetchMoreResultsOnlineInProgress: newFetchMoreResultsOnlineInProgress ??
          fetchMoreResultsOnlineInProgress,
      moreResultsOnlineFetchError:
          newMoreResultsOnlineFetchError ?? moreResultsOnlineFetchError,
      currentPage: newCurrentPage ?? currentPage,
      totalPage: newTotalPage ?? totalPage,
    );
  }
}

class ResultsOnlineFetchFailure extends ResultsOnlineState {
  final String errorMessage;

  ResultsOnlineFetchFailure({required this.errorMessage});
}

class ResultsOnlineCubit extends Cubit<ResultsOnlineState> {
  final ResultRepository resultRepository;

  ResultsOnlineCubit(this.resultRepository) : super(ResultsOnlineInitial());

  Future<void> fetchResultsOnline({
    required bool useParentApi,
    required int childId,
    required int classSubjectId,
    int? page,
  }) async {
    try {
      emit(ResultsOnlineFetchInProgress());
      final result = await resultRepository.getResultOnline(
        childId: childId,
        classSubjectId: classSubjectId,
        page: page,
        useParentApi: useParentApi,
      );

      emit(
        ResultsOnlineFetchSuccess(
          results: result['results'],
          fetchMoreResultsOnlineInProgress: false,
          moreResultsOnlineFetchError: false,
          currentPage: result['currentPage'] ?? 1,
          totalPage: result['totalPage'] ?? 1,
        ),
      );
    } catch (e) {
      emit(ResultsOnlineFetchFailure(errorMessage: e.toString()));
    }
  }

  bool hasMore() {
    if (state is ResultsOnlineFetchSuccess) {
      return (state as ResultsOnlineFetchSuccess).currentPage <
          (state as ResultsOnlineFetchSuccess).totalPage;
    }
    return false;
  }

  Future<void> fetchMoreResultsOnline({
    required bool useParentApi,
    required int childId,
    required int classSubjectId,
  }) async {
    if (state is ResultsOnlineFetchSuccess) {
      if ((state as ResultsOnlineFetchSuccess)
          .fetchMoreResultsOnlineInProgress) {
        return;
      }
      try {
        emit(
          (state as ResultsOnlineFetchSuccess)
              .copyWith(newFetchMoreResultsOnlineInProgress: true),
        );

        final moreResultsOnline = await resultRepository.getResultOnline(
          useParentApi: useParentApi,
          childId: childId,
          classSubjectId: classSubjectId,
          page: (state as ResultsOnlineFetchSuccess).currentPage + 1,
        );

        final currentState = state as ResultsOnlineFetchSuccess;
        List<ResultOnline> results = currentState.results;

        //add more results into original OnlineResults list
        results.addAll(moreResultsOnline['results']);

        emit(
          ResultsOnlineFetchSuccess(
            fetchMoreResultsOnlineInProgress: false,
            results: results,
            moreResultsOnlineFetchError: false,
            currentPage: moreResultsOnline['currentPage'],
            totalPage: moreResultsOnline['totalPage'],
          ),
        );
      } catch (e) {
        emit(
          (state as ResultsOnlineFetchSuccess).copyWith(
            newFetchMoreResultsOnlineInProgress: false,
            newMoreResultsOnlineFetchError: true,
          ),
        );
      }
    }
  }
}
