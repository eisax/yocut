import 'package:yocut/data/models/subject.dart';

class TimeTableSlot {
  TimeTableSlot({
    required this.startTime,
    required this.endTime,
    required this.day,
    required this.subject,
    required this.teacherFirstName,
    required this.teacherLastName,
  });
  late final String startTime;
  late final String endTime;
  late final String day;
  late final Subject subject;
  late final String teacherFirstName;
  late final String teacherLastName;
  late final String note;

  TimeTableSlot.fromJson(Map<String, dynamic> json) {
    startTime = json['start_time'] ?? "";
    teacherLastName = json['teacher_last_name'] ?? "";
    endTime = json['end_time'] ?? "";
    day = json['day'] ?? "";
    note = json['note'] ?? "";
    subject = Subject.fromJson(Map.from(json['subject'] ?? {}));
    teacherFirstName = json['teacher_first_name'] ?? "";
  }

  Map<String, dynamic> toJson() {
    final data = <String, dynamic>{};
    data['start_time'] = startTime;
    data['end_time'] = endTime;
    data['day'] = day;
    data['note'] = note;
    data['subject'] = subject.toJson();
    data['teacher_first_name'] = teacherFirstName;
    data['teacher_last_name'] = teacherLastName;
    return data;
  }
}
