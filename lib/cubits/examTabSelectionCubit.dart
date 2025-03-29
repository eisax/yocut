import 'package:yocut/utils/labelKeys.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class ExamTabSelectionState {
  //online or offline
  final String examFilterTabTitle;
  final int examFilterByClassSubjectId;

  ExamTabSelectionState({
    required this.examFilterByClassSubjectId,
    required this.examFilterTabTitle,
  });
}

class ExamTabSelectionCubit extends Cubit<ExamTabSelectionState> {
  ExamTabSelectionCubit()
      : super(
          ExamTabSelectionState(
            examFilterByClassSubjectId: 0,
            examFilterTabTitle: offlineKey,
          ),
        ); //offline bydefault

  void changeExamFilterTabTitle(String examFilterTabTitle) {
    emit(
      ExamTabSelectionState(
        examFilterByClassSubjectId: state.examFilterByClassSubjectId,
        examFilterTabTitle: examFilterTabTitle,
      ),
    );
  }

  void changeExamFilterBySubjectId(int examFilterByClassSubjectId) {
    emit(
      ExamTabSelectionState(
        examFilterByClassSubjectId: examFilterByClassSubjectId,
        examFilterTabTitle: state.examFilterTabTitle,
      ),
    );
  }

  bool isExamOnline() {
    //change bool to int If required to use further for API
    return state.examFilterTabTitle == onlineKey;
  }
}
