import 'package:yocut/utils/utils.dart';

class Shift {
  final int? id;
  final String? name;
  final String? startTime;
  final String? endTime;
  final int? status;
  final int? schoolId;
  final String? createdAt;
  final String? updatedAt;

  Shift({
    this.id,
    this.name,
    this.startTime,
    this.endTime,
    this.status,
    this.schoolId,
    this.createdAt,
    this.updatedAt,
  });

  Shift copyWith({
    int? id,
    String? name,
    String? startTime,
    String? endTime,
    int? status,
    int? schoolId,
    String? createdAt,
    String? updatedAt,
  }) {
    return Shift(
      id: id ?? this.id,
      name: name ?? this.name,
      startTime: startTime ?? this.startTime,
      endTime: endTime ?? this.endTime,
      status: status ?? this.status,
      schoolId: schoolId ?? this.schoolId,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
    );
  }

  Shift.fromJson(Map<String, dynamic> json)
      : id = json['id'] as int?,
        name = json['name'] as String?,
        startTime = json['start_time'] as String?,
        endTime = json['end_time'] as String?,
        status = json['status'] as int?,
        schoolId = json['school_id'] as int?,
        createdAt = json['created_at'] as String?,
        updatedAt = json['updated_at'] as String?;

  Map<String, dynamic> toJson() => {
        'id': id,
        'name': name,
        'start_time': startTime,
        'end_time': endTime,
        'status': status,
        'school_id': schoolId,
        'created_at': createdAt,
        'updated_at': updatedAt
      };

  String? get startToEndTime {
    if (startTime == null || endTime == null) {
      return null;
    } else {
      return "${Utils.formatTime(startTime!)} - ${Utils.formatTime(endTime!)}";
    }
  }
}
