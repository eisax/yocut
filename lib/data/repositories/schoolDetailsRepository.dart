import 'package:hive/hive.dart';
import 'package:yocut/data/models/Student.dart';
import 'package:yocut/data/models/schoolDetails.dart';
import 'package:yocut/utils/api.dart';
import 'package:yocut/utils/hiveBoxKeys.dart';

class Schooldetailsfetch {
  String getJwtToken() {
    return Hive.box(authBoxKey).get(jwtTokenKey) ?? "";
  }

  String getRegNumber() {
    return Hive.box(authBoxKey).get(studentRegNumberKey) ?? "";
  }

  Future<Map<String, dynamic>> fetchSchoolDetails() async {

      final result = await Api.get(
        url: '${Api.schoolDetails}/${getRegNumber()}/${getJwtToken()}',
        useAuthToken: false,
      );


      try {
      final response = await dio.get(
        '${Api.studentData}/${credentials.regNumber}/${credentials.token}',
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
}
