import 'package:equatable/equatable.dart';
import 'package:yocut/data/models/Student.dart';
import 'package:yocut/data/models/schoolDetails.dart';
import 'package:yocut/data/repositories/schoolDetailsRepository.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

abstract class SchooldetailsState extends Equatable {}

class SchooldetailsInitial extends SchooldetailsState {
  @override
  List<Object?> get props => [];
}

class SchooldetailsFetchInProgress extends SchooldetailsState {
  @override
  List<Object?> get props => [];
}

class SchooldetailsFetchSuccess extends SchooldetailsState {
  final Student schoolDetails;

  SchooldetailsFetchSuccess({required this.schoolDetails});
  @override
  List<Object?> get props => [schoolDetails];
}

class SchooldetailsFetchFailure extends SchooldetailsState {
  final String errorMessage;

  SchooldetailsFetchFailure(this.errorMessage);

  @override
  List<Object?> get props => [errorMessage];
}

class SchooldetailsCubit extends Cubit<SchooldetailsState> {
  SchooldetailsCubit() : super(SchooldetailsInitial());

  Future<void> fetchSchooldetails() async {
     late Map<String, dynamic> result; 
    emit(SchooldetailsFetchInProgress());
    try {

      result = await _authRepository.getStudent(
            credentials: loginResponse,
          );

      emit(
        SchooldetailsFetchSuccess(
          schoolDetails: await Schooldetailsfetch.fetchSchoolDetails(),
        ),
      );
    } catch (e, st) {
      print(st);
      emit(SchooldetailsFetchFailure(e.toString()));
    }
  }
}
