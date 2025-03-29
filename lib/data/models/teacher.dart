class Teacher {
  final int? id;
  final String? firstName;
  final String? lastName;
  final String? mobile;
  final String? email;
  final String? gender;
  final String? image;
  final String? dob;
  final String? currentAddress;
  final String? permanentAddress;
  final int? status;
  final int? resetRequest;
  final int? schoolId;
  final String? createdAt;
  final String? updatedAt;
  final String? fullName;

  Teacher({
    this.id,
    this.firstName,
    this.lastName,
    this.mobile,
    this.email,
    this.gender,
    this.image,
    this.dob,
    this.currentAddress,
    this.permanentAddress,
    this.status,
    this.resetRequest,
    this.schoolId,
    this.createdAt,
    this.updatedAt,
    this.fullName,
  });

  Teacher copyWith({
    int? id,
    String? firstName,
    String? lastName,
    String? mobile,
    String? email,
    String? gender,
    String? image,
    String? dob,
    String? currentAddress,
    String? permanentAddress,
    int? status,
    int? resetRequest,
    int? schoolId,
    String? createdAt,
    String? updatedAt,
    String? fullName,
  }) {
    return Teacher(
      id: id ?? this.id,
      firstName: firstName ?? this.firstName,
      lastName: lastName ?? this.lastName,
      mobile: mobile ?? this.mobile,
      email: email ?? this.email,
      gender: gender ?? this.gender,
      image: image ?? this.image,
      dob: dob ?? this.dob,
      currentAddress: currentAddress ?? this.currentAddress,
      permanentAddress: permanentAddress ?? this.permanentAddress,
      status: status ?? this.status,
      resetRequest: resetRequest ?? this.resetRequest,
      schoolId: schoolId ?? this.schoolId,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
      fullName: fullName ?? this.fullName,
    );
  }

  Teacher.fromJson(Map<String, dynamic> json)
      : id = json['id'] as int?,
        firstName = json['first_name'] as String?,
        lastName = json['last_name'] as String?,
        mobile = json['mobile'] as String?,
        email = json['email'] as String?,
        gender = json['gender'] as String?,
        image = json['image'] as String?,
        dob = json['dob'] as String?,
        currentAddress = json['current_address'] as String?,
        permanentAddress = json['permanent_address'] as String?,
        status = json['status'] as int?,
        resetRequest = json['reset_request'] as int?,
        schoolId = json['school_id'] as int?,
        createdAt = json['created_at'] as String?,
        updatedAt = json['updated_at'] as String?,
        fullName = json['full_name'] as String?;

  Map<String, dynamic> toJson() => {
        'id': id,
        'first_name': firstName,
        'last_name': lastName,
        'mobile': mobile,
        'email': email,
        'gender': gender,
        'image': image,
        'dob': dob,
        'current_address': currentAddress,
        'permanent_address': permanentAddress,
        'status': status,
        'reset_request': resetRequest,
        'school_id': schoolId,
        'created_at': createdAt,
        'updated_at': updatedAt,
        'full_name': fullName
      };
}
