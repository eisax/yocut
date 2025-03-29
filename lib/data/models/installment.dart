class Installment {
  final int? id;
  final String? name;
  final String? dueDate;
  final double? dueCharges;
  final int? feesId;
  final int? sessionYearId;
  final int? schoolId;
  final String? createdAt;
  final String? updatedAt;
  final double? minimumAmount;
  final double? maximumAmount;
  final bool? isPaid;
  final double? dueChargeAmount;
  final bool? isCurrent;

  Installment(
      {this.id,
      this.name,
      this.dueDate,
      this.dueCharges,
      this.feesId,
      this.sessionYearId,
      this.schoolId,
      this.createdAt,
      this.updatedAt,
      this.minimumAmount,
      this.maximumAmount,
      this.isPaid,
      this.dueChargeAmount,
      this.isCurrent});

  Installment copyWith(
      {int? id,
      String? name,
      String? dueDate,
      double? dueCharges,
      int? feesId,
      int? sessionYearId,
      int? schoolId,
      String? createdAt,
      String? updatedAt,
      double? minimumAmount,
      double? maximumAmount,
      bool? isPaid,
      double? dueChargeAmount,
      bool? isCurrent}) {
    return Installment(
        isCurrent: isCurrent,
        id: id ?? this.id,
        name: name ?? this.name,
        dueDate: dueDate ?? this.dueDate,
        dueCharges: dueCharges ?? this.dueCharges,
        feesId: feesId ?? this.feesId,
        sessionYearId: sessionYearId ?? this.sessionYearId,
        schoolId: schoolId ?? this.schoolId,
        createdAt: createdAt ?? this.createdAt,
        updatedAt: updatedAt ?? this.updatedAt,
        minimumAmount: minimumAmount ?? this.minimumAmount,
        maximumAmount: maximumAmount ?? this.maximumAmount,
        isPaid: isPaid ?? this.isPaid,
        dueChargeAmount: dueChargeAmount ?? this.dueChargeAmount);
  }

  Installment.fromJson(Map<String, dynamic> json)
      : id = json['id'] as int?,
        name = json['name'] as String?,
        dueDate = json['due_date'] as String?,
        dueCharges = double.parse((json['due_charges'] ?? 0).toString()),
        feesId = json['fees_id'] as int?,
        sessionYearId = json['session_year_id'] as int?,
        schoolId = json['school_id'] as int?,
        createdAt = json['created_at'] as String?,
        updatedAt = json['updated_at'] as String?,
        minimumAmount = double.parse((json['minimum_amount'] ?? 0).toString()),
        maximumAmount = double.parse((json['maximum_amount'] ?? 0).toString()),
        isCurrent = json['is_current'] as bool?,
        dueChargeAmount =
            double.parse((json['due_charges_amount'] ?? 0).toString()),
        isPaid = json['is_paid'] as bool?;

  Map<String, dynamic> toJson() => {
        'id': id,
        'name': name,
        'due_date': dueDate,
        'due_charges': dueCharges,
        'fees_id': feesId,
        'session_year_id': sessionYearId,
        'school_id': schoolId,
        'created_at': createdAt,
        'updated_at': updatedAt,
        'minimum_amount': minimumAmount,
        'maximum_amount': maximumAmount,
        'is_paid': isPaid,
        'due_charges_amount': dueChargeAmount,
        'is_current': isCurrent
      };

  bool isInstallmentOverdue() {
    return (dueChargeAmount ?? 0.0) != 0.0;
  }
}
