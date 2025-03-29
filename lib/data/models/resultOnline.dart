import 'package:yocut/data/models/subject.dart';

class ResultOnline {
  ResultOnline({
    required this.examId,
    required this.examName,
    required this.examDate,
    required this.subject,
    required this.totalMarks,
    required this.obtainedMarks,
  });

  late final int examId;
  late final String examName;
  late final String examDate;
  late final String totalMarks;
  late final String obtainedMarks;
  late final Subject subject;

  ResultOnline.fromJson(Map<String, dynamic> json) {
    examId = json['online_exam_id'] ?? 0;
    examName = json['title'] ?? "";
    examDate = json['exam_submitted_date'] ?? "";
    subject = Subject.fromJson(json['subject']);
    totalMarks = (json['total_marks'] ?? "").toString();
    obtainedMarks = (json['obtained_marks'] ?? "").toString();
  }
}
