import 'package:yocut/data/models/Student.dart';
import 'package:yocut/data/models/schoolConfiguration.dart';
import 'package:yocut/data/models/schoolSettings.dart';
import 'package:yocut/data/models/semesterDetails.dart';
import 'package:yocut/data/models/sessionYear.dart';
import 'package:yocut/data/repositories/schoolRepository.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

abstract class SchoolConfigurationState {}

class SchoolConfigurationInitial extends SchoolConfigurationState {}

class SchoolConfigurationFetchInProgress extends SchoolConfigurationState {}

class SchoolConfigurationFetchSuccess extends SchoolConfigurationState {
  final Student schoolConfiguration;

  SchoolConfigurationFetchSuccess({required this.schoolConfiguration});
}

class SchoolConfigurationFetchFailure extends SchoolConfigurationState {
  final String errorMessage;

  SchoolConfigurationFetchFailure(this.errorMessage);
}

class SchoolConfigurationCubit extends Cubit<SchoolConfigurationState> {
  final SchoolRepository _schoolRepository;

  SchoolConfigurationCubit(this._schoolRepository)
    : super(SchoolConfigurationInitial());

  Future<void> fetchSchoolConfiguration({
    required bool useParentApi,
    int? childId,
  }) async {
    emit(SchoolConfigurationFetchInProgress());

    try {
      final config = await _schoolRepository.fetchSchoolDetails();
      emit(
        SchoolConfigurationFetchSuccess(schoolConfiguration: config['student']),
      );
    } catch (e) {
      emit(SchoolConfigurationFetchFailure(e.toString()));
    }
  }

  Student getSchoolConfiguration() {
    if (state is SchoolConfigurationFetchSuccess) {
      return (state as SchoolConfigurationFetchSuccess).schoolConfiguration;
    }
    return Student.fromJson({});
  }

  String fetchExamRules() {
    if (state is SchoolConfigurationFetchSuccess) {
      final config =
          (state as SchoolConfigurationFetchSuccess).schoolConfiguration;
      return config.examRules ??
          ''; // Assuming SchoolConfiguration has an examRules property
    }
    return '';
  }
}
