import 'package:yocut/data/repositories/studentRepository.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

abstract class SelectElectiveSubjectsState {}

class SelectElectiveSubjectsInitial extends SelectElectiveSubjectsState {}

class SelectElectiveSubjectsInProgress extends SelectElectiveSubjectsState {}

class SelectElectiveSubjectsSuccess extends SelectElectiveSubjectsState {
  final List<int> electedClassSubjectIds;

  SelectElectiveSubjectsSuccess(this.electedClassSubjectIds);
}

class SelectElectiveSubjectsFailure extends SelectElectiveSubjectsState {
  final String errorMessage;

  SelectElectiveSubjectsFailure(this.errorMessage);
}

class SelectElectiveSubjectsCubit extends Cubit<SelectElectiveSubjectsState> {
  final StudentRepository _studentRepository;

  SelectElectiveSubjectsCubit(this._studentRepository)
      : super(SelectElectiveSubjectsInitial());

  List<int> _getElectedClassSubjectIds(
      Map<int, List<int>> electedSubjectGroups) {
    List<int> classSubjectIds = [];

    for (var key in electedSubjectGroups.keys) {
      classSubjectIds.addAll(electedSubjectGroups[key]!.toList());
    }

    print("Class subject ids : ${classSubjectIds}");
    return classSubjectIds;
  }

  void selectElectiveSubjects({
    required Map<int, List<int>> electedSubjectGroups,
  }) {
    emit(SelectElectiveSubjectsInProgress());
    _studentRepository
        .selectElectiveSubjects(electedSubjectGroups: electedSubjectGroups)
        .then(
      (value) {
        return emit(
          SelectElectiveSubjectsSuccess(
            _getElectedClassSubjectIds(electedSubjectGroups),
          ),
        );
      },
    ).catchError((e) => emit(SelectElectiveSubjectsFailure(e.toString())));
  }
}
