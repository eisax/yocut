import 'package:yocut/data/models/medium.dart';
import 'package:yocut/data/models/shift.dart';
import 'package:yocut/data/models/streamDetails.dart';

class ClassDetails {
  final int? id;
  final String? name;
  final int? includeSemesters;
  final int? mediumId;
  final int? schoolId;
  final String? createdAt;
  final String? updatedAt;
  final String? fullName;
  final Medium? medium;
  final StreamDetails? streamDetails;
  final Shift? shift;

  ClassDetails(
      {this.id,
      this.name,
      this.includeSemesters,
      this.mediumId,
      this.schoolId,
      this.createdAt,
      this.updatedAt,
      this.fullName,
      this.medium,
      this.shift,
      this.streamDetails});

  ClassDetails copyWith(
      {int? id,
      String? name,
      int? includeSemesters,
      int? mediumId,
      int? schoolId,
      String? createdAt,
      String? updatedAt,
      String? fullName,
      Medium? medium,
      StreamDetails? streamDetails,
      Shift? shift}) {
    return ClassDetails(
        id: id ?? this.id,
        name: name ?? this.name,
        includeSemesters: includeSemesters ?? this.includeSemesters,
        mediumId: mediumId ?? this.mediumId,
        schoolId: schoolId ?? this.schoolId,
        createdAt: createdAt ?? this.createdAt,
        updatedAt: updatedAt ?? this.updatedAt,
        fullName: fullName ?? this.fullName,
        medium: medium ?? this.medium,
        shift: shift ?? this.shift,
        streamDetails: streamDetails ?? this.streamDetails);
  }

  ClassDetails.fromJson(Map<String, dynamic> json)
      : id = json['id'] as int?,
        name = json['name'] as String?,
        includeSemesters = json['include_semesters'] as int?,
        mediumId = json['medium_id'] as int?,
        schoolId = json['school_id'] as int?,
        createdAt = json['created_at'] as String?,
        updatedAt = json['updated_at'] as String?,
        medium = Medium.fromJson(Map.from(json['medium'] ?? {})),
        streamDetails = StreamDetails.fromJson(Map.from(json['stream'] ?? {})),
        shift = Shift.fromJson(Map.from(json['shift'] ?? {})),
        fullName = json['full_name'] as String?;

  Map<String, dynamic> toJson() => {
        'id': id,
        'name': name,
        'include_semesters': includeSemesters,
        'medium_id': mediumId,
        'school_id': schoolId,
        'created_at': createdAt,
        'updated_at': updatedAt,
        'full_name': fullName,
        'medium': medium?.toJson(),
        'stream': streamDetails?.toJson(),
        'shift': shift?.toJson()
      };
}
