import 'package:yocut/data/models/coreSubject.dart';
import 'package:yocut/data/models/electiveSubject.dart';
import 'package:yocut/data/models/subjectTeacher.dart';
import 'package:yocut/utils/api.dart';
import 'package:flutter/foundation.dart';

class ParentRepository {
  Future<Map<String, dynamic>> fetchChildSubjects({
    required int childId,
  }) async {
    try {
      final result = await Api.get(
        url: Api.subjectsByChildId,
        useAuthToken: true,
        queryParameters: {"child_id": childId},
      );

      final coreSubjects = (result['data']['core_subject'] as List)
          .map((e) => CoreSubject.fromJson(json: Map.from(e)))
          .toList();

      //If class have any elective subjects then of key of elective subject will be there
      //if elective subject key has empty list means student has not slected any
      //elective subjctes

      //If there is not electvie subjects key in result means no elective subjects
      //in given class

      final electiveSubjects =
          ((result['data']['elective_subject'] ?? []) as List).map(
        (e) {
          Map<String, dynamic> subjectDetails =
              Map.from(e['class_subject']['subject']);
          subjectDetails['class_subject_id'] = e['class_subject_id'];
          return ElectiveSubject.fromJson(
            electiveSubjectGroupId: 0,
            json: subjectDetails,
          );
        },
      ).toList();

      return {
        "coreSubjects": coreSubjects,
        "electiveSubjects": electiveSubjects,
        "doesClassHaveElectiveSubjects":
            result['data']['elective_subject'] != null
      };
    } catch (e) {
      print(e.toString());
      throw ApiException(e.toString());
    }
  }

  Future<List<SubjectTeacher>> fetchChildTeachers(
      {required int childId}) async {
    try {
      if (kDebugMode) {
        print("Child id of $childId");
      }
      final result = await Api.get(
        url: Api.getStudentTeachersParent,
        useAuthToken: true,
        queryParameters: {"child_id": childId},
      );

      if (kDebugMode) {
        print(result['data']);
      }

      return (result['data'] as List)
          .map((subjectTeacher) =>
              SubjectTeacher.fromJson(Map.from(subjectTeacher ?? {})))
          .toList();
    } catch (e) {
      if (kDebugMode) {
        print(e.toString());
      }

      throw ApiException(e.toString());
    }
  }
}
