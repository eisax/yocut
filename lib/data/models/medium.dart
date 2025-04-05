class Medium {
  final int? id;
  final String? name;
  final int? schoolId;
  final String? createdAt;
  final String? updatedAt;

  Medium({
    this.id,
    this.name,
    this.schoolId,
    this.createdAt,
    this.updatedAt,
  });

  Medium copyWith({
    int? id,
    String? name,
    int? schoolId,
    String? createdAt,
    String? updatedAt,
  }) {
    return Medium(
      id: id ?? this.id,
      name: name ?? this.name,
      schoolId: schoolId ?? this.schoolId,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
    );
  }

  Medium.fromJson(Map<String, dynamic> json)
      : id = json['id'] as int?,
        name = json['name'] as String?,
        schoolId = json['school_id'] as int?,
        createdAt = json['created_at'] as String?,
        updatedAt = json['updated_at'] as String?;

  Map<String, dynamic> toJson() => {
        'id': id,
        'name': name,
        'school_id': schoolId,
        'created_at': createdAt,
        'updated_at': updatedAt
      };
}
