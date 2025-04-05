import 'package:yocut/utils/labelKeys.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class ReportTabSelectionState {
  //assignment or Online Exam
  final String reportFilterTabTitle;

  ReportTabSelectionState({
    required this.reportFilterTabTitle,
  });
}

class ReportTabSelectionCubit extends Cubit<ReportTabSelectionState> {
  ReportTabSelectionCubit()
      : super(
          ReportTabSelectionState(
            reportFilterTabTitle: assignmentKey,
          ),
        ); //assignment bydefault

  void changeReportFilterTabTitle(String reportFilterTabTitle) {
    emit(
      ReportTabSelectionState(
        reportFilterTabTitle: reportFilterTabTitle,
      ),
    );
  }

  bool isReportAssignment() {
    //change bool to int If required to use further for API
    return state.reportFilterTabTitle == assignmentKey;
  }
}
