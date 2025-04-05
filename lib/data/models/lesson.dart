import 'package:yocut/data/models/studyMaterial.dart';
import 'package:yocut/data/models/topic.dart';

class Lesson {
  Lesson(
      {required this.id,
      required this.name,
      required this.description,
      required this.classSectionId,
      required this.subjectId,
      required this.studyMaterials,
      required this.topics,});
  late final int id;
  late final List<StudyMaterial> studyMaterials;
  late final List<Topic> topics;
  late final String name;
  late final String description;
  late final int classSectionId;
  late final int subjectId;

  Lesson.fromJson(Map<String, dynamic> json) {
    id = json['id'] ?? 0;
    name = json['name'] ?? "";
    topics = ((json['topic'] ?? []) as List)
        .map((topic) => Topic.fromJson(topic))
        .toList();

    description = json['description'] ?? "";
    classSectionId = json['class_section_id'] ?? 0;
    subjectId = json['subject_id'] ?? 0;
    studyMaterials = ((json['file'] ?? []) as List)
        .map((file) => StudyMaterial.fromJson(Map.from(file)))
        .toList();
  }
}
