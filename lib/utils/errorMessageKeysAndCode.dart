

// ignore: avoid_classes_with_only_static_members
import 'package:yocut/utils/labelKeys.dart';

class ErrorMessageKeysAndCode {
  static const String defaultErrorMessageKey = "defaultErrorMessage";
  static const String noInternetKey = "noInternet";
  static const String internetServerErrorKey = "internetServerError";
  static const String invalidLogInCredentialsKey = "invalidLogInCredentials";
  static const String unauthenticatedAccessKey = "unauthenticatedAccess";

  static const String assignmentAlreadySubmittedKey =
      "assignmentAlreadySubmitted";

  static String invalidUserDetailsKey = "invalidUserDetails";

  static String invalidPasswordKey = "invalidPassword";

  static String canNotSendResetPasswordRequestKey =
      "canNotSendResetPasswordRequest";

  static String examOnlineAttendedKey = "examOnlineAttended";

  static String examOnlineNotStartedYetKey = "examOnlineNotStartedYet";

  static String noOnlineExamReportFoundKey = "noOnlineExamReportFound";
  static String inactiveChildKey = "inactiveChild";
  static String inactiveAccountKey = "inactiveAccount";

  static String notAllowedInDemoVersionKey =
      "This is not allowed in the Test Version.";

  //These are ui side error codes
  static const String internetServerErrorCode = "500";
  static const String fileNotFoundErrorCode = "404";
  static const String permissionNotGivenCode = "300";
  static const String noInternetCode = "301";
  static const String defaultErrorMessageCode = "302";
  static const String noOnlineExamReportFoundCode = "303";
  static const String unauthenticatedErrorCode = "401";
  static const String notAllowedInDemoVersionCode = "112";
  static const String inactiveChildCode = "115";
  static const String inactiveAccountCode = "116";

  //Visit here to watch error message keys and codes
  static String getErrorMessageKeyFromCode(String errorCode) {
    //
    if (errorCode == "101") {
      return invalidLogInCredentialsKey;
    }
    if (errorCode == "104") {
      return assignmentAlreadySubmittedKey;
    }

    if (errorCode == "107") {
      return invalidUserDetailsKey;
    }

    if (errorCode == "108") {
      return canNotSendResetPasswordRequestKey;
    }

    if (errorCode == "109") {
      return invalidPasswordKey;
    }

    if (errorCode == "105") {
      return examOnlineAttendedKey;
    }
    if (errorCode == "106") {
      return examOnlineNotStartedYetKey;
    }
    if (errorCode == notAllowedInDemoVersionCode) {
      return notAllowedInDemoVersionKey;
    }
    if (errorCode == noOnlineExamReportFoundCode) {
      return noOnlineExamReportFoundKey;
    }
    if (errorCode == permissionNotGivenCode) {
      return permissionsNotGivenKey;
    }
    if (errorCode == noInternetCode) {
      return noInternetKey;
    }
    if (errorCode == internetServerErrorCode) {
      return internetServerErrorKey;
    }
    if (errorCode == fileNotFoundErrorCode) {
      return fileDownloadingFailedKey;
    }
    if (errorCode == defaultErrorMessageCode) {
      return defaultErrorMessageKey;
    }
    if (errorCode == inactiveChildCode) {
      return inactiveChildKey;
    }
    if (errorCode == inactiveAccountCode) {
      return inactiveAccountKey;
    }

    if (errorCode == unauthenticatedErrorCode) {
      return unauthenticatedAccessKey;
    } else {
      return defaultErrorMessageKey;
    }
  }
}
