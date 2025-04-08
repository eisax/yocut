import 'dart:io';

import 'package:yocut/data/models/appConfiguration.dart';
import 'package:yocut/data/repositories/systemInfoRepository.dart';

import 'package:flutter_bloc/flutter_bloc.dart';

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
    // emit(AppConfigurationFetchInProgress());
    try {
      // final appConfiguration = AppConfiguration.fromJson(
      //   await _systemRepository.fetchSettings(type: "app_settings") ?? {},
      // );

      // emit(AppConfigurationFetchSuccess(appConfiguration: appConfiguration));
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

  String getAppLink() {
    if (state is AppConfigurationFetchSuccess) {
      return Platform.isIOS
          ? getAppConfiguration().iosAppLink
          : getAppConfiguration().appLink;
    }
    return "";
  }

  String getAppVersion() {
    if (state is AppConfigurationFetchSuccess) {
      return Platform.isIOS
          ? getAppConfiguration().iosAppVersion
          : getAppConfiguration().appVersion;
    }
    return "";
  }

  bool appUnderMaintenance() {
    if (state is AppConfigurationFetchSuccess) {
      return getAppConfiguration().appMaintenance == "1";
    }
    return false;
  }

  bool forceUpdate() {
    if (state is AppConfigurationFetchSuccess) {
      return getAppConfiguration().forceAppUpdate == "1";
    }
    return false;
  }

  String getFileSizeLimit() {
    if (state is AppConfigurationFetchSuccess) {
      return getAppConfiguration().fileUploadSizeLimit;
    }
    return "";
  }
}
