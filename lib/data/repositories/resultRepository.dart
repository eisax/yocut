import 'package:yocut/data/models/resultOnline.dart';
import 'package:yocut/data/models/resultOnlineDetails.dart';
import 'package:yocut/utils/api.dart';
import 'package:flutter/foundation.dart';

class ResultRepository {
  Future<Map<String, dynamic>> getResultOnline({
    int? page,
    required int classSubjectId,
    required bool useParentApi,
    required int childId,
  }) async {
    try {
      final result = await Api.get(
        url: useParentApi
            ? Api.parentOnlineExamResultList
            : Api.studentOnlineExamResultList,
        useAuthToken: true,
        queryParameters: {
          if (classSubjectId != 0) 'class_subject_id': classSubjectId,
          if (page != 0) 'page': page ?? 1,
          if (useParentApi) 'child_id': childId,
        },
      );

      return {
        "results": (result['data']['data'] as List)
            .map((e) => ResultOnline.fromJson(Map.from(e)))
            .toList(),
        "totalPage": result['data']['last_page'] as int,
        "currentPage": result['data']['current_page'] as int,
      };
    } catch (e) {
      throw ApiException(e.toString());
    }
  }

  Future<ResultOnlineDetails> getOnlineResultDetails({
    required int examId,
    required bool useParentApi,
    required int childId,
  }) async {
    try {
      final result = await Api.get(
        url: useParentApi
            ? Api.parentOnlineExamResult
            : Api.studentOnlineExamResult,
        useAuthToken: true,
        queryParameters: {
          if (examId != 0) 'online_exam_id': examId,
          if (useParentApi) 'child_id': childId,
        },
      );
      return ResultOnlineDetails.fromJson(result['data']);
    } catch (e) {
      throw ApiException(e.toString());
    }
  }

  Future<String> downloadResult(
      {required int examId, required int studentId}) async {
    try {
      final result = await Api.get(
          url: Api.downloadStudentResult,
          useAuthToken: true,
          queryParameters: {"exam_id": examId, "student_id": studentId});

      return result['pdf'] ?? "";
    } catch (e) {
      if (kDebugMode) {
        print(e.toString());
      }
      throw ApiException(e.toString());
    }
  }
}
