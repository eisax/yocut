import 'dart:async';

// import 'package:awesome_notifications/awesome_notifications.dart';

import 'package:yocut/app/routes.dart';
import 'package:yocut/data/models/notificationDetails.dart';
import 'package:yocut/data/repositories/authRepository.dart';
import 'package:yocut/data/repositories/notificationRepository.dart';
import 'package:yocut/ui/screens/home/homeScreeen.dart';
import 'package:yocut/utils/constants.dart';
import 'package:yocut/utils/hiveBoxKeys.dart';
// import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/foundation.dart';
import 'package:get/get.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:permission_handler/permission_handler.dart';

// ignore: avoid_classes_with_only_static_members
class NotificationUtility {
  static String generalNotificationType = "general";

  static String assignmentlNotificationType = "assignment";
  static String paymentNotificationType = "payment";
  static String notificationType = "Notification";
  static String messageType = "Message";

//   static Future<void> setUpNotificationService() async {
//     NotificationSettings notificationSettings =
//         await FirebaseMessaging.instance.getNotificationSettings();

//     //ask for permission
//     if (notificationSettings.authorizationStatus ==
//             AuthorizationStatus.notDetermined ||
//         notificationSettings.authorizationStatus ==
//             AuthorizationStatus.denied) {
//       notificationSettings =
//           await FirebaseMessaging.instance.requestPermission();

//       //if permission is provisionnal or authorised
//       if (notificationSettings.authorizationStatus ==
//               AuthorizationStatus.authorized ||
//           notificationSettings.authorizationStatus ==
//               AuthorizationStatus.provisional) {
//         initNotificationListener();
//       }

//       //if permission denied
//     } else if (notificationSettings.authorizationStatus ==
//         AuthorizationStatus.denied) {
//       return;
//     }
//     initNotificationListener();
//   }

//   static void initNotificationListener() {
//     FirebaseMessaging.onMessage.listen(foregroundMessageListener);
//     FirebaseMessaging.onBackgroundMessage(onBackgroundMessage);
//     FirebaseMessaging.onMessageOpenedApp.listen(onMessageOpenedAppListener);
//   }

//   @pragma('vm:entry-point')
//   static Future<void> onBackgroundMessage(RemoteMessage remoteMessage) async {
//     //perform any background task if needed here
//     final type = (remoteMessage.data['type'] ?? "").toString();
//     if (kDebugMode) {
//       print(type);
//     }
//     if (type.toLowerCase() == notificationType.toLowerCase()) {
//       await Hive.initFlutter();
//       await Hive.openBox(authBoxKey);
//       NotificationRepository.addNotificationTemporarily(
//           data: NotificationDetails(
//                   userId: AuthRepository.getIsStudentLogIn()
//                       ? (AuthRepository.getStudentDetails().id ?? 0)
//                       : (AuthRepository.getParentDetails().id ?? 0),
//                   attachmentUrl: remoteMessage.data['image'] ?? "",
//                   body: remoteMessage.notification?.body ?? "",
//                   createdAt: DateTime.timestamp(),
//                   title: remoteMessage.notification?.title ?? "")
//               .toJson());
//     }
//   }

//   static Future<void> foregroundMessageListener(
//     RemoteMessage remoteMessage,
//   ) async {
//     await FirebaseMessaging.instance.getToken();

//     final type = (remoteMessage.data['type'] ?? "").toString();

//     if (type == paymentNotificationType) {
//       Future.delayed(Duration(seconds: 5), () {
//         if (Get.currentRoute == Routes.confirmPayment) {
//           Get.back();
//         }
//       });
//     } else if (type.toLowerCase() == notificationType.toLowerCase()) {
//       NotificationRepository.addNotification(
//           notificationDetails: NotificationDetails(
//               userId: AuthRepository.getIsStudentLogIn()
//                   ? (AuthRepository.getStudentDetails().id ?? 0)
//                   : (AuthRepository.getParentDetails().id ?? 0),
//               attachmentUrl: remoteMessage.data['image'] ?? "",
//               body: remoteMessage.notification?.body ?? "",
//               createdAt: DateTime.timestamp(),
//               title: remoteMessage.notification?.title ?? ""));
//     }

// //

//     createLocalNotification(dimissable: true, message: remoteMessage);
//   }

//   static void onMessageOpenedAppListener(RemoteMessage remoteMessage) {
//     _onTapNotificationScreenNavigateCallback(
//       remoteMessage.data['type'] ?? "",
//       remoteMessage.data,
//     );
//   }

