class AttendanceDay {
  AttendanceDay({
    required this.id,
    required this.studentId,
    required this.sessionYearId,
    required this.type,
    required this.date,
    required this.remark,
  });
  late final int id;
  late final int studentId;
  late final int sessionYearId;
  late final int type;
  late final DateTime date;
  late final String remark;

  AttendanceDay.fromJson(Map<String, dynamic> json) {
    id = json['id'] ?? 0;
    studentId = json['student_id'] ?? 0;
    sessionYearId = json['session_year_id'] ?? 0;
    type = json['type'] ?? -1;
    date = json['date'] == null ? DateTime.now() : DateTime.parse(json['date']);
    remark = json['remark'] ?? "";
  }
}
