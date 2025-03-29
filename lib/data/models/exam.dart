import 'package:yocut/data/models/subject.dart';

class Exam {
  int? examID;
  String? examName;
  String? description;
  int? publish;
  String? sessionYear;
  String? examStartingDate;
  String? examEndingDate;
  String? examStatus;

  Exam({
    this.examID,
    this.examName,
    this.description,
    this.publish,
    this.sessionYear,
    this.examStartingDate,
    this.examEndingDate,
    this.examStatus,
  });

  Exam.fromExamJson(Map<String, dynamic> json) {
    examID = json['id'];
    examName = json['name'] ?? "";
    description = json['description'] ?? "";
    publish = json['publish'] ?? 0;
    sessionYear = json['session_year'] ?? "";
    examStartingDate = json['exam_starting_date'] ?? "";
    examEndingDate = json['exam_ending_date'] ?? "";
    examStatus = json['exam_status'] ?? "";
  }
}

class ExamTimeTable {
  int? id;
  int? totalMarks;
  double? passingMarks;
  String? date;
  String? startingTime;
  String? endingTime;
  Subject? subject;

  ExamTimeTable({
    this.id,
    this.totalMarks,
    this.passingMarks,
    this.date,
    this.startingTime,
    this.endingTime,
    this.subject,
  });

  ExamTimeTable.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    totalMarks = json['total_marks'] ?? 0;

    passingMarks = json['passing_marks'] != null
        ? (json['passing_marks'] is int
            ? (json['passing_marks'] as int).toDouble()
            : json['passing_marks'] as double)
        : 0.0;

    date = json['date'] ?? '';
    startingTime = json['starting_time'] ?? '';
    endingTime = json['ending_time'] ?? '';
    subject =
        json['subject'] != null ? Subject.fromJson(json['subject']) : null;
  }
}
