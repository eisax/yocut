class SliderDetails {
  final int? id;
  final String? image;
  final String? link;
  final int? schoolId;
  final String? createdAt;
  final String? updatedAt;

  SliderDetails({
    this.id,
    this.image,
    this.link,
    this.schoolId,
    this.createdAt,
    this.updatedAt,
  });

  SliderDetails copyWith({
    int? id,
    String? image,
    String? link,
    int? schoolId,
    String? createdAt,
    String? updatedAt,
  }) {
    return SliderDetails(
      id: id ?? this.id,
      image: image ?? this.image,
      link: link ?? this.link,
      schoolId: schoolId ?? this.schoolId,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
    );
  }

  SliderDetails.fromJson(Map<String, dynamic> json)
      : id = json['id'] as int?,
        image = json['image'] as String?,
        link = json['link'] as String?,
        schoolId = json['school_id'] as int?,
        createdAt = json['created_at'] as String?,
        updatedAt = json['updated_at'] as String?;

  Map<String, dynamic> toJson() => {
        'id': id,
        'image': image,
        'link': link,
        'school_id': schoolId,
        'created_at': createdAt,
        'updated_at': updatedAt
      };
}
