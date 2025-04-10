import 'package:hive/hive.dart';
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

  Future<Student> fetchSchoolDetails() async {
    try {
      final result = await Api.get(
        url: '${Api.schoolDetails}/${getRegNumber()}/${getJwtToken()}',
        useAuthToken: false,
      );

      print("This is school details : ${result['data']}");

      final SchoolDetails schoolDetails = SchoolDetails.fromJson(
        result['data'],
      );

      return schoolDetails;
    } catch (e, st) {
      print("this is School details error : $st");
      throw ApiException(e.toString());
    }
  }
}
