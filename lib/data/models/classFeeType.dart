import 'package:yocut/data/models/feeType.dart';

class ClassFeeType {
  final int? id;
  final int? classId;
  final int? feesId;
  final int? feesTypeId;
  final double? amount;
  final int? optional;
  final int? schoolId;
  final String? createdAt;
  final String? updatedAt;
  final bool? isPaid;
  final String? feesTypeName;
  final FeeType? feesType;

  ClassFeeType(
      {this.id,
      this.classId,
      this.feesId,
      this.feesTypeId,
      this.amount,
      this.optional,
      this.schoolId,
      this.createdAt,
      this.updatedAt,
      this.isPaid,
      this.feesTypeName,
      this.feesType});

  ClassFeeType copyWith({
    int? id,
    int? classId,
    int? feesId,
    int? feesTypeId,
    double? amount,
    int? optional,
    int? schoolId,
    String? createdAt,
    String? updatedAt,
    bool? isPaid,
    String? feesTypeName,
    FeeType? feesType,
  }) {
    return ClassFeeType(
      id: id ?? this.id,
      classId: classId ?? this.classId,
      feesId: feesId ?? this.feesId,
      feesTypeId: feesTypeId ?? this.feesTypeId,
      amount: amount ?? this.amount,
      optional: optional ?? this.optional,
      schoolId: schoolId ?? this.schoolId,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
      isPaid: isPaid ?? this.isPaid,
      feesTypeName: feesTypeName ?? this.feesTypeName,
    );
  }

  ClassFeeType.fromJson(Map<String, dynamic> json)
      : id = json['id'] as int?,
        classId = json['class_id'] as int?,
        feesId = json['fees_id'] as int?,
        feesTypeId = json['fees_type_id'] as int?,
        amount = double.parse((json['amount'] ?? 0).toString()),
        optional = json['optional'] as int?,
        schoolId = json['school_id'] as int?,
        createdAt = json['created_at'] as String?,
        updatedAt = json['updated_at'] as String?,
        isPaid = json['is_paid'] as bool?,
        feesType = FeeType.fromJson(Map.from(json['fees_type'] ?? {})),
        feesTypeName = json['fees_type_name'] as String?;

  Map<String, dynamic> toJson() => {
        'id': id,
        'class_id': classId,
        'fees_id': feesId,
        'fees_type_id': feesTypeId,
        'amount': amount,
        'optional': optional,
        'school_id': schoolId,
        'created_at': createdAt,
        'updated_at': updatedAt,
        'is_paid': isPaid,
        'fees_type_name': feesTypeName,
        'fees_type': feesType?.toJson(),
      };
}
