import 'package:yocut/data/models/examOnline.dart';
import 'package:yocut/data/models/question.dart';
import 'package:yocut/utils/api.dart';
import 'package:flutter/foundation.dart';

class OnlineExamRepository {
  Future<Map<String, dynamic>> getExamsOnline({
    int? page,
    required int classSubjectId,
    required int childId,
    required bool useParentApi,
  }) async {
    try {
      final result = await Api.get(
        url:
            useParentApi ? Api.parentExamOnlineList : Api.studentExamOnlineList,
        useAuthToken: true,
        queryParameters: {
          if (classSubjectId != 0) 'class_subject_id': classSubjectId,
          if (page != 0) 'page': page ?? 1,
          if (useParentApi) 'child_id': childId
        },
      );

      return {
        "examList": (result['data']['data'] as List)
            .map((e) => ExamOnline.fromJson(Map.from(e)))
            .toList(),
        "totalPage": result['data']['last_page'] as int,
        "currentPage": result['data']['current_page'] as int,
        //total entries & per_page
      };
    } catch (e) {
      print(e.toString());
      throw ApiException(e.toString());
    }
  }

  Future<Map<String, dynamic>> getOnlineExamQuestions({
    required int examId,
    required int examKey,
  }) async {
    try {
      final result = await Api.get(
        url: Api.studentExamOnlineQuestions,
        useAuthToken: true,
        queryParameters: {'exam_id': examId, 'exam_key': examKey},
      );

      if (result['data'] == null) {
        throw ApiException(result['message'].toString());
      }

      return {
        "question": (result['data'] as List)
            .map((e) => Question.fromJson(Map.from(e)))
            .toList(),
        "totalMarks": result['total_marks'],
        "totalQuestions": result['total_questions'] //
      };
    } catch (e) {
      throw ApiException(e.toString());
    }
  }

  Future<String> setExamOnlineAnswers({
    required int examId,
    required Map<int, List<int>> answerData,
  }) async {
    try {
      final answersData = answerData.keys
          .map((key) => {"question_id": key, "option_id": answerData[key]})
          .toList();

      final body = {"online_exam_id": examId, "answers_data": answersData};
      if (kDebugMode) {
        print(body);
      }
      final result = await Api.post(
        url: Api.studentSubmitOnlineExamAnswers,
        useAuthToken: true,
        body: body,
      );
      if (kDebugMode) {
        print("result of answer's submission $result");
      }
      return result["message"];
    } catch (e) {
      if (kDebugMode) {
        print("exception @Answer submission $e");
      }
      throw ApiException(e.toString());
    }
  }
}
