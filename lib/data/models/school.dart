class School {
  final int? id;
  final String? name;
  final String? address;
  final String? supportPhone;
  final String? supportEmail;
  final String? tagline;
  final String? logo;
  final int? adminId;
  final int? status;
  final String? createdAt;
  final String? updatedAt;
  final String? code;

  School({
    this.id,
    this.name,
    this.address,
    this.supportPhone,
    this.supportEmail,
    this.tagline,
    this.logo,
    this.adminId,
    this.status,
    this.createdAt,
    this.updatedAt,
    this.code,
  });

  School copyWith({
    int? id,
    String? name,
    String? address,
    String? supportPhone,
    String? supportEmail,
    String? tagline,
    String? logo,
    int? adminId,
    int? status,
    String? createdAt,
    String? updatedAt,
     String? code,

  }) {
    return School(
      id: id ?? this.id,
      name: name ?? this.name,
      address: address ?? this.address,
      supportPhone: supportPhone ?? this.supportPhone,
      supportEmail: supportEmail ?? this.supportEmail,
      tagline: tagline ?? this.tagline,
      logo: logo ?? this.logo,
      adminId: adminId ?? this.adminId,
      status: status ?? this.status,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
      code: code ?? this.code,
    );
  }

  School.fromJson(Map<String, dynamic> json)
      : id = json['id'] as int?,
        name = json['name'] as String?,
        address = json['address'] as String?,
        supportPhone = json['support_phone'] as String?,
        supportEmail = json['support_email'] as String?,
        tagline = json['tagline'] as String?,
        logo = json['logo'] as String?,
        adminId = json['admin_id'] as int?,
        status = json['status'] as int?,
        createdAt = json['created_at'] as String?,
        updatedAt = json['updated_at'] as String?,
        code = json['code'] as String?;

  Map<String, dynamic> toJson() => {
        'id': id,
        'name': name,
        'address': address,
        'support_phone': supportPhone,
        'support_email': supportEmail,
        'tagline': tagline,
        'logo': logo,
        'admin_id': adminId,
        'status': status,
        'created_at': createdAt,
        'updated_at': updatedAt,
        'code': code
      };
}
