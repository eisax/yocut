import 'package:yocut/data/models/studyMaterial.dart';

class Topic {
  Topic(
      {required this.id,
      required this.name,
      required this.lessonId,
      required this.description,});
  late final int id;
  late final String description;
  late final String name;
  late final int lessonId;
  late final List<StudyMaterial> studyMaterials;

  Topic.fromJson(Map<String, dynamic> json) {
    id = json['id'] ?? 0;
    name = json['name'] ?? "";
    lessonId = json['lesson_id'] ?? 0;
    description = json['description'] ?? "";

    studyMaterials = ((json['file'] ?? []) as List)
        .map((file) => StudyMaterial.fromJson(Map.from(file)))
        .toList();
  }
}
