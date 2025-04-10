import 'dart:io';

import 'package:dio/dio.dart';
import 'package:yocut/data/repositories/authRepository.dart';
import 'package:yocut/utils/constants.dart';
import 'package:yocut/utils/errorMessageKeysAndCodes.dart';
import 'package:flutter/foundation.dart';

class ApiException implements Exception {
  String errorMessage;

  ApiException(this.errorMessage);

  @override
  String toString() {
    return errorMessage;
  }
}

// ignore: avoid_classes_with_only_static_members
class Api {
  static Map<String, dynamic> headers() {
    final String jwtToken = AuthRepository().getJwtToken();
    final schoolCode = AuthRepository().schoolCode;

    if (kDebugMode) {
      print(jwtToken);
    }

    return {
      "Authorization": "Bearer $jwtToken",
      "school_code": schoolCode,
      "Accept": "application/json",
    };
  }

  ///[General Apis]
  //Apis that will be use in both student and parent app
  //
  static String logout = "${databaseUrl}logout";
  static String settings = "${databaseUrl}settings";
  static String holidays = "${databaseUrl}holidays";

  static String changePassword = "${databaseUrl}change-password";
  static String getSchoolGallery = "${databaseUrl}gallery";
  static String getSchoolSessionYears = "${databaseUrl}session-years";
  static String getUsers = "${databaseUrl}users";
  static String getUserChatHistory = "${databaseUrl}users/chat/history";
  static String chatMessages = "${databaseUrl}message";
  static String readMessages = "${databaseUrl}message/read";
  static String deleteMessages = "${databaseUrl}delete/message";
  static String schoolDetails = "${baseUrl}/portal/index.php/cut_elearning/api/getHomeData";
  //

  //
  ///[Student app apis]
  //`${this._serverDetails.studentServerDetails}/api/validateToken/${reg}/${token}`
  static String studentLogin = "$baseUrl/portal/index.php/portal/login/authenticate";
  static String validateToken = "$baseUrl/portal/index.php/cut_elearning/api/validateToken";
  static String studentData = "$baseUrl/portal/index.php/cut_elearning/api/getHomeData";
  static String studentProfile = "${databaseUrl}student/get-profile-data";
  // static String studentSubjects = "${databaseUrl}student/subjects";
  //get subjects of given class
  static String classSubjects = "${databaseUrl}student/class-subjects";
  static String studentTimeTable = "${databaseUrl}student/timetable";
  static String studentExamList = "${databaseUrl}student/get-exam-list";

  static String getSchoolSettingDetails =
      "${databaseUrl}student/school-settings";

  static String studentExamDetails = "${databaseUrl}student/get-exam-details";
  static String selectStudentElectiveSubjects =
      "${databaseUrl}student/select-subjects";
  static String getLessonsOfSubject = "${databaseUrl}student/lessons";
  static String getstudyMaterialsOfTopic =
      "${databaseUrl}student/lesson-topics";
  static String getStudentAttendance = "${databaseUrl}student/attendance";
  static String getAssignments = "${databaseUrl}student/assignments";
  static String submitAssignment = "${databaseUrl}student/submit-assignment";
  static String generalAnnouncements = "${databaseUrl}student/announcements";
  static String guardianDetailsOfStudent =
      "${databaseUrl}student/guradian-details";
  static String deleteAssignment =
      "${databaseUrl}student/delete-assignment-submission";

  static String studentResults = "${databaseUrl}student/exam-marks";
  static String requestResetPassword = "${databaseUrl}student/forgot-password";

  static String studentExamOnlineList =
      "${databaseUrl}student/get-online-exam-list";
  static String studentExamOnlineQuestions =
      "${databaseUrl}student/get-online-exam-questions";
  static String studentSubmitOnlineExamAnswers =
      "${databaseUrl}student/submit-online-exam-answers";

  static String studentOnlineExamResultList =
      "${databaseUrl}student/get-online-exam-result-list";

