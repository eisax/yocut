import 'package:yocut/data/models/studyMaterial.dart';
import 'package:yocut/data/models/subject.dart';

class Assignment {
  Assignment({
    required this.id,
    required this.classSectionId,
    required this.subjectId,
    required this.name,
    required this.instructions,
    required this.dueDate,
    required this.points,
    required this.resubmission,
    required this.extraDaysForResubmission,
    required this.sessionYearId,
    required this.subject,
    required this.createdAt,
    required this.assignmentSubmission,
    required this.referenceMaterials,
    required this.schoolId,
  });

  late final int id;
  late final int classSectionId;
  late final int subjectId;
  late final String name;
  late final DateTime createdAt; //It will work as assigned date
  late List<StudyMaterial> referenceMaterials;
  late final String instructions;
  late final DateTime dueDate;
  late final int points;
  late final int resubmission;
  late final int extraDaysForResubmission;
  late final int sessionYearId;
  late final int schoolId;
  late final AssignmentSubmission assignmentSubmission;
  late final Subject subject;

  Assignment updateAssignmentSubmission(
    AssignmentSubmission newAssignmentSubmission,
  ) {
    return Assignment(
      schoolId: schoolId,
      createdAt: createdAt,
      id: id,
      classSectionId: classSectionId,
      subjectId: subjectId,
      name: name,
      instructions: instructions,
      dueDate: dueDate,
      points: points,
      resubmission: resubmission,
      extraDaysForResubmission: extraDaysForResubmission,
      sessionYearId: sessionYearId,
      subject: subject,
      assignmentSubmission: newAssignmentSubmission,
      referenceMaterials: referenceMaterials,
    );
  }

  Assignment.fromJson(Map<String, dynamic> json) {
    id = json['id'] ?? 0;
    classSectionId = json['class_section_id'] ?? 0;
    subjectId = json['subject_id'] ?? 0;
    name = json['name'] ?? "";
    instructions = json['instructions'] ?? "";
    dueDate = json['due_date'] == null
        ? DateTime.now()
        : DateTime.parse(json['due_date']);
    points = json['points'] ?? 0;
    resubmission = json['resubmission'] ?? -1;
    extraDaysForResubmission = json['extra_days_for_resubmission'] ?? 0;
    sessionYearId = json['session_year_id'] ?? 0;
    referenceMaterials = ((json['file'] ?? []) as List)
        .map((file) => StudyMaterial.fromJson(Map.from(file)))
        .toList();
    assignmentSubmission =
        AssignmentSubmission.fromJson(Map.from(json['submission'] ?? {}));

    subject =
        Subject.fromJson(Map.from(json['class_subject']?['subject'] ?? {}));
    createdAt = json['created_at'] == null
        ? DateTime.now()
        : DateTime.parse(json['created_at'].toString());
    schoolId = json['school_id'] ?? 0;
  }
}

class AssignmentSubmission {
  AssignmentSubmission({
    required this.id,
    required this.assignmentId,
    required this.studentId,
    required this.sessionYearId,
    required this.feedback,
    required this.status,
    required this.createdAt,
    required this.updatedAt,
    required this.points,
    required this.submittedFiles,
  });
  late final int id;
  late final List<StudyMaterial> submittedFiles;
  late final int assignmentId;
  late final int studentId;
  late final int sessionYearId;
  late final String feedback;
  late final int status;
  late final DateTime createdAt;
  late final int points;
  late final DateTime updatedAt;

  AssignmentSubmission.fromJson(Map<String, dynamic> json) {
    id = json['id'] ?? 0;
    points = json['points'] ?? 0;
    assignmentId = json['assignment_id'] ?? 0;
    studentId = json['student_id'] ?? 0;
    sessionYearId = json['session_year_id'] ?? 0;
    feedback = json['feedback'] ?? "";
    status = json['status'] ?? -1;
    createdAt = json['created_at'] == null
        ? DateTime.now()
        : DateTime.parse(json['created_at']);
    updatedAt = json['updated_at'] == null
        ? DateTime.now()
        : DateTime.parse(json['updated_at']);
    submittedFiles = ((json['file'] ?? []) as List)
        .map(
          (submittedFiles) => StudyMaterial.fromJson(Map.from(submittedFiles)),
        )
        .toList();
  }
}
