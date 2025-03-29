import 'package:yocut/data/models/classDetails.dart';
import 'package:yocut/data/models/medium.dart';
import 'package:yocut/data/models/section.dart';

class ClassSection {
  final int? id;
  final int? classId;
  final int? sectionId;
  final int? mediumId;
  final int? schoolId;
  final String? createdAt;
  final String? updatedAt;
  final String? name;
  final String? fullName;
  final Section? section;
  final ClassDetails? classDetails;
  final Medium? medium;

  ClassSection(
      {this.id,
      this.classId,
      this.sectionId,
      this.mediumId,
      this.schoolId,
      this.createdAt,
      this.updatedAt,
      this.name,
      this.fullName,
      this.classDetails,
      this.medium,
      this.section});

  ClassSection copyWith(
      {int? id,
      int? classId,
      int? sectionId,
      int? mediumId,
      int? schoolId,
      String? createdAt,
      String? updatedAt,
      String? name,
      String? fullName,
      Section? section,
      Medium? medium,
      ClassDetails? classDetails}) {
    return ClassSection(
        id: id ?? this.id,
        classId: classId ?? this.classId,
        sectionId: sectionId ?? this.sectionId,
        mediumId: mediumId ?? this.mediumId,
        schoolId: schoolId ?? this.schoolId,
        createdAt: createdAt ?? this.createdAt,
        updatedAt: updatedAt ?? this.updatedAt,
        name: name ?? this.name,
        fullName: fullName ?? this.fullName,
        classDetails: classDetails ?? this.classDetails,
        medium: medium ?? this.medium,
        section: section ?? this.section);
  }

  ClassSection.fromJson(Map<String, dynamic> json)
      : id = json['id'] as int?,
        classId = json['class_id'] as int?,
        sectionId = json['section_id'] as int?,
        mediumId = json['medium_id'] as int?,
        schoolId = json['school_id'] as int?,
        createdAt = json['created_at'] as String?,
        updatedAt = json['updated_at'] as String?,
        name = json['name'] as String?,
        fullName = json['full_name'] as String?,
        section = Section.fromJson(Map.from(json['section'] ?? {})),
        classDetails = ClassDetails.fromJson(Map.from(json['class'] ?? {})),
        medium = Medium.fromJson(Map.from(json['medium'] ?? {}));

  Map<String, dynamic> toJson() => {
        'id': id,
        'class_id': classId,
        'section_id': sectionId,
        'medium_id': mediumId,
        'school_id': schoolId,
        'created_at': createdAt,
        'updated_at': updatedAt,
        'name': name,
        'full_name': fullName,
        'section': section?.toJson(),
        'class': classDetails?.toJson(),
        'medium': medium?.toJson()
      };
}
