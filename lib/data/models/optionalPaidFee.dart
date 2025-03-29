class OptionalPaidFee {
  final int? id;
  final int? studentId;
  final int? classId;
  final int? paymentTransactionId;
  final int? feesClassId;
  final String? mode;
  final String? chequeNo;
  final double? amount;
  final int? feesPaidId;
  final String? date;
  final int? schoolId;
  final String? status;
  final String? createdAt;
  final String? updatedAt;
  final String? modeName;

  OptionalPaidFee({
    this.id,
    this.studentId,
    this.classId,
    this.paymentTransactionId,
    this.feesClassId,
    this.mode,
    this.chequeNo,
    this.amount,
    this.feesPaidId,
    this.date,
    this.schoolId,
    this.status,
    this.createdAt,
    this.updatedAt,
    this.modeName,
  });

  OptionalPaidFee copyWith({
    int? id,
    int? studentId,
    int? classId,
    int? paymentTransactionId,
    int? feesClassId,
    String? mode,
    String? chequeNo,
    double? amount,
    int? feesPaidId,
    String? date,
    int? schoolId,
    String? status,
    String? createdAt,
    String? updatedAt,
    String? modeName,
  }) {
    return OptionalPaidFee(
      id: id ?? this.id,
      studentId: studentId ?? this.studentId,
      classId: classId ?? this.classId,
      paymentTransactionId: paymentTransactionId ?? this.paymentTransactionId,
      feesClassId: feesClassId ?? this.feesClassId,
      mode: mode ?? this.mode,
      chequeNo: chequeNo ?? this.chequeNo,
      amount: amount ?? this.amount,
      feesPaidId: feesPaidId ?? this.feesPaidId,
      date: date ?? this.date,
      schoolId: schoolId ?? this.schoolId,
      status: status ?? this.status,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
      modeName: modeName ?? this.modeName,
    );
  }

  OptionalPaidFee.fromJson(Map<String, dynamic> json)
      : id = json['id'] as int?,
        studentId = json['student_id'] as int?,
        classId = json['class_id'] as int?,
        paymentTransactionId = json['payment_transaction_id'] as int?,
        feesClassId = json['fees_class_id'] as int?,
        mode = json['mode'] as String?,
        chequeNo = json['cheque_no'] as String?,
        amount = double.parse((json['amount'] ?? 0).toString()),
        feesPaidId = json['fees_paid_id'] as int?,
        date = json['date'] as String?,
        schoolId = json['school_id'] as int?,
        status = json['status'] as String?,
        createdAt = json['created_at'] as String?,
        updatedAt = json['updated_at'] as String?,
        modeName = json['mode_name'] as String?;

  Map<String, dynamic> toJson() => {
        'id': id,
        'student_id': studentId,
        'class_id': classId,
        'payment_transaction_id': paymentTransactionId,
        'fees_class_id': feesClassId,
        'mode': mode,
        'cheque_no': chequeNo,
        'amount': amount,
        'fees_paid_id': feesPaidId,
        'date': date,
        'school_id': schoolId,
        'status': status,
        'created_at': createdAt,
        'updated_at': updatedAt,
        'mode_name': modeName
      };
}
