import 'package:equatable/equatable.dart';
import 'package:yocut/data/models/lesson.dart';
import 'package:yocut/data/repositories/subjectRepository.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

abstract class SubjectLessonsState extends Equatable {}

class SubjectLessonsInitial extends SubjectLessonsState {
  @override
  List<Object?> get props => [];
}

class SubjectLessonsFetchInProgress extends SubjectLessonsState {
  @override
  List<Object?> get props => [];
}

class SubjectLessonsFetchSuccess extends SubjectLessonsState {
  final List<Lesson> lessons;

  SubjectLessonsFetchSuccess({required this.lessons});
  @override
  List<Object?> get props => [lessons];
}

class SubjectLessonsFetchFailure extends SubjectLessonsState {
  final String errorMessage;

  SubjectLessonsFetchFailure(this.errorMessage);

  @override
  List<Object?> get props => [errorMessage];
}

class SubjectLessonsCubit extends Cubit<SubjectLessonsState> {
  final SubjectRepository _subjectRepository;

  SubjectLessonsCubit(this._subjectRepository) : super(SubjectLessonsInitial());

  void fetchSubjectLessons({
    required int classSubjectId,
    required bool useParentApi,
    int? childId,
  }) {
    emit(SubjectLessonsFetchInProgress());
    _subjectRepository
        .getLessons(
          classSubjectId: classSubjectId,
          childId: childId ?? 0,
          useParentApi: useParentApi,
        )
        .then((lessons) => emit(SubjectLessonsFetchSuccess(lessons: lessons)))
        .catchError((e) => emit(SubjectLessonsFetchFailure(e.toString())));
  }
}
