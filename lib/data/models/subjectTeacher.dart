import 'package:yocut/data/models/subject.dart';
import 'package:yocut/data/models/teacher.dart';

class SubjectTeacher {
  final int? id;
  final int? classSectionId;
  final int? subjectId;
  final int? teacherId;
  final int? classSubjectId;
  final int? semesterId;
  final int? schoolId;
  final String? createdAt;
  final String? updatedAt;
  final String? subjectWithName;
  final Teacher? teacher;
  final Subject? subject;

  SubjectTeacher(
      {this.id,
      this.classSectionId,
      this.subjectId,
      this.teacherId,
      this.classSubjectId,
      this.semesterId,
      this.schoolId,
      this.createdAt,
      this.updatedAt,
      this.subjectWithName,
      this.subject,
      this.teacher});

  SubjectTeacher copyWith(
      {int? id,
      int? classSectionId,
      int? subjectId,
      int? teacherId,
      int? classSubjectId,
      int? semesterId,
      int? schoolId,
      String? createdAt,
      String? updatedAt,
      String? subjectWithName,
      Teacher? teacher,
      Subject? subject}) {
    return SubjectTeacher(
        id: id ?? this.id,
        classSectionId: classSectionId ?? this.classSectionId,
        subjectId: subjectId ?? this.subjectId,
        teacherId: teacherId ?? this.teacherId,
        classSubjectId: classSubjectId ?? this.classSubjectId,
        semesterId: semesterId ?? this.semesterId,
        schoolId: schoolId ?? this.schoolId,
        createdAt: createdAt ?? this.createdAt,
        updatedAt: updatedAt ?? this.updatedAt,
        subjectWithName: subjectWithName ?? this.subjectWithName,
        subject: subject ?? this.subject,
        teacher: teacher ?? this.teacher);
  }

  SubjectTeacher.fromJson(Map<String, dynamic> json)
      : id = json['id'] as int?,
        classSectionId = json['class_section_id'] as int?,
        subjectId = json['subject_id'] as int?,
        teacherId = json['teacher_id'] as int?,
        classSubjectId = json['class_subject_id'] as int?,
        semesterId = json['semester_id'] as int?,
        schoolId = json['school_id'] as int?,
        createdAt = json['created_at'] as String?,
        updatedAt = json['updated_at'] as String?,
        teacher = Teacher.fromJson(Map.from(json['teacher'] ?? {})),
        subject = Subject.fromJson(Map.from(json['subject'] ?? {})),
        subjectWithName = json['subject_with_name'] as String?;

  Map<String, dynamic> toJson() => {
        'id': id,
        'class_section_id': classSectionId,
        'subject_id': subjectId,
        'teacher_id': teacherId,
        'class_subject_id': classSubjectId,
        'semester_id': semesterId,
        'school_id': schoolId,
        'created_at': createdAt,
        'updated_at': updatedAt,
        'subject_with_name': subjectWithName,
        'subject' : subject?.toJson(),
        'teacher' : teacher?.toJson()
      };
}
