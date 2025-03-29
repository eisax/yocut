import 'package:yocut/data/models/advanceFee.dart';

class CompulsoryPaidFee {
  final int? id;
  final int? studentId;
  final int? paymentTransactionId;
  final String? type;
  final int? installmentId;
  final String? mode;
  final String? chequeNo;
  final double? amount;
  final double? dueCharges;
  final int? feesPaidId;
  final String? status;
  final String? date;
  final int? schoolId;
  final String? createdAt;
  final String? updatedAt;
  final String? modeName;
  final List<AdvanceFee>? advanceFees;

  CompulsoryPaidFee({
    this.id,
    this.studentId,
    this.paymentTransactionId,
    this.type,
    this.installmentId,
    this.mode,
    this.chequeNo,
    this.amount,
    this.dueCharges,
    this.feesPaidId,
    this.status,
    this.date,
    this.schoolId,
    this.createdAt,
    this.updatedAt,
    this.modeName,
    this.advanceFees,
  });

  CompulsoryPaidFee copyWith({
    int? id,
    int? studentId,
    int? paymentTransactionId,
    String? type,
    int? installmentId,
    String? mode,
    String? chequeNo,
    double? amount,
    double? dueCharges,
    int? feesPaidId,
    String? status,
    String? date,
    int? schoolId,
    String? createdAt,
    String? updatedAt,
    String? modeName,
    List<AdvanceFee>? advanceFees,
  }) {
    return CompulsoryPaidFee(
        id: id ?? this.id,
        studentId: studentId ?? this.studentId,
        paymentTransactionId: paymentTransactionId ?? this.paymentTransactionId,
        type: type ?? this.type,
        installmentId: installmentId ?? this.installmentId,
        mode: mode ?? this.mode,
        chequeNo: chequeNo ?? this.chequeNo,
        amount: amount ?? this.amount,
        dueCharges: dueCharges ?? this.dueCharges,
        feesPaidId: feesPaidId ?? this.feesPaidId,
        status: status ?? this.status,
        date: date ?? this.date,
        schoolId: schoolId ?? this.schoolId,
        createdAt: createdAt ?? this.createdAt,
        updatedAt: updatedAt ?? this.updatedAt,
        modeName: modeName ?? this.modeName,
        advanceFees: advanceFees ?? this.advanceFees);
  }

  CompulsoryPaidFee.fromJson(Map<String, dynamic> json)
      : id = json['id'] as int?,
        studentId = json['student_id'] as int?,
        paymentTransactionId = json['payment_transaction_id'] as int?,
        type = json['type'] as String?,
        installmentId = json['installment_id'] as int?,
        mode = json['mode'] as String?,
        chequeNo = json['cheque_no'] as String?,
        amount = double.parse((json['amount'] ?? 0).toString()),
        dueCharges = double.parse((json['due_charges'] ?? 0).toString()),
        feesPaidId = json['fees_paid_id'] as int?,
        status = json['status'] as String?,
        date = json['date'] as String?,
        schoolId = json['school_id'] as int?,
        createdAt = json['created_at'] as String?,
        updatedAt = json['updated_at'] as String?,
        advanceFees = ((json['advance_fees'] ?? []) as List)
            .map((e) => AdvanceFee.fromJson(Map.from(e ?? {})))
            .toList(),
        modeName = json['mode_name'] as String?;

  Map<String, dynamic> toJson() => {
        'id': id,
        'student_id': studentId,
        'payment_transaction_id': paymentTransactionId,
        'type': type,
        'installment_id': installmentId,
        'mode': mode,
        'cheque_no': chequeNo,
        'amount': amount,
        'due_charges': dueCharges,
        'fees_paid_id': feesPaidId,
        'status': status,
        'date': date,
        'school_id': schoolId,
        'created_at': createdAt,
        'updated_at': updatedAt,
        'mode_name': modeName,
        'advance_fees': advanceFees?.map((e) => e.toJson()).toList()
      };
}
