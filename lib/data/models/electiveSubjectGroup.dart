import 'package:yocut/data/models/electiveSubject.dart';

class ElectiveSubjectGroup {
  late final int id;
  late final int totalSelectableSubjects;
  late final int totalSubjects;
  late final List<ElectiveSubject> subjects;
  late final int classId;
  late final int semesterId;
  late final int schoolId;

  ElectiveSubjectGroup(
      {required this.id,
      required this.totalSelectableSubjects,
      required this.subjects,
      required this.totalSubjects,
      required this.classId,
      required this.schoolId,
      required this.semesterId});

  ElectiveSubjectGroup.fromJson(Map<String, dynamic> json) {
    id = json['id'] ?? 0;
    classId = json['class_id'] ?? 0;
    schoolId = json['school_id'] ?? 0;
    semesterId = json['semester_id'] ?? 0;
    totalSelectableSubjects = json['total_selectable_subjects'] ?? 0;
    totalSubjects = json['total_subjects'] ?? 0;
    subjects = json['subjects'] == null
        ? [] as List<ElectiveSubject>
        : (json['subjects'] as List)
            .map(
              (subject) => ElectiveSubject.fromJson(
                electiveSubjectGroupId: id,
                json: Map.from(subject ?? {}),
              ),
            )
            .toList();
  }
}
