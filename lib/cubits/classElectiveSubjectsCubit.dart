import 'package:equatable/equatable.dart';
import 'package:yocut/data/models/electiveSubjectGroup.dart';
import 'package:yocut/data/repositories/classRepository.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

abstract class ClassElectiveSubjectsState extends Equatable {}

class ClassElectiveSubjectsInitial extends ClassElectiveSubjectsState {
  @override
  List<Object?> get props => [];
}

class ClassElectiveSubjectsFetchInProgress extends ClassElectiveSubjectsState {
  @override
  List<Object?> get props => [];
}

class ClassElectiveSubjectsFetchSuccess extends ClassElectiveSubjectsState {
  final List<ElectiveSubjectGroup> electiveSubjectGroups;

  ClassElectiveSubjectsFetchSuccess({required this.electiveSubjectGroups});
  @override
  List<Object?> get props => [electiveSubjectGroups];
}

class ClassElectiveSubjectsFetchFailure extends ClassElectiveSubjectsState {
  final String errorMessage;

  ClassElectiveSubjectsFetchFailure(this.errorMessage);

  @override
  List<Object?> get props => [errorMessage];
}

class ClassElectiveSubjectsCubit extends Cubit<ClassElectiveSubjectsState> {
  final ClassRepository _classRepository;

  ClassElectiveSubjectsCubit(this._classRepository)
      : super(ClassElectiveSubjectsInitial());

  void fetchElectiveSubjects() {
    emit(ClassElectiveSubjectsFetchInProgress());
    _classRepository
        .getElectiveSubjects()
        .then((result) => emit(
            ClassElectiveSubjectsFetchSuccess(electiveSubjectGroups: result),),)
        .catchError(
            (e) => emit(ClassElectiveSubjectsFetchFailure(e.toString())),);
  }

  List<ElectiveSubjectGroup> getElectiveSubjectGroups() {
    if (state is ClassElectiveSubjectsFetchSuccess) {
      return (state as ClassElectiveSubjectsFetchSuccess).electiveSubjectGroups;
    }
    return [];
  }
}
