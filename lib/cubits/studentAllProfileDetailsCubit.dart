import 'package:yocut/data/models/student.dart';
import 'package:yocut/data/repositories/studentRepository.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

abstract class StudentAllProfileDetailsState {}

class StudentAllProfileDetailsInitial extends StudentAllProfileDetailsState {}

class StudentAllProfileDetailsFetchInProgress
    extends StudentAllProfileDetailsState {}

class StudentAllProfileDetailsFetchSuccess
    extends StudentAllProfileDetailsState {
  final Student student;

  StudentAllProfileDetailsFetchSuccess({required this.student});
}

class StudentAllProfileDetailsFetchFailure
    extends StudentAllProfileDetailsState {
  final String errorMessage;

  StudentAllProfileDetailsFetchFailure(this.errorMessage);
}

class StudentAllProfileDetailsCubit
    extends Cubit<StudentAllProfileDetailsState> {
  final StudentRepository _studentRepository;

  StudentAllProfileDetailsCubit(this._studentRepository)
      : super(StudentAllProfileDetailsInitial());

  void getStudentAllProfileDetails(
      {required bool useParentApi, int? childId}) async {
    emit(StudentAllProfileDetailsFetchInProgress());
    try {
      emit(StudentAllProfileDetailsFetchSuccess(
          student: await _studentRepository.fetchStudentFullProfileDetails(
              useParentApi: useParentApi, childId: childId)));
    } catch (e) {
      emit(StudentAllProfileDetailsFetchFailure(e.toString()));
    }
  }
}
