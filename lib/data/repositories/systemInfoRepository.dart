import 'package:yocut/data/models/holiday.dart';
import 'package:yocut/utils/api.dart';

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

  Future<List<Holiday>> fetchHolidays({int? childId}) async {
    try {
      final result = await Api.get(
          queryParameters: {"child_id": childId},
          url: Api.holidays,
          useAuthToken: true);

      print(result);

      return ((result['data'] ?? []) as List)
          .map((holiday) => Holiday.fromJson(Map.from(holiday)))
          .toList();
    } catch (e) {
      throw ApiException(e.toString());
    }
  }
}
