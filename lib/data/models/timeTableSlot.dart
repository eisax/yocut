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
    final _data = <String, dynamic>{};
    _data['start_time'] = startTime;
    _data['end_time'] = endTime;
    _data['day'] = day;
    _data['note'] = note;
    _data['subject'] = subject.toJson();
    _data['teacher_first_name'] = teacherFirstName;
    _data['teacher_last_name'] = teacherLastName;
    return _data;
  }
}
