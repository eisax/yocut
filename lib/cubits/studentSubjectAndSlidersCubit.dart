import 'package:yocut/data/models/electiveSubject.dart';
import 'package:yocut/data/models/sliderDetails.dart';
import 'package:yocut/data/models/subject.dart';
import 'package:yocut/data/repositories/parentRepository.dart';
import 'package:yocut/data/repositories/schoolRepository.dart';
import 'package:yocut/data/repositories/studentRepository.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

abstract class StudentSubjectsAndSlidersState {}

class StudentSubjectsAndSlidersInitial extends StudentSubjectsAndSlidersState {}

class StudentSubjectsAndSlidersFetchInProgress
    extends StudentSubjectsAndSlidersState {}

class StudentSubjectsAndSlidersFetchSuccess
    extends StudentSubjectsAndSlidersState {
  final List<Subject> electiveSubjects;
  final List<Subject> coreSubjects;
  final List<SliderDetails> sliders;
  final bool doesClassHaveElectiveSubjects;

  StudentSubjectsAndSlidersFetchSuccess({
    required this.coreSubjects,
    required this.doesClassHaveElectiveSubjects,
    required this.electiveSubjects,
    required this.sliders,
  });
}

class StudentSubjectsAndSlidersFetchFailure
    extends StudentSubjectsAndSlidersState {
  final String errorMessage;

  StudentSubjectsAndSlidersFetchFailure(this.errorMessage);
}

class StudentSubjectsAndSlidersCubit
    extends Cubit<StudentSubjectsAndSlidersState> {
  final StudentRepository studentRepository = StudentRepository();
  final SchoolRepository schoolRepository = SchoolRepository();
  final ParentRepository parentRepository = ParentRepository();

  StudentSubjectsAndSlidersCubit() : super(StudentSubjectsAndSlidersInitial());

  Future<void> fetchSubjectsAndSliders(
      {required bool isSliderModuleEnable,
      required bool useParentApi,
      int? childId}) async {
    emit(StudentSubjectsAndSlidersFetchInProgress());
    try {
      print("Calling the api");
      final sliders = isSliderModuleEnable
          ? await schoolRepository.fetchSliders(
              useParentApi: useParentApi, childId: childId)
          : List<SliderDetails>.from([]);

      final subjects = useParentApi
          ? await parentRepository.fetchChildSubjects(childId: childId ?? 0)
          : await studentRepository.fetchSubjects();

      emit(
        StudentSubjectsAndSlidersFetchSuccess(
          doesClassHaveElectiveSubjects:
              subjects['doesClassHaveElectiveSubjects'],
          coreSubjects: subjects['coreSubjects'],
          electiveSubjects: subjects['electiveSubjects'],
          sliders: sliders,
        ),
      );
    } catch (e) {
      emit(StudentSubjectsAndSlidersFetchFailure(e.toString()));
    }
  }

  void updateElectiveSubjects(List<ElectiveSubject> electiveSubjects) {
    if (state is StudentSubjectsAndSlidersFetchSuccess) {
      //
      studentRepository.setLocalElectiveSubjects(electiveSubjects);
      emit(
        StudentSubjectsAndSlidersFetchSuccess(
          doesClassHaveElectiveSubjects:
              (state as StudentSubjectsAndSlidersFetchSuccess)
                  .doesClassHaveElectiveSubjects,
          sliders: (state as StudentSubjectsAndSlidersFetchSuccess).sliders,
          coreSubjects:
              (state as StudentSubjectsAndSlidersFetchSuccess).coreSubjects,
          electiveSubjects: electiveSubjects,
        ),
      );
    }
  }

  List<Subject> getSubjects() {
    if (state is StudentSubjectsAndSlidersFetchSuccess) {
      List<Subject> subjects = [];

      subjects.addAll(
        (state as StudentSubjectsAndSlidersFetchSuccess).coreSubjects,
      );

      subjects.addAll(
        (state as StudentSubjectsAndSlidersFetchSuccess)
            .electiveSubjects
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
          classSubjectId: 0,
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

  List<Subject> getElectiveSubjects() {
    if (state is StudentSubjectsAndSlidersFetchSuccess) {
      return (state as StudentSubjectsAndSlidersFetchSuccess)
          .electiveSubjects
          .where((element) => element.id != 0)
          .toList();
    }
    return [];
  }

  List<SliderDetails> getSliders() {
    if (state is StudentSubjectsAndSlidersFetchSuccess) {
      return (state as StudentSubjectsAndSlidersFetchSuccess).sliders;
    }
    return [];
  }

  void clearSubjects() {
    studentRepository.setLocalCoreSubjects([]);
    studentRepository.setLocalElectiveSubjects([]);
    emit(StudentSubjectsAndSlidersInitial());
  }
}
