import 'dart:convert';

import 'package:dio/dio.dart';
import 'package:yocut/data/models/guardian.dart';
import 'package:yocut/data/models/sessionYear.dart';
import 'package:yocut/data/models/attendanceDay.dart';
import 'package:yocut/data/models/coreSubject.dart';
import 'package:yocut/data/models/electiveSubject.dart';
import 'package:yocut/data/models/exam.dart';
import 'package:yocut/data/models/result.dart';
import 'package:yocut/data/models/student.dart';
import 'package:yocut/data/models/timeTableSlot.dart';
import 'package:yocut/utils/stripeService.dart';
import 'package:yocut/utils/api.dart';
import 'package:yocut/utils/errorMessageKeysAndCodes.dart';
import 'package:yocut/utils/hiveBoxKeys.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart';
import 'package:hive_flutter/hive_flutter.dart';

class StudentRepository {
  //LocalDataSource
  Future<void> setLocalCoreSubjects(List<CoreSubject> subjects) async {
    final box = Hive.box(studentSubjectsBoxKey);
    List<Map<String, dynamic>> jsonSubjects =
        subjects.map((e) => e.toJson()).toList();

    box.put(coreSubjectsHiveKey, jsonSubjects);
  }

  Future<void> setLocalElectiveSubjects(List<ElectiveSubject> subjects) async {
    final box = Hive.box(studentSubjectsBoxKey);
    List<Map<String, dynamic>> jsonSubjects =
        subjects.map((e) => e.toJson()).toList();

    box.put(electiveSubjectsHiveKey, jsonSubjects);
  }

  List<CoreSubject> getLocalCoreSubjects() {
    final coreSubjects =
        (Hive.box(studentSubjectsBoxKey).get(coreSubjectsHiveKey) ?? [])
            as List;

    return coreSubjects
        .map((e) => CoreSubject.fromJson(json: Map.from(e)))
        .toList();
  }

  List<ElectiveSubject> getLocalElectiveSubjects() {
    final electiveSubjects =
        (Hive.box(studentSubjectsBoxKey).get(electiveSubjectsHiveKey) ?? [])
            as List;

    return electiveSubjects
        .map(
          (e) => ElectiveSubject.fromJson(
            electiveSubjectGroupId: 0,
            json: Map.from(e),
          ),
        )
        .toList();
  }

  Future<Map<String, dynamic>> fetchSubjects() async {         
    try {
      // final result =
      //     await Api.get(url: Api.studentSubjects, useAuthToken: true);

      // final coreSubjects = (result['data']['core_subject'] as List).map((e) {
      //   return CoreSubject.fromJson(json: Map.from(e ?? {}));
      // }).toList();


      // final electiveSubjects =
      //     ((result['data']['elective_subject'] ?? []) as List).map(
      //   (e) {
      //     Map<String, dynamic> subjectDetails =
      //         Map.from(e['class_subject']['subject']);
      //     subjectDetails['class_subject_id'] = e['class_subject_id'];

      //     return ElectiveSubject.fromJson(
      //       electiveSubjectGroupId: 0,
      //       json: subjectDetails,
      //     );
      //   },
      // ).toList();

      return {
        "coreSubjects": coreSubjects,
        "electiveSubjects": electiveSubjects,
        "doesClassHaveElectiveSubjects":
            result['data']?['elective_subject'] != null
      };
    } catch (e) {
      throw ApiException(e.toString());
    }
  }

  Future<void> selectElectiveSubjects({
    required Map<int, List<int>> electedSubjectGroups,
  }) async {
    try {
      final electedSubjectGroupIds = electedSubjectGroups.keys
          .map((key) =>
              {"id": key, "class_subject_id": electedSubjectGroups[key]})
          .toList();

      final body = {"subject_group": electedSubjectGroupIds};

      await Api.post(
        url: Api.selectStudentElectiveSubjects,
        useAuthToken: true,
        body: body,
      );
    } catch (e) {
      throw ApiException(e.toString());
    }
  }

  Future<Guardian> fetchGuardianDetails() async {
    try {
      final result = await Api.get(
        url: Api.guardianDetailsOfStudent,
        useAuthToken: true,
      );
      return Guardian.fromJson(Map.from(result['data']['guardian'] ?? {}));
    } catch (e) {
      throw ApiException(e.toString());
    }
  }