  static String studentOnlineExamResult =
      "${databaseUrl}student/get-online-exam-result";

  static String studentOnlineExamReport =
      "${databaseUrl}student/get-online-exam-report";
  static String studentAssignmentReport =
      "${databaseUrl}student/get-assignments-report";

  static String getStudentSliders = "${databaseUrl}student/sliders";

  //
  ///[Parent app apis]
  //
  static String subjectsByChildId = "${databaseUrl}parent/subjects";
  static String parentLogin = "${databaseUrl}parent/login";

  //
  static String childProfileDetails =
      "${databaseUrl}parent/get-child-profile-data";
  static String lessonsOfSubjectParent = "${databaseUrl}parent/lessons";
  static String getstudyMaterialsOfTopicParent =
      "${databaseUrl}parent/lesson-topics";
  static String getAssignmentsParent = "${databaseUrl}parent/assignments";
  static String getParentChildSchoolSettingDetails =
      "${databaseUrl}parent/school-settings";
  static String getStudentAttendanceParent = "${databaseUrl}parent/attendance";
  static String getStudentTimetableParent = "${databaseUrl}parent/timetable";
  static String getStudentExamListParent = "${databaseUrl}parent/get-exam-list";
  static String getStudentResultsParent = "${databaseUrl}parent/exam-marks";
  static String getStudentExamDetailsParent =
      "${databaseUrl}parent/get-exam-details";

  static String generalAnnouncementsParent =
      "${databaseUrl}parent/announcements";

  static String getStudentTeachersParent = "${databaseUrl}parent/teachers";
  static String forgotPassword = "${databaseUrl}forgot-password";

  static String getStudentFeesDetailParent = "${databaseUrl}parent/fees";
  static String addFeesTransaction =
      "${databaseUrl}parent/add-fees-transaction";
  static String failPaymentTransaction =
      "${databaseUrl}parent/fail-payment-transaction";
  static String storeFeesParent = "${databaseUrl}parent/store-fees";

  static String getPaidFeesListParent = "${databaseUrl}parent/fees-paid-list";
  static String downloadFeesPaidReceiptParent =
      "${databaseUrl}parent/fees-paid-receipt-pdf";

  static String parentExamOnlineList =
      "${databaseUrl}parent/get-online-exam-list";
  static String parentOnlineExamResultList =
      "${databaseUrl}parent/get-online-exam-result-list";
  static String parentOnlineExamResult =
      "${databaseUrl}parent/get-online-exam-result";
  static String parentOnlineExamReport =
      "${databaseUrl}parent/get-online-exam-report";
  static String parentAssignmentReport =
      "${databaseUrl}parent/get-assignments-report";

  static String getFeesTransactions =
      "${databaseUrl}parent/fees-transactions-list";

  static String getParentSliders = "${databaseUrl}parent/sliders";

  static String payChildCompulsoryFees =
      "${databaseUrl}parent/fees/compulsory/pay";

  static String payChildOptionalFees = "${databaseUrl}parent/fees/optional/pay";
  static String confirmPayment = "${databaseUrl}payment-confirmation";
  static String getTransactions = "${databaseUrl}payment-transactions";
  static String downloadFeeReceipt = "${databaseUrl}parent/fees/receipt";
  static String downloadStudentResult = "${databaseUrl}student-exan-result-pdf";

  //

