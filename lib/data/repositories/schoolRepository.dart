import 'package:yocut/data/models/gallery.dart';
import 'package:yocut/data/models/schoolConfiguration.dart';
import 'package:yocut/data/models/sessionYear.dart';
import 'package:yocut/data/models/sliderDetails.dart';
import 'package:yocut/utils/api.dart';

class SchoolRepository {
  Future<SchoolConfiguration> getSchoolSchoolSettingDetails(
      {required bool useParentApi, int? childId}) async {
    try {
      final result = await Api.get(
          url: useParentApi
              ? Api.getParentChildSchoolSettingDetails
              : Api.getSchoolSettingDetails,
          useAuthToken: true,
          queryParameters: useParentApi ? {"child_id": childId ?? 0} : {});
      print()
      return SchoolConfiguration.fromJson(Map.from(result['data'] ?? {}));
    } catch (e) {
      throw ApiException(e.toString());
    }
  }

  Future<List<SliderDetails>> fetchSliders(
      {required bool useParentApi, int? childId}) async {
    try {
      Map<String, dynamic> body = {};

      if (useParentApi) {
        body['child_id'] = childId ?? 0;
      }

      final result = await Api.get(
          queryParameters: body,
          url: useParentApi ? Api.getParentSliders : Api.getStudentSliders,
          useAuthToken: true);

      return (result['data'] as List)
          .map((sliderDetails) => SliderDetails.fromJson(sliderDetails))
          .toList();
    } catch (e) {
      throw ApiException(e.toString());
    }
  }

  Future<List<Gallery>> fetchSchoolGallery(
      {required bool useParentApi,
      int? childId,
      required int sessionYearId,
      int? galleryId}) async {
    try {
      final result = await Api.get(
          url: Api.getSchoolGallery,
          useAuthToken: true,
          queryParameters: {
            "session_year_id": sessionYearId,
            "child_id": useParentApi ? childId : null,
            "gallery_id": galleryId
          });

      return ((result['data'] ?? []) as List)
          .map((gallery) => Gallery.fromJson(gallery ?? {}))
          .toList();
    } catch (e) {
      throw ApiException(e.toString());
    }
  }

  Future<List<SessionYear>> fetchSchoolSessionYears(
      {required bool useParentApi, int? childId}) async {
    try {
      final result = await Api.get(
          url: Api.getSchoolSessionYears,
          useAuthToken: true,
          queryParameters: {
            "child_id": useParentApi ? childId : null,
          });

      return ((result['data'] ?? []) as List)
          .map((sessionYear) => SessionYear.fromJson(sessionYear ?? {}))
          .toList();
    } catch (e) {
      throw ApiException(e.toString());
    }
  }
}
