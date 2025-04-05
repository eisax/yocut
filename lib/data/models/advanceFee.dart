class AdvanceFee {
  final int? id;
  final int? compulsoryFeeId;
  final int? studentId;
  final int? parentId;
  final double? amount;
  final String? createdAt;
  final String? updatedAt;

  AdvanceFee({
    this.id,
    this.compulsoryFeeId,
    this.studentId,
    this.parentId,
    this.amount,
    this.createdAt,
    this.updatedAt,
  });

  AdvanceFee copyWith({
    int? id,
    int? compulsoryFeeId,
    int? studentId,
    int? parentId,
    double? amount,
    String? createdAt,
    String? updatedAt,
  }) {
    return AdvanceFee(
      id: id ?? this.id,
      compulsoryFeeId: compulsoryFeeId ?? this.compulsoryFeeId,
      studentId: studentId ?? this.studentId,
      parentId: parentId ?? this.parentId,
      amount: amount ?? this.amount,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
    );
  }

  AdvanceFee.fromJson(Map<String, dynamic> json)
      : id = json['id'] as int?,
        compulsoryFeeId = json['compulsory_fee_id'] as int?,
        studentId = json['student_id'] as int?,
        parentId = json['parent_id'] as int?,
        amount = double.parse((json['amount'] ?? 0).toString()),
        createdAt = json['created_at'] as String?,
        updatedAt = json['updated_at'] as String?;

  Map<String, dynamic> toJson() => {
        'id': id,
        'compulsory_fee_id': compulsoryFeeId,
        'student_id': studentId,
        'parent_id': parentId,
        'amount': amount,
        'created_at': createdAt,
        'updated_at': updatedAt
      };
}
