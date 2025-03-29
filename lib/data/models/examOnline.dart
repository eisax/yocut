import 'package:yocut/data/models/subject.dart';
import 'package:flutter/foundation.dart';

class ExamOnline {
  final int? id;
  final int? classSectionId;
  final int? classSubjectId;
  final String? title;
  final int? examKey;
  final int? duration;
  final String? startDate;
  final String? endDate;
  final int? sessionYearId;
  final int? schoolId;
  final String? createdAt;
  final String? updatedAt;
  final String? classSectionWithMedium;
  final String? subjectWithName;
  final Subject? subject;
  final String? totalMarks;
  final String? examStaus;

  ExamOnline({
    this.id,
    this.totalMarks,
    this.classSectionId,
    this.classSubjectId,
    this.title,
    this.examKey,
    this.duration,
    this.startDate,
    this.endDate,
    this.sessionYearId,
    this.schoolId,
    this.createdAt,
    this.updatedAt,
    this.classSectionWithMedium,
    this.subjectWithName,
    this.subject,
    this.examStaus,
  });

  ExamOnline copyWith(
      {int? id,
      int? classSectionId,
      String? examStatus,
      int? classSubjectId,
      String? title,
      int? examKey,
      int? duration,
      String? startDate,
      String? endDate,
      int? sessionYearId,
      int? schoolId,
      String? createdAt,
      String? updatedAt,
      String? classSectionWithMedium,
      String? subjectWithName,
      Subject? subject,
      String? totalMarks}) {
    return ExamOnline(
      examStaus: examStaus ?? this.examStaus,
      subject: subject ?? this.subject,
      totalMarks: totalMarks ?? this.totalMarks,
      id: id ?? this.id,
      classSectionId: classSectionId ?? this.classSectionId,
      classSubjectId: classSubjectId ?? this.classSubjectId,
      title: title ?? this.title,
      examKey: examKey ?? this.examKey,
      duration: duration ?? this.duration,
      startDate: startDate ?? this.startDate,
      endDate: endDate ?? this.endDate,
      sessionYearId: sessionYearId ?? this.sessionYearId,
      schoolId: schoolId ?? this.schoolId,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
      classSectionWithMedium:
          classSectionWithMedium ?? this.classSectionWithMedium,
      subjectWithName: subjectWithName ?? this.subjectWithName,
    );
  }

  ExamOnline.fromJson(Map<String, dynamic> json)
      : id = json['id'] as int?,
        classSectionId = json['class_section_id'] as int?,
        classSubjectId = json['class_subject_id'] as int?,
        title = json['title'] as String?,
        examKey = json['exam_key'] as int?,
        duration = json['duration'] as int?,
        startDate = json['start_date'] as String?,
        endDate = json['end_date'] as String?,
        sessionYearId = json['session_year_id'] as int?,
        schoolId = json['school_id'] as int?,
        createdAt = json['created_at'] as String?,
        updatedAt = json['updated_at'] as String?,
        classSectionWithMedium = json['class_section_with_medium'] as String?,
        subject = Subject.fromJson(Map.from(json['class_subject']['subject'])),
        totalMarks = (json['total_marks'] ?? 0).toString(),
        examStaus = json['exam_status_name'] as String?,
        subjectWithName = json['subject_with_name'] as String? {
    if (kDebugMode) {
      print(json);
    }
  }

  ///[Exam status will be (On Going) and (Upcoming) ]
  bool get isExamStarted => examStaus == "On Going";

  Map<String, dynamic> toJson() => {
        'id': id,
        'class_section_id': classSectionId,
        'class_subject_id': classSubjectId,
        'title': title,
        'exam_key': examKey,
        'duration': duration,
        'start_date': startDate,
        'end_date': endDate,
        'session_year_id': sessionYearId,
        'school_id': schoolId,
        'created_at': createdAt,
        'updated_at': updatedAt,
        'total_marks': totalMarks,
        'class_section_with_medium': classSectionWithMedium,
        'subject_with_name': subjectWithName,
        'exam_status_name': examStaus,
        'class_subject': {'subject': subject?.toJson()}
      };
}