  Future<List<TimeTableSlot>> fetchTimeTable({
    required bool useParentApi,
    required int childId,
  }) async {
    try {
      final result = await Api.get(
        url:
            useParentApi ? Api.getStudentTimetableParent : Api.studentTimeTable,
        useAuthToken: true,
        queryParameters: useParentApi ? {"child_id": childId} : null,
      );

      return (result['data'] as List)
          .map((e) => TimeTableSlot.fromJson(Map.from(e)))
          .toList();
    } catch (e) {
      throw ApiException(e.toString());
    }
  }

  Future<Map<String, dynamic>> fetchExamResults({
    int? page,
    required bool useParentApi,
    required int childId,
  }) async {
    try {
      Map<String, dynamic> queryParameters = {"page": page ?? 0};
      if (queryParameters['page'] == 0) {
        queryParameters.remove('page');
      }
      if (useParentApi) {
        queryParameters.addAll({"child_id": childId});
      }
      final result = await Api.get(
        url: useParentApi ? Api.getStudentResultsParent : Api.studentResults,
        useAuthToken: true,
        queryParameters: queryParameters,
      );

      return {
        "results": ((result['data'] ?? []) as List)
            .map((result) => Result.fromJson(Map.from(result)))
            .toList()
      };
    } catch (e, stc) {
      if (kDebugMode) {
        print(stc.toString());
      }
      throw ApiException(e.toString());
    }
  }

  Future<Map<String, dynamic>> fetchAttendance({
    required int month,
    required int year,
    required bool useParentApi,
    required int childId,
  }) async {
    try {
      Map<String, dynamic> queryParameters = {
        "month": month,
        "year": year,
      };

      if (useParentApi) {
        queryParameters.addAll({"child_id": childId});
      }

      final result = await Api.get(
        url: useParentApi
            ? Api.getStudentAttendanceParent
            : Api.getStudentAttendance,
        queryParameters: queryParameters,
        useAuthToken: true,
      );

      return {
        "attendanceDays": (result['data']['attendance'] as List)
            .map((attendance) => AttendanceDay.fromJson(Map.from(attendance)))
            .toList(),
        "sessionYear":
            SessionYear.fromJson(Map.from(result['data']['session_year'] ?? {}))
      };
    } catch (e) {
      throw ApiException(e.toString());
    }
  }

  //
  //This method is used to fetch exams list
  Future<List<Exam>> fetchExamsList({
    required bool useParentApi,
    required int childId,
    required int examStatus,
  }) async {
    try {
      final result = await Api.get(
        url: useParentApi ? Api.getStudentExamListParent : Api.studentExamList,
        useAuthToken: true,
        queryParameters: useParentApi
            ? {"child_id": childId, 'status': examStatus}
            : {'status': examStatus},
      );

      return (result['data'] as List)
          .map((e) => Exam.fromExamJson(Map.from(e)))
          .toList();
    } catch (e) {
      throw ApiException(e.toString());
    }
  }

  //
  //This method is used to fetch time-table of particular exam
  Future<List<ExamTimeTable>> fetchExamTimeTable({
    required bool useParentApi,
    required int childId,
    required int examId,
  }) async {
    try {
      final result = await Api.get(
        url: useParentApi
            ? Api.getStudentExamDetailsParent
            : Api.studentExamDetails,
        useAuthToken: true,
        queryParameters: useParentApi
            ? {"child_id": childId, "exam_id": examId}
            : {"exam_id": examId},
      );

      return (result['data'] as List)
          .map((e) => ExamTimeTable.fromJson(Map.from(e)))
          .toList();
    } catch (e) {
      throw ApiException(e.toString());
    }
  }

  /*
  Future<List<PaidFees>> fetchFeesList({required int childId}) async {
    try {
      final result = await Api.get(
        url: Api.getPaidFeesListParent,
        useAuthToken: true,
        queryParameters: {
          "child_id": childId,
        },
      );
      if (kDebugMode) {
        print("response -- ${result['data'] as List}");
      }
      return (result['data'] as List)
          .map((e) => PaidFees.fromJson(Map.from(e)))
          .toList();
    } catch (e) {
      throw ApiException(e.toString());
    }
  }
  */

