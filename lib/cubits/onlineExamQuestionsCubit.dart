import 'package:yocut/data/models/examOnline.dart';
import 'package:yocut/data/models/question.dart';
import 'package:yocut/data/repositories/onlineExamRepository.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

abstract class OnlineExamQuestionsState {}

class OnlineExamQuestionsInitial extends OnlineExamQuestionsState {}

class OnlineExamQuestionsFetchInProgress extends OnlineExamQuestionsState {}

class OnlineExamQuestionsFetchFailure extends OnlineExamQuestionsState {
  final String errorMessage;

  OnlineExamQuestionsFetchFailure(this.errorMessage);
}

class OnlineExamQuestionsFetchSuccess extends OnlineExamQuestionsState {
  final List<Question> questions;
  final int? totalQues;
  final int? totalMarks;

  OnlineExamQuestionsFetchSuccess({
    required this.totalQues,
    required this.totalMarks,
    required this.questions,
  });
}



class OnlineExamQuestionsCubit extends Cubit<OnlineExamQuestionsState> {
  final OnlineExamRepository _examRepository;

  OnlineExamQuestionsCubit(this._examRepository)
      : super(OnlineExamQuestionsInitial());

  Future<void> startExam({required ExamOnline exam}) async {
    emit(OnlineExamQuestionsFetchInProgress());
    try {
      final onlineExamDetailed = await _examRepository.getOnlineExamQuestions(
        examId: exam.id ?? 0,
        examKey: exam.examKey ?? 0,
      );

      final int noOfQue = onlineExamDetailed['totalQuestions'];
      final int totalMarks = onlineExamDetailed['totalMarks'];
      List<Question> questions = onlineExamDetailed['question'];

      emit(
        OnlineExamQuestionsFetchSuccess(
          totalMarks: totalMarks,
          totalQues: noOfQue,
          questions: arrangeQuestions(questions),
        ),
      );
    } catch (e) {
      emit(OnlineExamQuestionsFetchFailure(e.toString()));
    }
  }

  List<Question> arrangeQuestions(List<Question> questions) {
    List<Question> arrangedQuestions = [];

    List<String> marks = questions
        .map((question) => (question.marks ?? 0).toString())
        .toSet()
        .toList();
    //sort marks
    marks.sort((first, second) => first.compareTo(second));

    //arrange questions from low to high mark
    for (var questionMark in marks) {
      arrangedQuestions.addAll(
        questions
            .where((element) => (element.marks ?? 0).toString() == questionMark)
            .toList(),
      );
    }

    return arrangedQuestions;
  }

  int getQuetionIndexById(int questionId) {
    if (state is OnlineExamQuestionsFetchSuccess) {
      return (state as OnlineExamQuestionsFetchSuccess)
          .questions
          .indexWhere((element) => element.id == questionId);
    }
    return 0;
  }

  /*

  void setExamOnlineAnswers({
    required int examId,
    required Map<int, List<int>> selectedAnswersWithQuestionId,
  }) {
    emit(ExamOnlineFetchInProgress());

    _examRepository
        .setExamOnlineAnswers(
          examId: examId,
          answerData: selectedAnswersWithQuestionId,
        )
        .then((value) => emit(ExamOnlineAnswerSubmitted(value)))
        .catchError((e) => emit(ExamOnlineAnswerSubmissionFail(e.toString())));
  }

*/

  List<Question> getQuestions() {
    if (state is OnlineExamQuestionsFetchSuccess) {
      return (state as OnlineExamQuestionsFetchSuccess).questions;
    }
    return [];
  }

  int? getTotalMarks() {
    if (state is OnlineExamQuestionsFetchSuccess) {
      return (state as OnlineExamQuestionsFetchSuccess).totalMarks;
    }
    return 0;
  }

  int? getTotalQuestions() {
    if (state is OnlineExamQuestionsFetchSuccess) {
      return (state as OnlineExamQuestionsFetchSuccess).totalQues;
    }
    return 0;
  }

  List<Question> getQuestionsByMark(String questionMark) {
    if (state is OnlineExamQuestionsFetchSuccess) {
      return (state as OnlineExamQuestionsFetchSuccess)
          .questions
          .where((question) => (question.marks ?? 0).toString() == questionMark)
          .toList();
    }
    return [];
  }

  List<String> getUniqueQuestionMark() {
    if (state is OnlineExamQuestionsFetchSuccess) {
      return (state as OnlineExamQuestionsFetchSuccess)
          .questions
          .map((question) => (question.marks ?? 0).toString())
          .toSet()
          .toList();
    }
    return [];
  }
}
