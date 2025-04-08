import 'package:yocut/data/models/holiday.dart';
import 'package:yocut/utils/api.dart';
import 'package:yocut/utils/constants.dart';
import 'package:dio/dio.dart';

class SystemRepository {
  Future<dynamic> fetchSettings({required String type}) async {
    try {
      final result = await Api.get(
        queryParameters: {"type": type},
        url: Api.settings,
        useAuthToken: false,
      );

      return result['data'];
    } catch (e) {
      throw ApiException(e.toString());
    }
  }

  Future<bool> isBaseUrlReachable() async {
    try {
      final Dio dio = Dio();
      final response = await dio.get(
        baseUrl,
        queryParameters: {"type": null},
        options: Options(headers: null),
      );

      // Check if the response is OK and data exists
      if (response.statusCode == 200 && response.data != null) {
        return true;
      }

      return false;
    } catch (e) {
      return false;
    }
  }

  Future<List<Holiday>> fetchHolidays({int? childId}) async {
    try {
      final result = await Api.get(
        queryParameters: {"child_id": childId},
        url: Api.holidays,
        useAuthToken: true,
      );

      print(result);

      return ((result['data'] ?? []) as List)
          .map((holiday) => Holiday.fromJson(Map.from(holiday)))
          .toList();
    } catch (e) {
      throw ApiException(e.toString());
    }
  }
}