  Future<Uint8List> downloadFeesReceipt({
    required int feesPaidId,
  }) async {
    try {
      final result = await Api.get(
        url: Api.downloadFeesPaidReceiptParent,
        useAuthToken: true,
        queryParameters: {
          "fees_paid_id": feesPaidId,
        },
      );
      return base64Decode(result['pdf']);
    } catch (e) {
      throw ApiException(e.toString());
    }
  }

/*
  Future<Map> addFeesTransaction({
    required double transactionAmount,
    required int childId,
    required int typeOfFee,
    required bool isFullyPaid,
    required double? paidDueCharges,
    double? compulsoryAmountPaid,
    double? dueChargesPaid,
    required int feesType, //0 = compulsory, 1 = installments, 2 = optional
    required List<FeesData> selectedFees,
  }) async {
    try {
      final body = {
        "child_id": childId,
        "amount": transactionAmount.toStringAsFixed(2),
        "type_of_fee": typeOfFee,
        "is_fully_paid": isFullyPaid ? "1" : "0",
        if (feesType == 0 && paidDueCharges != null)
          "due_charges": paidDueCharges.toStringAsFixed(2),
        // if (feesType == 0)
        //   "compulsory_amount_paid": compulsoryAmountPaid!.toStringAsFixed(2),
        if (feesType == 1)
          "installment_data": selectedFees
              .map(
                (e) => {
                  "id": e.id,
                  "name": e.name,
                  "amount": e.amount!.toStringAsFixed(2),
                  if (e.isDue && e.dueChargesAmount != null)
                    "due_charges": e.dueChargesAmount!.toStringAsFixed(2)
                },
              )
              .toList(),
        if (feesType == 2)
          "optional_fees_data": selectedFees
              .map(
                (e) => {
                  "id": e.id,
                  "amount": e.amount!.toStringAsFixed(2),
                },
              )
              .toList()
      };

      final result = await Api.post(
        body: body,
        url: Api.addFeesTransaction,
        useAuthToken: true,
      );
      return result["payment_gateway_details"];
    } catch (e) {
      throw ApiException(e.toString());
    }
  }
*/

  Future<void> storeFees({
    required String transactionId,
    required int childId,
    String? paymentId,
    String? paymentSignature,
  }) async {
    try {
      await Api.post(
        url: Api.storeFeesParent,
        useAuthToken: true,
        body: {
          "transaction_id": transactionId,
          "child_id": childId,
          if (paymentId != null) "payment_id": paymentId,
          if (paymentSignature != null) "payment_signature": paymentSignature,
        },
      );
    } catch (e) {
      throw ApiException(e.toString());
    }
  }

  Future<void> failPaymentTransaction({
    required String transactionId,
  }) async {
    try {
      await Api.post(
        url: Api.failPaymentTransaction,
        body: {
          "payment_transaction_id": transactionId,
        },
        useAuthToken: true,
      );
    } catch (_) {}
  }

  Future<String> confirmStripePayment({
    required String paymentIntentId,
    required String paymentSecretKey,
  }) async {
    try {
      final response = await Dio().post(
        '${StripeService.paymentApiUrl}/$paymentIntentId',
        options: Options(
          headers: {
            'Authorization': 'Bearer $paymentSecretKey',
            'Content-Type': 'application/x-www-form-urlencoded'
          },
        ),
      );
      final getdata = Map.from(response.data);
      final statusOfTransaction = (getdata['status'] ?? "").toString();
      return statusOfTransaction;
    } on PlatformException catch (err) {
      if (kDebugMode) {
        print(err);
      }
      throw ApiException(
        StripeService.getPlatformExceptionErrorResult(err).message ??
            ErrorMessageKeysAndCode.defaultErrorMessageCode,
      );
    } catch (error) {
      if (kDebugMode) {
        print(error);
      }
      throw ApiException(ErrorMessageKeysAndCode.defaultErrorMessageCode);
    }
  }

  Future<Student> fetchStudentFullProfileDetails(
      {required bool useParentApi, int? childId}) async {
    try {
      Map<String, dynamic> body = {};
      if (useParentApi) {
        body['child_id'] = childId;
      }
      return Student.fromJson(
        await Api.get(
                url:
                    useParentApi ? Api.childProfileDetails : Api.studentProfile,
                queryParameters: body,
                useAuthToken: true)
            .then((value) => value['data']),
      );
    } catch (e) {
      throw ApiException(e.toString());
    }
  }
}
