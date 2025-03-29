import 'package:yocut/data/repositories/settingsRepository.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class NotificationSettingsState {
  final bool allowNotifications;
  NotificationSettingsState(this.allowNotifications);
}

class NotificationSettingsCubit extends Cubit<NotificationSettingsState> {
  final SettingsRepository _settingsRepository;
  NotificationSettingsCubit(this._settingsRepository)
      : super(NotificationSettingsState(
            _settingsRepository.getAllowNotification(),),);

  void changeLanguage(bool value) {
    _settingsRepository.setAllowNotification(value);
    emit(NotificationSettingsState(value));
  }
}
