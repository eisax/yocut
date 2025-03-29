import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:yocut/data/models/resultOnlineDetails.dart';
import 'package:yocut/data/repositories/resultRepository.dart';

abstract class ResultOnlineState {}

class ResultOnlineInitial extends ResultOnlineState {}

class ResultOnlineFetchInProgress extends ResultOnlineState {}

class ResultOnlineFetchSuccess extends ResultOnlineState {
  final ResultOnlineDetails result;

  ResultOnlineFetchSuccess({required this.result});
}

class ResultOnlineFetchFailure extends ResultOnlineState {
  final String errorMessage;

  ResultOnlineFetchFailure({required this.errorMessage});
}

class ResultOnlineCubit extends Cubit<ResultOnlineState> {
  final ResultRepository resultRepository;

  ResultOnlineCubit(this.resultRepository) : super(ResultOnlineInitial());

  Future<void> fetchResultOnlineDetails({
    required bool useParentApi,
    required int childId,
    required int examId,
  }) async {
    try {
      emit(ResultOnlineFetchInProgress());
      resultRepository
          .getOnlineResultDetails(
        examId: examId,
        childId: childId,
        useParentApi: useParentApi,
      )
          .then((value) {
        emit(ResultOnlineFetchSuccess(result: value));
      });
    } catch (e) {
      emit(ResultOnlineFetchFailure(errorMessage: e.toString()));
    }
  }

  List<QuestionData> getCorectAnswersByMark(int questionMark) {
    if (state is ResultOnlineFetchSuccess) {
      return (state as ResultOnlineFetchSuccess)
          .result
          .correctAnswers!
          .questionData!
          .where((element) => element.marks == questionMark)
          .toList();
    }
    return [];
  }

  List<int?> getUniqueCorrectAnswerMark() {
    if (state is ResultOnlineFetchSuccess) {
      final correctAnswers = (state as ResultOnlineFetchSuccess)
          .result
          .correctAnswers!
          .questionData!
          .map((e) => e.marks)
          .toSet()
          .toList();
      final incorrectAnswers = (state as ResultOnlineFetchSuccess)
          .result
          .inCorrectAnswers!
          .questionData!
          .map((e) => e.marks)
          .toSet()
          .toList();
      var uniqueMarks1 = (correctAnswers + incorrectAnswers).toSet().toList();
      uniqueMarks1.sort();
      final uniqueMarks = uniqueMarks1.reversed.toList(); //descending order

      return uniqueMarks;
    }
    return [];
  }

  int getTotalQuestionsOfMark(int marks) {
    if (state is ResultOnlineFetchSuccess) {
      final total = ((state as ResultOnlineFetchSuccess)
              .result
              .correctAnswers!
              .questionData!
              .where((element) => element.marks == marks)
              .toList()
              .length) +
          ((state as ResultOnlineFetchSuccess)
              .result
              .inCorrectAnswers!
              .questionData!
              .where((element) => element.marks == marks)
              .toList()
              .length);
      return total;
    }
    return 0;
  }

  List<QuestionData> getIncorectAnswersByMark(int questionMark) {
    if (state is ResultOnlineFetchSuccess) {
      return (state as ResultOnlineFetchSuccess)
          .result
          .inCorrectAnswers!
          .questionData!
          .where((element) => element.marks == questionMark)
          .toList();
    }
    return [];
  }
}
