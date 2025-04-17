import 'dart:io';

import 'package:device_info_plus/device_info_plus.dart';
import 'package:yocut/cubits/appLocalizationCubit.dart';
import 'package:yocut/cubits/downloadFileCubit.dart';
import 'package:yocut/cubits/schoolConfigurationCubit.dart';
import 'package:yocut/data/models/studyMaterial.dart';
import 'package:yocut/data/repositories/subjectRepository.dart';
import 'package:yocut/ui/widgets/downloadFileBottomsheetContainer.dart';
import 'package:yocut/ui/widgets/errorMessageOverlayContaineer.dart';
import 'package:yocut/utils/constants.dart';
import 'package:yocut/utils/errorMessageKeysAndCodes.dart';
import 'package:yocut/utils/labelKeys.dart';
import 'package:yocut/utils/systemModules.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart' as intl;
// import 'package:open_filex/open_filex.dart';
import 'package:package_info_plus/package_info_plus.dart';
import 'package:permission_handler/permission_handler.dart';

// ignore: avoid_classes_with_only_static_members
class Utils {
  //This extra padding will add to MediaQuery.of(context).padding.top in orderto give same top padding in every screen

  static double screenContentTopPadding = 15.0;
  static double screenContentHorizontalPadding = 25.0;
  static double screenTitleFontSize = 18.0;
  static double screenOnbordingTitleFontSize = 25.0;
  static double screenContentHorizontalPaddingInPercentage = 0.075;

  static double screenSubTitleFontSize = 14.0;
  static double extraScreenContentTopPaddingForScrolling = 0.0275;
  static double appBarSmallerHeightPercentage = 0.15;

  static double appBarMediumtHeightPercentage = 0.18;

  static double bottomNavigationHeightPercentage = 0.08;
  static double bottomNavigationBottomMargin = 25;

  static double appBarBiggerHeightPercentage = 0.215;
  static double appBarContentTopPadding = 25.0;
  static double bottomSheetTopRadius = 20.0;
  static double subjectFirstLetterFontSize = 20;

  static double defaultProfilePictureHeightAndWidthPercentage = 0.175;

  static double questionContainerHeightPercentage = 0.725;

  static Duration tabBackgroundContainerAnimationDuration =
      const Duration(milliseconds: 300);

  static Duration showCaseDisplayDelayInDuration =
      const Duration(milliseconds: 350);
  static Curve tabBackgroundContainerAnimationCurve = Curves.easeInOut;

  static double shimmerLoadingContainerDefaultHeight = 7;

  static int defaultShimmerLoadingContentCount = 6;

  // static GlobalKey<NavigatorState> rootNavigatorKey =
  //     GlobalKey<NavigatorState>();


  static final List<String> weekDays = [
    mondayKey,
    tuesdayKey,
    wednesdayKey,
    thursdayKey,
    fridayKey,
    saturdayKey,
    sundayKey
  ];

  static final List<String> weekDaysFullForm = [
    "Monday",
    "Tuesday",
    "Wednesday",
    "Thursday",
    "Friday",
    "Saturday",
    "Sunday"
  ];

  //to give bottom scroll padding in screen where
  //bottom navigation bar is displayed
  static double getScrollViewBottomPadding(BuildContext context) {
    return MediaQuery.of(context).size.height *
            (Utils.bottomNavigationHeightPercentage) +
        Utils.bottomNavigationBottomMargin * (1.5);
  }

  //to give top scroll padding to screen content
  //
  static double getScrollViewTopPadding({
    required BuildContext context,
    required double appBarHeightPercentage,
  }) {
    return MediaQuery.of(context).size.height *
        (appBarHeightPercentage + extraScreenContentTopPaddingForScrolling);
  }

  static String getImagePath(String imageName) {
    return "assets/images/$imageName";
  }

  static ColorScheme getColorScheme(BuildContext context) {
    return Theme.of(context).colorScheme;
  }

  static Locale getLocaleFromLanguageCode(String languageCode) {
    List<String> result = languageCode.split("-");
    return result.length == 1
        ? Locale(result.first)
        : Locale(result.first, result.last);
  }

