import 'dart:convert';

import 'package:yocut/data/models/notificationDetails.dart';
import 'package:yocut/data/repositories/authRepository.dart';
import 'package:yocut/utils/api.dart';
import 'package:yocut/utils/errorMessageKeysAndCodes.dart';
import 'package:yocut/utils/hiveBoxKeys.dart';
import 'package:flutter/foundation.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:shared_preferences/shared_preferences.dart';

class NotificationRepository {
  static Future<void> addNotification(
      {required NotificationDetails notificationDetails}) async {
    try {
      await Hive.box(notificationsBoxKey).put(
          notificationDetails.createdAt.toString(),
          notificationDetails.toJson());
    } catch (_) {}
  }

  Future<List<NotificationDetails>> fetchNotifications() async {
    try {
      Box notificationBox = Hive.box(notificationsBoxKey);
      List<NotificationDetails> notifications = [];

      for (var notificationKey in notificationBox.keys.toList()) {
        notifications.add(NotificationDetails.fromJson(
          Map.from(notificationBox.get(notificationKey) ?? {}),
        ));
      }

      // final currentUserId = AuthRepository.getIsStudentLogIn()
      //     ? (AuthRepository.getStudentDetails().id ?? 0)
      //     : (AuthRepository.getParentDetails().id ?? 0);

      // notifications = notifications
      //     .where((element) => element.userId == currentUserId)
      //     .toList();

      notifications
          .sort((first, second) => second.createdAt.compareTo(first.createdAt));

      return notifications;
    } catch (e) {
      if (kDebugMode) {
        print(e.toString());
      }
      throw ApiException(ErrorMessageKeysAndCode.defaultErrorMessageKey);
    }
  }

  static Future<void> addNotificationTemporarily(
      {required Map<String, dynamic> data}) async {
    try {
      SharedPreferences sharedPreferences =
          await SharedPreferences.getInstance();
      await sharedPreferences.reload();
      List<String> notifications =
          sharedPreferences.getStringList(temporarilyStoredNotificationsKey) ??
              List<String>.from([]);

      notifications.add(jsonEncode(data));

      await sharedPreferences.setStringList(
          temporarilyStoredNotificationsKey, notifications);
    } catch (_) {}
  }

  static Future<List<Map<String, dynamic>>>
      getTemporarilyStoredNotifications() async {
    SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
    await sharedPreferences.reload();
    List<String> notifications =
        sharedPreferences.getStringList(temporarilyStoredNotificationsKey) ??
            List<String>.from([]);

    return notifications
        .map((notificationData) =>
            Map<String, dynamic>.from(jsonDecode(notificationData) ?? {}))
        .toList();
  }

  static Future<void> clearTemporarilyNotification() async {
    SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
    sharedPreferences.setStringList(temporarilyStoredNotificationsKey, []);
  }
}