  static void _onTapNotificationScreenNavigateCallback(
    String type,
    Map<String, dynamic> data,
  ) {
    if (type.isEmpty) {
      return;
    }

    if (type == generalNotificationType) {
      if (Get.currentRoute != Routes.noticeBoard) {
        Get.toNamed(Routes.noticeBoard);
      }
    } else if (type == assignmentlNotificationType) {
      HomeScreen.homeScreenKey.currentState?.navigateToAssignmentContainer();
    } else if (type == paymentNotificationType) {
    } else if (type == messageType) {
      if (Get.currentRoute != Routes.chatContacts) {
        Get.toNamed(Routes.chatContacts);
      }
    } else if (type == notificationType) {
      if (Get.currentRoute != Routes.notifications) {
        Get.toNamed(Routes.notifications);
      }
    }
  }

  static Future<void> initializeAwesomeNotification() async {
    // await AwesomeNotifications().initialize(null, [
    //   NotificationChannel(
    //     channelKey: notificationChannelKey,
    //     channelName: 'Basic notifications',
    //     channelDescription: 'Notification channel for basic tests',
    //     vibrationPattern: highVibrationPattern,
    //     importance: NotificationImportance.Max,
    //     playSound: true,
    //   ),
    // ]);
  }

  static Future<bool> isLocalNotificationAllowed() async {
    const notificationPermission = Permission.notification;
    final status = await notificationPermission.status;
    return status.isGranted;
  }

  /// Use this method to detect when a new notification or a schedule is created
  static Future<void> onNotificationCreatedMethod(
    // ReceivedNotification receivedNotification,
  ) async {
    // Your code goes here
  }

  /// Use this method to detect every time that a new notification is displayed
  static Future<void> onNotificationDisplayedMethod(
    // ReceivedNotification receivedNotification,
  ) async {
    // Your code goes here
  }

  /// Use this method to detect if the user dismissed a notification
  static Future<void> onDismissActionReceivedMethod(
    // ReceivedAction receivedAction,
  ) async {
    // Your code goes here
  }

  /// Use this method to detect when the user taps on a notification or action button
  static Future<void> onActionReceivedMethod(
    // ReceivedAction receivedAction,
  ) async {
    // _onTapNotificationScreenNavigateCallback(
    //   (receivedAction.payload ?? {})['type'] ?? "",
    //   Map.from(receivedAction.payload ?? {}),
    // );
  }

  // static Future<void> createLocalNotification({
  //   required bool dimissable,
  //   required RemoteMessage message,
  // }) async {
  //   final String title = message.notification?.title ?? "";
  //   final String body = message.notification?.body ?? "";
  //   final String imageUrl = message.data['image'] ?? "";

  //   // await AwesomeNotifications().createNotification(
  //   //   content: NotificationContent(
  //   //     title: title,
  //   //     body: body,
  //   //     id: 1,
  //   //     locked: !dimissable,
  //   //     payload: {"type": message.data['type'] ?? ""},
  //   //     channelKey: notificationChannelKey,
  //   //     notificationLayout: NotificationLayout.BigPicture,
  //   //     autoDismissible: dimissable,
  //   //     bigPicture: imageUrl,
  //   //     largeIcon: imageUrl,
  //   //   ),
  //   // );
  // }


}