  static String getTranslatedLabel(String labelKey) {
    return labelKey.tr.trim();
  }

  static Future<dynamic> showBottomSheet({
    required Widget child,
    required BuildContext context,
    bool? enableDrag,
  }) async {
    final result = await Get.bottomSheet(
      child,
      enableDrag: enableDrag ?? false,
      isScrollControlled: true,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(bottomSheetTopRadius),
          topRight: Radius.circular(bottomSheetTopRadius),
        ),
      ),
    );

    return result;
  }

  static bool isTodayInSessionYear(DateTime firstDate, DateTime lastDate) {
    final currentDate = DateTime.now();

    return (currentDate.isAfter(firstDate) && currentDate.isBefore(lastDate)) ||
        isSameDay(firstDate) ||
        isSameDay(lastDate);
  }

  static bool isSameDay(DateTime dateTime) {
    final currentDate = DateTime.now();
    return (currentDate.day == dateTime.day) &&
        (currentDate.month == dateTime.month) &&
        (currentDate.year == dateTime.year);
  }

  static String getMonthName(int monthNumber) {
    return months[monthNumber - 1];
  }

  static int getMonthNumber(String monthName) {
    return (months.indexWhere((element) => element == monthName)) + 1;
  }

  static List<String> buildMonthYearsBetweenTwoDates(
    DateTime startDate,
    DateTime endDate,
  ) {
    List<String> dateTimes = [];
    DateTime current = startDate;
    while (current.difference(endDate).isNegative) {
      current = current.add(const Duration(days: 24));
      dateTimes.add("${getMonthName(current.month)}, ${current.year}");
    }
    return dateTimes.toSet().toList();
  }

  static String formatTime(String time) {
    final hourMinuteSecond = time.split(":");
    final hour = int.parse(hourMinuteSecond.first) < 13
        ? int.parse(hourMinuteSecond.first)
        : int.parse(hourMinuteSecond.first) - 12;
    final amOrPm = int.parse(hourMinuteSecond.first) > 12 ? "PM" : "AM";
    return "${hour.toString().padLeft(2, '0')}:${hourMinuteSecond[1]} $amOrPm";
  }

  static String formatAssignmentDueDate(
    DateTime dateTime,
    BuildContext context,
  ) {
    final monthName = Utils.getMonthName(dateTime.month);
    final hour = dateTime.hour < 13 ? dateTime.hour : dateTime.hour - 12;
    final amOrPm = hour > 12 ? "PM" : "AM";
    return "${Utils.getTranslatedLabel(dueKey)}, ${dateTime.day} $monthName ${dateTime.year}, ${hour.toString().padLeft(2, '0')}:${dateTime.minute.toString().padLeft(2, '0')} $amOrPm";
  }

  static Future<void> showCustomSnackBar({
    required BuildContext context,
    required String errorMessage,
    required Color backgroundColor,
    Duration delayDuration = errorMessageDisplayDuration,
  }) async {
    OverlayState? overlayState = Overlay.of(context);
    OverlayEntry overlayEntry = OverlayEntry(
      builder: (context) => ErrorMessageOverlayContainer(
        backgroundColor: backgroundColor,
        errorMessage: errorMessage,
      ),
    );

    overlayState.insert(overlayEntry);
    await Future.delayed(delayDuration);
    overlayEntry.remove();
  }

  static String getErrorMessageFromErrorCode(
    BuildContext context,
    String errorCode,
  ) {
    return Utils.getTranslatedLabel(
      ErrorMessageKeysAndCode.getErrorMessageKeyFromCode(errorCode),
    );
  }

  //0 = Pending/In Review , 1 = Accepted , 2 = Rejected
  static String getAssignmentSubmissionStatusKey(int status) {
    if (status == 0) {
      return inReviewKey;
    }
    if (status == 1) {
      return acceptedKey;
    }
    if (status == 2) {
      return rejectedKey;
    }
    if (status == 3) {
      return resubmittedKey;
    }
    return "";
  }

  static String getBackButtonPath(BuildContext context) {
    return Directionality.of(context).name == TextDirection.rtl.name
        ? getImagePath("rtl_back_icon.svg")
        : getImagePath("back_icon.svg");
  }

  static void openDownloadBottomsheet({
    required BuildContext context,
    required bool storeInExternalStorage,
    required StudyMaterial studyMaterial,
  }) {
    showBottomSheet(
      child: BlocProvider<DownloadFileCubit>(
        create: (context) => DownloadFileCubit(SubjectRepository()),
        child: DownloadFileBottomsheetContainer(
          storeInExternalStorage: storeInExternalStorage,
          studyMaterial: studyMaterial,
        ),
      ),
      context: context,
    ).then((result) {
      if (result != null) {
        if (result['error']) {
          showCustomSnackBar(
            context: context,
            errorMessage: getErrorMessageFromErrorCode(
              context,
              result['message'].toString(),
            ),
            backgroundColor: Theme.of(context).colorScheme.error,
          );
        } else {
          try {
            // OpenFilex.open(result['filePath'].toString());
          } catch (e) {
            showCustomSnackBar(
              context: context,
              errorMessage: getTranslatedLabel(
                storeInExternalStorage
                    ? fileDownloadedSuccessfullyKey
                    : unableToOpenKey,
              ),
              backgroundColor: Theme.of(context).colorScheme.error,
            );
          }
        }
      }
    });
  }

  static intl.DateFormat hourMinutesDateFormat = intl.DateFormat.jm();

  static String formatDateAndTime(DateTime dateTime) {
    return intl.DateFormat("dd-MM-yyyy  kk:mm").format(dateTime);
  }

  static String formatDate(DateTime dateTime) {
    return "${dateTime.day.toString().padLeft(2, '0')}-${dateTime.month.toString().padLeft(2, '0')}-${dateTime.year}";
  }

  static String dateConverter(
    DateTime myEndDate,
    BuildContext contxt,
    bool fromResult,
  ) {
    String date;

    final formattedDate = intl.DateFormat('dd MMM, yyyy',
            contxt.read<AppLocalizationCubit>().state.language.languageCode)
        .add_jm()
        .format(myEndDate);

    final formattedTime = intl.DateFormat('hh:mm a').format(myEndDate);
    //check for today or tomorrow or specific date
    final now = DateTime.now();
    final today = DateTime(now.year, now.month, now.day);
    final tomorrow = today.add(Duration(days: 1));
    final checkEndDate =
        DateTime(myEndDate.year, myEndDate.month, myEndDate.day);

    if (checkEndDate == today) {
      date = fromResult
          ? "${Utils.getTranslatedLabel(submittedKey)} : ${Utils.getTranslatedLabel(todayKey)}" //
          : "${Utils.getTranslatedLabel(todayKey)}, $formattedTime";
    } else if (checkEndDate == tomorrow) {
      date = fromResult
          ? "${Utils.getTranslatedLabel(submittedKey)} : ${Utils.getTranslatedLabel(tomorrowKey)}"
          : "${Utils.getTranslatedLabel(tomorrowKey)}, $formattedTime";
    } else {
      date = fromResult
          ? '${Utils.getTranslatedLabel(submittedKey)} : $formattedDate'
          : formattedDate;
    }
    return date;
  }

  //It will return - if given value is empty
  static String formatEmptyValue(String value) {
    return value.isEmpty ? "-" : value;
  }

  static Future<bool> forceUpdate(String updatedVersion) async {
    PackageInfo packageInfo = await PackageInfo.fromPlatform();
    String currentVersion = "${packageInfo.version}+${packageInfo.buildNumber}";
    if (updatedVersion.isEmpty) {
      return false;
    }

    final bool updateBasedOnVersion = _shouldUpdateBasedOnVersion(
      currentVersion.split("+").first,
      updatedVersion.split("+").first,
    );

    if (updatedVersion.split("+").length == 1 ||
        currentVersion.split("+").length == 1) {
      return updateBasedOnVersion;
    }

    final bool updateBasedOnBuildNumber = _shouldUpdateBasedOnBuildNumber(
      currentVersion.split("+").last,
      updatedVersion.split("+").last,
    );

    return updateBasedOnVersion || updateBasedOnBuildNumber;
  }

  static bool _shouldUpdateBasedOnVersion(
    String currentVersion,
    String updatedVersion,
  ) {
    List<int> currentVersionList =
        currentVersion.split(".").map((e) => int.parse(e)).toList();
    List<int> updatedVersionList =
        updatedVersion.split(".").map((e) => int.parse(e)).toList();

    if (updatedVersionList[0] > currentVersionList[0]) {
      return true;
    }
    if (updatedVersionList[1] > currentVersionList[1]) {
      return true;
    }
    if (updatedVersionList[2] > currentVersionList[2]) {
      return true;
    }

    return false;
  }

  static bool _shouldUpdateBasedOnBuildNumber(
    String currentBuildNumber,
    String updatedBuildNumber,
  ) {
    return int.parse(updatedBuildNumber) > int.parse(currentBuildNumber);
  }

  static String getLottieAnimationPath(String animationName) {
    return "assets/animations/$animationName";
  }

  static void showFeatureDisableInDemoVersion(BuildContext context) {
    showCustomSnackBar(
      context: context,
      errorMessage: Utils.getTranslatedLabel(featureDisableInDemoVersionKey),
      backgroundColor: Theme.of(context).colorScheme.error,
    );
  }

  //0 = Pending , 1 = Paid, 2 = Partially Paid ˆset according to API response.
  static String getStudentFeesStatusKey(int status) {
    if (status == 0) {
      return pendingKey;
    }
    if (status == 1) {
      return paidKey;
    }
    if (status == 2) {
      return partiallyPaidKey;
    }
    return "";
  }

  static bool isModuleEnabled(
      {required BuildContext context, required String moduleId}) {
    final enabledFeatures = context
        .read<SchoolConfigurationCubit>()
        .getSchoolConfiguration()
        .body.profile.firstName;

        pr

    //Module id will have "1" or "1#2".
    final ids = moduleId.split(moduleIdJoiner).toList();
    if (ids.contains(defaultModuleId.toString())) {
      return true;
    }

    bool featureEnabled = false;
    for (var i = 0; i < ids.length; i++) {
      // if (enabledFeatures.containsKey(ids[i].toString())) {
      //   featureEnabled = true;
      //   break;
      // }
    }

    //
    return featureEnabled;
  }

  static Future<bool> hasStoragePermissionGiven() async {
    if (Platform.isIOS) {
      bool permissionGiven = await Permission.storage.isGranted;
      if (!permissionGiven) {
        permissionGiven = (await Permission.storage.request()).isGranted;
        return permissionGiven;
      }
      return permissionGiven;
    }

    //if it is for android
    final deviceInfoPlugin = DeviceInfoPlugin();
    final androidDeviceInfo = await deviceInfoPlugin.androidInfo;
    if (androidDeviceInfo.version.sdkInt < 33) {
      bool permissionGiven = await Permission.storage.isGranted;
      if (!permissionGiven) {
        permissionGiven = (await Permission.storage.request()).isGranted;
        return permissionGiven;
      }
      return permissionGiven;
    } else {
      bool permissionGiven = await Permission.photos.isGranted;
      if (!permissionGiven) {
        permissionGiven = (await Permission.photos.request()).isGranted;
        return permissionGiven;
      }
      return permissionGiven;
    }
  }
}

extension DateTimeExtension on DateTime {
  bool isSameDayAs(DateTime other) =>
      day == other.day &&
      month == other.month &&
      year == other.year;

  String get relativeFormatedDate {
    final today = DateTime.now();
    final yesterday = today.subtract(const Duration(days: 1));

    if (isSameDayAs(today)) {
      return "today";
    } else if (isSameDayAs(yesterday)) {
      return "yesterday";
    } else {
      return intl.DateFormat('d MMMM yyyy').format(this);
    }
  }
}

extension EmptyPadding on num {
  SizedBox get sizedBoxHeight => SizedBox(height: toDouble());
  SizedBox get sizedBoxWidth => SizedBox(width: toDouble());
}
