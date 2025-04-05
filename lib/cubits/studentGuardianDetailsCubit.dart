import 'package:yocut/data/models/guardian.dart';
import 'package:yocut/data/repositories/studentRepository.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

abstract class StudentGuardianDetailsState {}

class StudentGuardianDetailsInitial extends StudentGuardianDetailsState {}

class StudentGuardianDetailsFetchInProgress
    extends StudentGuardianDetailsState {}

class StudentGuardianDetailsFetchSuccess extends StudentGuardianDetailsState {
  final Guardian guardian;

  StudentGuardianDetailsFetchSuccess({
    required this.guardian,
  });
}

class StudentGuardianDetailsFetchFailure extends StudentGuardianDetailsState {
  final String errorMessage;

  StudentGuardianDetailsFetchFailure(this.errorMessage);
}

class StudentGuardianDetailsCubit extends Cubit<StudentGuardianDetailsState> {
  final StudentRepository _studentRepository;

  StudentGuardianDetailsCubit(this._studentRepository)
      : super(StudentGuardianDetailsInitial());

  Future<void> getStudentGuardianDetails() async {
    try {
      final result = await _studentRepository.fetchGuardianDetails();
      emit(
        StudentGuardianDetailsFetchSuccess(guardian: result),
      );
    } catch (e) {
      emit(StudentGuardianDetailsFetchFailure(e.toString()));
    }
  }
}