  static Future<Map<String, dynamic>> post({
    required Map<String, dynamic> body,
    required String url,
    required bool useAuthToken,
    Map<String, dynamic>? queryParameters,
    CancelToken? cancelToken,
    Function(int, int)? onSendProgress,
    Function(int, int)? onReceiveProgress,
  }) async {
    try {
      final Dio dio = Dio();
      final FormData formData = FormData.fromMap(
        body,
        ListFormat.multiCompatible,
      );
      if (kDebugMode) {
        print("API Called POST: $url with $body");
        print("Body Params: $body");
      }
      final response = await dio.post(
        url,
        data: formData,
        queryParameters: queryParameters,
        cancelToken: cancelToken,
        onReceiveProgress: onReceiveProgress,
        onSendProgress: onSendProgress,
        options: useAuthToken ? Options(headers: headers()) : null,
      );

      if (bool.parse(response.data['error'].toString())) {
        throw ApiException(response.data['message'].toString());
      }

      if (kDebugMode) {
        print("Response: ${response.data}");
      }
      return Map.from(response.data);
    } on DioException catch (e) {
      if (kDebugMode) {
        print(e.response?.data);
      }
      if (e.response?.statusCode == 503 || e.response?.statusCode == 500) {
        throw ApiException(ErrorMessageKeysAndCode.internetServerErrorCode);
      }

      throw ApiException(
        e.error is SocketException
            ? ErrorMessageKeysAndCode.noInternetCode
            : ErrorMessageKeysAndCode.defaultErrorMessageCode,
      );
    } on ApiException catch (e) {
      throw ApiException(e.errorMessage);
    } catch (e) {
      throw ApiException(ErrorMessageKeysAndCode.defaultErrorMessageKey);
    }
  }

  static Future<Map<String, dynamic>> get({
    required String url,
    required bool useAuthToken,
    Map<String, dynamic>? queryParameters,
  }) async {
    try {
      final Dio dio = Dio();

      if (kDebugMode) {
        print(url);
        print(queryParameters);
      }

      final response = await dio.get(
        url,
        queryParameters: queryParameters,
        options: useAuthToken ? Options(headers: headers()) : null,
      );

      if (response.data['error']) {
        if (kDebugMode) {
          print("Url $url");
          print(response.data);
        }
        throw ApiException(response.data['code'].toString());
      }

      return Map.from(response.data);
    } on DioException catch (e) {
      if (kDebugMode) {
        print("Url is $url");
        print(e.response?.data);
        print(e.response?.statusCode);
      }

      if (e.response?.statusCode == 401) {
        throw ApiException(ErrorMessageKeysAndCode.unauthenticatedErrorCode);
      }
      if (e.response?.statusCode == 503 || e.response?.statusCode == 500) {
        throw ApiException(ErrorMessageKeysAndCode.internetServerErrorCode);
      }
      throw ApiException(
        e.error is SocketException
            ? ErrorMessageKeysAndCode.noInternetCode
            : ErrorMessageKeysAndCode.defaultErrorMessageCode,
      );
    } on ApiException catch (e) {
      throw ApiException(e.errorMessage);
    } catch (e) {
      if (kDebugMode) {
        print(e.toString());
      }
      throw ApiException(ErrorMessageKeysAndCode.defaultErrorMessageKey);
    }
  }

  static Future<void> download({
    required String url,
    required CancelToken cancelToken,
    required String savePath,
    required Function updateDownloadedPercentage,
  }) async {
    try {
      final Dio dio = Dio();

      await dio.download(
        url,
        savePath,
        cancelToken: cancelToken,
        onReceiveProgress: (count, total) {
          final double percentage = (count / total) * 100;
          updateDownloadedPercentage(percentage < 0.0 ? 99.0 : percentage);
        },
      );
    } on DioException catch (e) {
      if (e.response?.statusCode == 503 || e.response?.statusCode == 500) {
        throw ApiException(ErrorMessageKeysAndCode.internetServerErrorCode);
      }
      if (e.response?.statusCode == 404) {
        throw ApiException(ErrorMessageKeysAndCode.fileNotFoundErrorCode);
      }
      throw ApiException(
        e.error is SocketException
            ? ErrorMessageKeysAndCode.noInternetCode
            : ErrorMessageKeysAndCode.defaultErrorMessageCode,
      );
    } on ApiException catch (e) {
      throw ApiException(e.errorMessage);
    } catch (e) {
      throw ApiException(ErrorMessageKeysAndCode.defaultErrorMessageKey);
    }
  }
}
