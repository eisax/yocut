class SemesterDetails {
  final int? id;
  final String? name;
  final int? startMonth;
  final int? endMonth;
  final int? schoolId;
  final String? createdAt;
  final String? updatedAt;
  final dynamic deletedAt;
  final bool? current;
  final String? startMonthName;
  final String? endMonthName;

  SemesterDetails({
    this.id,
    this.name,
    this.startMonth,
    this.endMonth,
    this.schoolId,
    this.createdAt,
    this.updatedAt,
    this.deletedAt,
    this.current,
    this.startMonthName,
    this.endMonthName,
  });

  SemesterDetails copyWith({
    int? id,
    String? name,
    int? startMonth,
    int? endMonth,
    int? schoolId,
    String? createdAt,
    String? updatedAt,
    dynamic deletedAt,
    bool? current,
    String? startMonthName,
    String? endMonthName,
  }) {
    return SemesterDetails(
      id: id ?? this.id,
      name: name ?? this.name,
      startMonth: startMonth ?? this.startMonth,
      endMonth: endMonth ?? this.endMonth,
      schoolId: schoolId ?? this.schoolId,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
      deletedAt: deletedAt ?? this.deletedAt,
      current: current ?? this.current,
      startMonthName: startMonthName ?? this.startMonthName,
      endMonthName: endMonthName ?? this.endMonthName,
    );
  }

  SemesterDetails.fromJson(Map<String, dynamic> json)
      : id = json['id'] as int?,
        name = json['name'] as String?,
        startMonth = json['start_month'] as int?,
        endMonth = json['end_month'] as int?,
        schoolId = json['school_id'] as int?,
        createdAt = json['created_at'] as String?,
        updatedAt = json['updated_at'] as String?,
        deletedAt = json['deleted_at'],
        current = json['current'] as bool?,
        startMonthName = json['start_month_name'] as String?,
        endMonthName = json['end_month_name'] as String?;

  Map<String, dynamic> toJson() => {
        'id': id,
        'name': name,
        'start_month': startMonth,
        'end_month': endMonth,
        'school_id': schoolId,
        'created_at': createdAt,
        'updated_at': updatedAt,
        'deleted_at': deletedAt,
        'current': current,
        'start_month_name': startMonthName,
        'end_month_name': endMonthName
      };
}
