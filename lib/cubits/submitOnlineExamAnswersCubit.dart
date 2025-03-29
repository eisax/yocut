import 'package:yocut/data/repositories/onlineExamRepository.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

abstract class SubmitOnlineExamAnswersState {}

class SubmitOnlineExamAnswersInitial extends SubmitOnlineExamAnswersState {}

class SubmitOnlineExamAnswersInProgress extends SubmitOnlineExamAnswersState {}

class SubmitOnlineExamAnswersSuccess extends SubmitOnlineExamAnswersState {
  final String message;

  SubmitOnlineExamAnswersSuccess({required this.message});
}

class SubmitOnlineExamAnswersFailure extends SubmitOnlineExamAnswersState {
  final String errorMessage;

  SubmitOnlineExamAnswersFailure(this.errorMessage);
}

class SubmitOnlineExamAnswersCubit extends Cubit<SubmitOnlineExamAnswersState> {
  final OnlineExamRepository _onlineExamRepository;

  SubmitOnlineExamAnswersCubit(this._onlineExamRepository)
      : super(SubmitOnlineExamAnswersInitial());

  void submitAnswers(
      {required int examId, required Map<int, List<int>> answers}) async {
    emit(SubmitOnlineExamAnswersInProgress());
    try {
      emit(SubmitOnlineExamAnswersSuccess(
          message: await _onlineExamRepository.setExamOnlineAnswers(
              examId: examId, answerData: answers)));
    } catch (e) {
      emit(SubmitOnlineExamAnswersFailure(e.toString()));
    }
  }
}
