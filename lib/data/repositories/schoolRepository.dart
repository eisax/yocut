import 'dart:convert';

import 'package:dio/dio.dart';
import 'package:hive/hive.dart';
import 'package:yocut/data/models/Student.dart';
import 'package:yocut/data/models/gallery.dart';
import 'package:yocut/data/models/schoolConfiguration.dart';
import 'package:yocut/data/models/sessionYear.dart';
import 'package:yocut/data/models/sliderDetails.dart';
import 'package:yocut/utils/api.dart';
import 'package:yocut/utils/hiveBoxKeys.dart';

class SchoolRepository {
  String getJwtToken() {
    return Hive.box(authBoxKey).get(jwtTokenKey) ?? "";
  }

  String getRegNumber() {
    return Hive.box(authBoxKey).get(studentRegNumberKey) ?? "";
  }

  Future<Map<String, dynamic>> fetchSchoolDetails() async {
    final Dio dio = Dio(
      BaseOptions(
        connectTimeout: Duration(seconds: 30),
        receiveTimeout: Duration(seconds: 30),
        followRedirects: false,
        validateStatus: (status) => status != null && status < 400,
        headers: {
          'Content-Type': 'application/x-www-form-urlencoded',
          'Accept': 'application/json',
          'User-Agent': 'Mozilla/5.0 (compatible; DartApp/1.0)',
        },
      ),
    );

    // final result = await Api.get(
    //   url: '${Api.schoolDetails}/${getRegNumber()}/${getJwtToken()}',
    //   useAuthToken: false,
    // );

    try {
      final response = await dio.get(
        '${Api.studentData}/${getRegNumber()}/${getJwtToken()}',
      );

      if (response.data == null) {
        throw ApiException('API returned null response');
      }

      // Check if response data is a Map<String, dynamic>
      if (response.data is Map<String, dynamic>) {
        return {"student": Student.fromJson(response.data)};
      }
      // If it's a String, decode it into a Map
      else if (response.data is String) {
        final Map<String, dynamic> json = jsonDecode(response.data);
        return {"student": Student.fromJson(json)};
      } else {
        throw ApiException('Unexpected response format');
      }
    } catch (e) {
      throw ApiException('Failed to fetch student data: ${e.toString()}');
    }
  }
  // Future<Student> getSchoolSchoolSettingDetails(
  //     {required bool useParentApi, int? childId}) async {
  //   try {
  //     final result = await Api.get(
  //         url: useParentApi
  //             ? Api.getParentChildSchoolSettingDetails
  //             : Api.getSchoolSettingDetails,
  //         useAuthToken: true,
  //         queryParameters: useParentApi ? {"child_id": childId ?? 0} : {});
  //     print(result['data']);
  //     return Student.fromJson(Map.from(result['data'] ?? {}));
  //   } catch (e) {
  //     throw ApiException(e.toString());
  //   }
  // }

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
