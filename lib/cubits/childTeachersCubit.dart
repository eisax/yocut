import 'package:yocut/data/models/subjectTeacher.dart';
import 'package:yocut/data/repositories/parentRepository.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

abstract class ChildTeachersState {}

class ChildTeachersInitial extends ChildTeachersState {}

class ChildTeachersFetchInProgress extends ChildTeachersState {}

class ChildTeachersFetchSuccess extends ChildTeachersState {
  final List<SubjectTeacher> subjectTeachers;

  ChildTeachersFetchSuccess({required this.subjectTeachers});
}

class ChildTeachersFetchFailure extends ChildTeachersState {
  final String errorMessage;

  ChildTeachersFetchFailure(this.errorMessage);
}

class ChildTeachersCubit extends Cubit<ChildTeachersState> {
  final ParentRepository _parentRepository;

  ChildTeachersCubit(this._parentRepository) : super(ChildTeachersInitial());

  Future<void> fetchChildTeachers({required int childId}) async {
    emit(ChildTeachersFetchInProgress());
    try {
      emit(ChildTeachersFetchSuccess(
          subjectTeachers:
              await _parentRepository.fetchChildTeachers(childId: childId)));
    } catch (e) {
      emit(ChildTeachersFetchFailure(e.toString()));
    }
  }
}
