import 'package:dio/dio.dart';
import 'package:yocut/data/models/lesson.dart';
import 'package:yocut/data/models/studyMaterial.dart';
import 'package:yocut/utils/api.dart';

class SubjectRepository {
  Future<List<Lesson>> getLessons({
    required int classSubjectId,
    required int childId,
    required bool useParentApi,
  }) async {
    try {
      //
      Map<String, dynamic> queryParameters = {
        "class_subject_id": classSubjectId
      };

      if (useParentApi) {
        queryParameters.addAll({"child_id": childId});
      }

      final result = await Api.get(
        url:
            useParentApi ? Api.lessonsOfSubjectParent : Api.getLessonsOfSubject,
        useAuthToken: true,
        queryParameters: queryParameters,
      );

      return (result['data'] as List)
          .map((lesson) => Lesson.fromJson(Map.from(lesson)))
          .toList();
    } catch (e) {
      throw ApiException(e.toString());
    }
  }

  Future<List<StudyMaterial>> getStudyMaterialOfTopic({
    required int lessonId,
    required int topicId,
    required bool useParentApi,
    required int childId,
  }) async {
    try {
      Map<String, dynamic> queryParameters = {
        "topic_id": topicId,
        "lesson_id": lessonId
      };
      if (useParentApi) {
        queryParameters.addAll({"child_id": childId});
      }

      final result = await Api.get(
        url: useParentApi
            ? Api.getstudyMaterialsOfTopicParent
            : Api.getstudyMaterialsOfTopic,
        useAuthToken: true,
        queryParameters: queryParameters,
      );

      final studyMaterialJson = result['data'] as List;
      final files = (studyMaterialJson.first['file'] ?? []) as List;

      return files
          .map((file) => StudyMaterial.fromJson(Map.from(file)))
          .toList();
    } catch (e) {
      throw ApiException(e.toString());
    }
  }

  Future<void> downloadStudyMaterialFile({
    required String url,
    required String savePath,
    required CancelToken cancelToken,
    required Function updateDownloadedPercentage,
  }) async {
    try {
      await Api.download(
        cancelToken: cancelToken,
        url: url,
        savePath: savePath,
        updateDownloadedPercentage: updateDownloadedPercentage,
      );
    } catch (e) {
      throw ApiException(e.toString());
    }
  }
}
