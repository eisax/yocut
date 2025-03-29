import 'package:yocut/data/models/subject.dart';

class ElectiveSubject extends Subject {
  late final int electiveSubjectGroupId;

  ElectiveSubject.fromJson({
    required Map<String, dynamic> json,
    required electiveSubjectGroupId,
  }) : super.fromJson(Map.from(json)) {
    electiveSubjectGroupId = electiveSubjectGroupId;
  }
}
