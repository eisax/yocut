import 'package:dio/dio.dart';
import 'package:yocut/data/models/assignment.dart';
import 'package:yocut/utils/api.dart';

class AssignmentRepository {
  Future<Map<String, dynamic>> fetchAssignments({
    int? page,
    int? assignmentId,
    int? classSubjectId,
    required int isSubmitted,
    required bool useParentApi,
    required int childId,
  }) async {
    try {
      Map<String, dynamic> queryParameters = {
        "assignment_id": assignmentId ?? 0,
        "class_subject_id": classSubjectId ?? 0,
        "page": page ?? 0,
        "is_submitted": isSubmitted
      };

      if (queryParameters['assignment_id'] == 0) {
        queryParameters.remove('assignment_id');
      }

      if (queryParameters['class_subject_id'] == 0) {
        queryParameters.remove('class_subject_id');
      }

      if (queryParameters['page'] == 0) {
        queryParameters.remove('page');
      }

      if (useParentApi) {
        queryParameters.addAll({"child_id": childId});
      }

      // final result = await Api.get(
      //   url: useParentApi ? Api.getAssignmentsParent : Api.getAssignments,
      //   useAuthToken: true,
      //   queryParameters: queryParameters,
      // );

    

      // return {
      //   "assignments": (result['data']['data'] as List).map((e) {
      //     return Assignment.fromJson(Map.from(e));
      //   }).toList(),
      //   "totalPage": result['data']['last_page'] as int,
      //   "currentPage": result['data']['current_page'] as int,
      // };

      return {
        "assignments": ([]).map((e) {
          return Assignment.fromJson(Map.from(e));
        }).toList(),
        "totalPage": [] as int,
        "currentPage": [] as int,
      };
    } catch (e) {
      throw ApiException(e.toString());
    }
  }

  Future<AssignmentSubmission> submitAssignment({
    required int assignmentId,
    required List<String> filePaths,
    required CancelToken cancelToken,
    required Function updateUploadAssignmentPercentage,
  }) async {
    try {
      List<MultipartFile> files = [];
      for (var filePath in filePaths) {
        files.add(await MultipartFile.fromFile(filePath));
      }
      final result = await Api.post(
        body: {"assignment_id": assignmentId, "files": files},
        url: Api.submitAssignment,
        useAuthToken: true,
        cancelToken: cancelToken,
        onSendProgress: (count, total) {
          updateUploadAssignmentPercentage((count / total) * 100);
        },
      );

      final assignmentSubmissions = (result['data'] ?? []) as List;

      return AssignmentSubmission.fromJson(
        Map.from(
          assignmentSubmissions.isEmpty ? {} : assignmentSubmissions.first,
        ),
      );
    } catch (e) {
      throw ApiException(e.toString());
    }
  }

  Future<void> deleteAssignment({
    required int assignmentSubmissionId,
  }) async {
    try {
      await Api.post(
        body: {"assignment_submission_id": assignmentSubmissionId},
        url: Api.deleteAssignment,
        useAuthToken: true,
      );
    } catch (e) {
      throw ApiException(e.toString());
    }
  }
}
