import 'package:equatable/equatable.dart';
import 'package:yocut/data/repositories/systemInfoRepository.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

//It will store the details like contact us and other
abstract class AppSettingsState extends Equatable {}

class AppSettingsInitial extends AppSettingsState {
  @override
  List<Object?> get props => [];
}

class AppSettingsFetchInProgress extends AppSettingsState {
  @override
  List<Object?> get props => [];
}

class AppSettingsFetchSuccess extends AppSettingsState {
  final String appSettingsResult;

  AppSettingsFetchSuccess({required this.appSettingsResult});
  @override
  List<Object?> get props => [appSettingsResult];
}


class AppSettingsFetchFailure extends AppSettingsState {
  final String errorMessage;

  AppSettingsFetchFailure(this.errorMessage);

  @override
  List<Object?> get props => [errorMessage];
}

class AppSettingsCubit extends Cubit<AppSettingsState> {
  final SystemRepository _systemRepository;

  AppSettingsCubit(this._systemRepository) : super(AppSettingsInitial());

  Future<void> fetchAppSettings({required String type}) async {
    emit(AppSettingsFetchInProgress());

    try {
      final result = await _systemRepository.fetchSettings(type: type) ?? "";
      emit(AppSettingsFetchSuccess(appSettingsResult: result));
    } catch (e) {
      emit(AppSettingsFetchFailure(e.toString()));
    }
  }
}
