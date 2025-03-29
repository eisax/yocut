import 'package:yocut/utils/labelKeys.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class ResultTabSelectionState {
  //online or offline
  final String resultFilterTabTitle;
  final int resultFilterByClassSubjectId;

  ResultTabSelectionState({
    required this.resultFilterByClassSubjectId,
    required this.resultFilterTabTitle,
  });
}

class ResultTabSelectionCubit extends Cubit<ResultTabSelectionState> {
  ResultTabSelectionCubit()
      : super(
          ResultTabSelectionState(
            resultFilterByClassSubjectId: 0,
            resultFilterTabTitle: offlineKey,
          ),
        ); //offline bydefault

  void changeResultFilterTabTitle(String resultFilterTabTitle) {
    emit(
      ResultTabSelectionState(
        resultFilterByClassSubjectId: state.resultFilterByClassSubjectId,
        resultFilterTabTitle: resultFilterTabTitle,
      ),
    );
  }

  void changeResultFilterBySubjectId(int resultFilterByClassSubjectId) {
    emit(
      ResultTabSelectionState(
        resultFilterByClassSubjectId: resultFilterByClassSubjectId,
        resultFilterTabTitle: state.resultFilterTabTitle,
      ),
    );
  }

  bool isResultOnline() {
    //change bool to int If required to use further for API
    return state.resultFilterTabTitle == onlineKey;
  }
}
