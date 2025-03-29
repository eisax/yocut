import 'package:yocut/data/models/student.dart';

class Guardian {
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
  final String? occupation;
  final int? status;
  final String? createdAt;
  final String? updatedAt;
  final String? fullName;

  final List<Student>? children;

  Guardian(
      {this.id,
      this.firstName,
      this.lastName,
      this.mobile,
      this.email,
      this.gender,
      this.image,
      this.dob,
      this.currentAddress,
      this.permanentAddress,
      this.occupation,
      this.status,
      this.createdAt,
      this.updatedAt,
      this.fullName,
      this.children});

  Guardian copyWith(
      {int? id,
      String? firstName,
      String? lastName,
      String? mobile,
      String? email,
      String? gender,
      String? image,
      String? dob,
      String? currentAddress,
      String? permanentAddress,
      String? occupation,
      int? status,
      String? createdAt,
      String? updatedAt,
      String? fullName,
      List<Student>? children}) {
    return Guardian(
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
      occupation: occupation ?? this.occupation,
      status: status ?? this.status,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
      fullName: fullName ?? this.fullName,
      children: children ?? this.children,
    );
  }

  Guardian.fromJson(Map<String, dynamic> json)
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
        occupation = json['occupation'] as String?,
        status = int.parse((json['status'] ?? 0).toString()),
        createdAt = json['created_at'] as String?,
        updatedAt = json['updated_at'] as String?,
        children = ((json['children'] ?? []) as List)
            .map((student) => Student.fromJson(Map.from(student ?? {})))
            .toList(),
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
        'occupation': occupation,
        'status': status,
        'created_at': createdAt,
        'updated_at': updatedAt,
        'full_name': fullName,
        'children': children?.map((student) => student.toJson()).toList(),
      };

  String getFullName() => "$firstName $lastName";
}
