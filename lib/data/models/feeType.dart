class FeeType {
  final int? id;
  final String? name;
  final String? description;
  final int? schoolId;
  final String? createdAt;
  final String? updatedAt;

  FeeType({
    this.id,
    this.name,
    this.description,
    this.schoolId,
    this.createdAt,
    this.updatedAt,
  });

  FeeType copyWith({
    int? id,
    String? name,
    String? description,
    int? schoolId,
    String? createdAt,
    String? updatedAt,
  }) {
    return FeeType(
      id: id ?? this.id,
      name: name ?? this.name,
      description: description ?? this.description,
      schoolId: schoolId ?? this.schoolId,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
    );
  }

  FeeType.fromJson(Map<String, dynamic> json)
      : id = json['id'] as int?,
        name = json['name'] as String?,
        description = json['description'] as String?,
        schoolId = json['school_id'] as int?,
        createdAt = json['created_at'] as String?,
        updatedAt = json['updated_at'] as String?;

  Map<String, dynamic> toJson() => {
        'id': id,
        'name': name,
        'description': description,
        'school_id': schoolId,
        'created_at': createdAt,
        'updated_at': updatedAt
      };
}
