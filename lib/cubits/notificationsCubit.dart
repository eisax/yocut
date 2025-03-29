import 'package:yocut/data/models/notificationDetails.dart';
import 'package:yocut/data/repositories/notificationRepository.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

abstract class NotificationsState {}

class NotificationsInitial extends NotificationsState {}

class NotificationsFetchInProgress extends NotificationsState {}

class NotificationsFetchSuccess extends NotificationsState {
  final List<NotificationDetails> notifications;

  NotificationsFetchSuccess({required this.notifications});
}

class NotificationsFetchFailure extends NotificationsState {
  final String errorMessage;

  NotificationsFetchFailure(this.errorMessage);
}

class NotificationsCubit extends Cubit<NotificationsState> {
  final NotificationRepository _notificationRepository;

  NotificationsCubit(this._notificationRepository)
      : super(NotificationsInitial());

  void fetchNotifications() async {
    try {
      emit(NotificationsFetchInProgress());
      emit(NotificationsFetchSuccess(
          notifications: await _notificationRepository.fetchNotifications()));
    } catch (e) {
      emit(NotificationsFetchFailure(e.toString()));
    }
  }
}
