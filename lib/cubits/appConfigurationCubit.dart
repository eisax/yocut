import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:yocut/data/models/appConfiguration.dart';
import 'package:yocut/data/repositories/systemRepository.dart';

abstract class AppConfigurationState {}

class AppConfigurationInitial extends AppConfigurationState {}

class AppConfigurationFetchInProgress extends AppConfigurationState {}

class AppConfigurationFetchSuccess extends AppConfigurationState {
  final AppConfiguration appConfiguration;

  AppConfigurationFetchSuccess({required this.appConfiguration});
}

class AppConfigurationFetchFailure extends AppConfigurationState {
  final String errorMessage;

  AppConfigurationFetchFailure(this.errorMessage);
}

class AppConfigurationCubit extends Cubit<AppConfigurationState> {
  final SystemRepository _systemRepository;

  AppConfigurationCubit(this._systemRepository)
    : super(AppConfigurationInitial());

  Future<void> fetchAppConfiguration() async {
    emit(AppConfigurationFetchInProgress());
    try {
      emit(
        AppConfigurationFetchSuccess(
          appConfiguration: AppConfiguration(
            appLink: "null",
            iosAppLink: "null",
            appVersion: "null",
            iosAppVersion: "null",
            forceAppUpdate: "null",
            appMaintenance: "null",
            fileUploadSizeLimit: "null",
          ),
        ),
      );
    } catch (e) {
      emit(AppConfigurationFetchFailure(e.toString()));
    }
  }

  AppConfiguration getAppConfiguration() {
    if (state is AppConfigurationFetchSuccess) {
      return (state as AppConfigurationFetchSuccess).appConfiguration;
    }
    return AppConfiguration.fromJson({});
  }
}
