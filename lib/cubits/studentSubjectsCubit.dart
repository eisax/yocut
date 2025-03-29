import 'package:yocut/data/models/subject.dart';
import 'package:yocut/data/repositories/parentRepository.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

abstract class ChildSubjectsState {}

class ChildSubjectsInitial extends ChildSubjectsState {}

class ChildSubjectsFetchInProgress extends ChildSubjectsState {}

class ChildSubjectsFetchSuccess extends ChildSubjectsState {
  final List<Subject> electiveSubjects;
  final List<Subject> coreSubjects;
  final bool doesClassHaveElectiveSubjects;

  ChildSubjectsFetchSuccess({
    required this.coreSubjects,
    required this.electiveSubjects,
    required this.doesClassHaveElectiveSubjects,
  });
}

class ChildSubjectsFetchFailure extends ChildSubjectsState {
  final String errorMessage;

  ChildSubjectsFetchFailure(this.errorMessage);
}

class ChildSubjectsCubit extends Cubit<ChildSubjectsState> {
  final ParentRepository _parentRepository;

  ChildSubjectsCubit(this._parentRepository) : super(ChildSubjectsInitial());

  Future<void> fetchChildSubjects(int childId) async {
    emit(ChildSubjectsFetchInProgress());

    try {
      final result =
          await _parentRepository.fetchChildSubjects(childId: childId);
      emit(
        ChildSubjectsFetchSuccess(
          coreSubjects: result['coreSubjects'],
          electiveSubjects: result['electiveSubjects'],
          doesClassHaveElectiveSubjects:
              result['doesClassHaveElectiveSubjects'],
        ),
      );
    } catch (e) {
      emit(ChildSubjectsFetchFailure(e.toString()));
    }
  }

  List<Subject> getSubjects() {
    if (state is ChildSubjectsFetchSuccess) {
      List<Subject> subjects = [];

      subjects.addAll(
        (state as ChildSubjectsFetchSuccess)
            .coreSubjects
            .where((element) => element.id != 0)
            .toList(),
      );

      subjects.addAll(
        (state as ChildSubjectsFetchSuccess)
            .electiveSubjects
            .where((element) => element.id != 0)
            .toList(),
      );

      return subjects;
    }

    return [];
  }

  List<Subject> getSubjectsForAssignmentContainer() {
    return getSubjects()
      ..insert(
        0,
        Subject(
          bgColor: "",
          id: 0,
          code: "",
          image: "",
          mediumId: 1,
          name: "",
          type: "",
        ),
      );
  }
}
