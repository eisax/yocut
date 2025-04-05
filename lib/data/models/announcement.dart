import 'package:yocut/data/models/studyMaterial.dart';

class Announcement {
  Announcement(
      {required this.id,
      required this.title,
      required this.description,
      required this.createdAt,});
  late final int id;
  late final DateTime createdAt;
  late final String title;
  late final String description;
  late final List<StudyMaterial> files;

  Announcement.fromJson(Map<String, dynamic> json) {
    id = json['id'] ?? 0;
    title = json['title'] ?? "";
    createdAt = json['created_at'] == null
        ? DateTime.now()
        : DateTime.parse(json['created_at']);
    description = json['description'] ?? "";
    files = ((json['file'] ?? []) as List)
        .map((file) => StudyMaterial.fromJson(Map.from(file)))
        .toList();
  }
}
