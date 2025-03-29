import 'package:yocut/utils/labelKeys.dart';
import 'package:yocut/utils/utils.dart';
import 'package:flutter/material.dart';

class Subject {
  final int? id;
  final String? name;
  final String? code;
  final String? bgColor;
  final String? image;
  final int? mediumId;
  final String? type;
  final int? schoolId;
  final String? createdAt;
  final String? updatedAt;
  final dynamic deletedAt;
  final int? classSubjectId;
  final String? nameWithType;

  String getSubjectName({required BuildContext context}) {
    if ((type ?? "").isEmpty) {
      return (nameWithType ?? "");
    }

    String translatedType =
        Utils.getTranslatedLabel(isPractial() ? practicalKey : theoryKey);

    return "(${name ?? ''} - $translatedType)";
  }

  bool isPractial() => "Practical" == (type ?? "");

  Subject({
    this.id,
    this.name,
    this.code,
    this.bgColor,
    this.image,
    this.mediumId,
    this.type,
    this.schoolId,
    this.createdAt,
    this.updatedAt,
    this.deletedAt,
    this.classSubjectId,
    this.nameWithType,
  });

  Subject copyWith({
    int? id,
    String? name,
    String? code,
    String? bgColor,
    String? image,
    int? mediumId,
    String? type,
    int? schoolId,
    String? createdAt,
    String? updatedAt,
    dynamic deletedAt,
    int? classSubjectId,
    String? nameWithType,
  }) {
    return Subject(
      id: id ?? this.id,
      name: name ?? this.name,
      code: code ?? this.code,
      bgColor: bgColor ?? this.bgColor,
      image: image ?? this.image,
      mediumId: mediumId ?? this.mediumId,
      type: type ?? this.type,
      schoolId: schoolId ?? this.schoolId,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
      deletedAt: deletedAt ?? this.deletedAt,
      classSubjectId: classSubjectId ?? this.classSubjectId,
      nameWithType: nameWithType ?? this.nameWithType,
    );
  }

  Subject.fromJson(Map<String, dynamic> json)
      : id = json['id'] as int?,
        name = json['name'] as String?,
        code = json['code'] as String?,
        bgColor = json['bg_color'] as String?,
        image = json['image'] as String?,
        mediumId = json['medium_id'] as int?,
        type = json['type'] as String?,
        schoolId = json['school_id'] as int?,
        createdAt = json['created_at'] as String?,
        updatedAt = json['updated_at'] as String?,
        deletedAt = json['deleted_at'],
        classSubjectId = json['class_subject_id'] as int?,
        nameWithType = json['name_with_type'] as String?;

  Map<String, dynamic> toJson() => {
        'id': id,
        'name': name,
        'code': code,
        'bg_color': bgColor,
        'image': image,
        'medium_id': mediumId,
        'type': type,
        'school_id': schoolId,
        'created_at': createdAt,
        'updated_at': updatedAt,
        'deleted_at': deletedAt,
        'class_subject_id': classSubjectId,
        'name_with_type': nameWithType
      };

  bool hasSvgImage() {
    final imageUrlParts = (image ?? "").split(".");
    return imageUrlParts.last.toLowerCase() == "svg";
  }
}
