import 'package:yocut/data/models/announcement.dart';
import 'package:yocut/utils/api.dart';
import 'package:flutter/foundation.dart';

class AnnouncementRepository {
  //fetch notice board details
  Future<Map<String, dynamic>> fetchAnnouncements({
    int? page,
    required bool useParentApi,
    required int childId,
    required bool isGeneralAnnouncement,
    int? classSubjectId,
  }) async {
    try {
      Map<String, dynamic> queryParameters = {
        "page": page ?? 0,
        "type": isGeneralAnnouncement ? "class" : "subject",
        "class_subject_id": classSubjectId ?? 0
      };

      //
      if (queryParameters['page'] == 0) {
        queryParameters.remove("page");
      }

      //
      if (isGeneralAnnouncement) {
        queryParameters.remove("class_subject_id");
      }

      //
      if (useParentApi) {
        queryParameters.addAll({
          "child_id": childId,
        });
      }
      if (kDebugMode) {
        print(queryParameters);
      }

      final result = await Api.get(
        url: useParentApi
            ? Api.generalAnnouncementsParent
            : Api.generalAnnouncements,
        useAuthToken: true,
        queryParameters: queryParameters,
      );

      return {
        "announcements": (result['data']['data'] as List)
            .map((e) => Announcement.fromJson(Map.from(e)))
            .toList(),
        "totalPage": result['data']['last_page'] as int,
        "currentPage": result['data']['current_page'] as int,
      };
    } catch (e) {
      throw ApiException(e.toString());
    }
  }
}
