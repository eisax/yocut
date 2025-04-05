import 'package:yocut/data/models/compulsoryPaidFee.dart';
import 'package:yocut/data/models/optionalPaidFee.dart';

class PaidFeeDetails {
  final int? id;
  final int? feesId;
  final int? studentId;
  final int? isFullyPaid;
  final int? isUsedInstallment;
  final double? amount;
  final String? date;
  final int? schoolId;
  final String? createdAt;
  final String? updatedAt;
  final List<CompulsoryPaidFee>? compulsoryPaidFees;
  final List<OptionalPaidFee>? optionalPaidFees;

  PaidFeeDetails(
      {this.id,
      this.feesId,
      this.studentId,
      this.isFullyPaid,
      this.isUsedInstallment,
      this.amount,
      this.date,
      this.schoolId,
      this.createdAt,
      this.updatedAt,
      this.compulsoryPaidFees,
      this.optionalPaidFees});

  PaidFeeDetails copyWith(
      {int? id,
      int? feesId,
      int? studentId,
      int? isFullyPaid,
      int? isUsedInstallment,
      double? amount,
      String? date,
      int? schoolId,
      String? createdAt,
      String? updatedAt,
      List<OptionalPaidFee>? optionalPaidFees,
      List<CompulsoryPaidFee>? compulsoryPaidFees}) {
    return PaidFeeDetails(
      id: id ?? this.id,
      feesId: feesId ?? this.feesId,
      studentId: studentId ?? this.studentId,
      isFullyPaid: isFullyPaid ?? this.isFullyPaid,
      isUsedInstallment: isUsedInstallment ?? this.isUsedInstallment,
      amount: amount ?? this.amount,
      date: date ?? this.date,
      schoolId: schoolId ?? this.schoolId,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
      compulsoryPaidFees: compulsoryPaidFees ?? this.compulsoryPaidFees,
      optionalPaidFees: optionalPaidFees ?? this.optionalPaidFees,
    );
  }

  PaidFeeDetails.fromJson(Map<String, dynamic> json)
      : id = json['id'] as int?,
        feesId = json['fees_id'] as int?,
        studentId = json['student_id'] as int?,
        isFullyPaid = json['is_fully_paid'] as int?,
        isUsedInstallment = json['is_used_installment'] as int?,
        amount = double.parse((json['amount'] ?? 0).toString()),
        date = json['date'] as String?,
        schoolId = json['school_id'] as int?,
        createdAt = json['created_at'] as String?,
        compulsoryPaidFees = ((json['compulsory_fee'] ?? []) as List)
            .map((e) => CompulsoryPaidFee.fromJson(Map.from(e ?? {})))
            .toList(),
        optionalPaidFees = ((json['optional_fee'] ?? []) as List)
            .map((e) => OptionalPaidFee.fromJson(Map.from(e ?? {})))
            .toList(),
        updatedAt = json['updated_at'] as String?;

  Map<String, dynamic> toJson() => {
        'id': id,
        'fees_id': feesId,
        'student_id': studentId,
        'is_fully_paid': isFullyPaid,
        'is_used_installment': isUsedInstallment,
        'amount': amount,
        'date': date,
        'school_id': schoolId,
        'created_at': createdAt,
        'updated_at': updatedAt,
        'optional_fee': optionalPaidFees?.map((e) => e.toJson()).toList(),
        'compulsory_fee': compulsoryPaidFees?.map((e) => e.toJson()).toList(),
      };
}
