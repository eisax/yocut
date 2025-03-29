import 'package:yocut/data/models/school.dart';

class PaymentTransaction {
  final int? id;
  final int? userId;
  final double? amount;
  final String? paymentGateway;
  final String? orderId;
  final String? paymentId;
  final String? paymentSignature;
  final String? paymentStatus;
  final School? school;
  final int? schoolId;
  final String? createdAt;
  final String? updatedAt;
  final String? currencyCode;
  final String? currencySymbol;

  PaymentTransaction(
      {this.id,
      this.school,
      this.userId,
      this.amount,
      this.paymentGateway,
      this.orderId,
      this.paymentId,
      this.paymentSignature,
      this.paymentStatus,
      this.schoolId,
      this.createdAt,
      this.updatedAt,
      this.currencyCode,
      this.currencySymbol});

  PaymentTransaction copyWith(
      {int? id,
      int? userId,
      double? amount,
      String? paymentGateway,
      String? orderId,
      String? paymentId,
      String? paymentSignature,
      String? paymentStatus,
      int? schoolId,
      String? createdAt,
      String? updatedAt,
      School? school,
      String? currencySymbol,
      String? currencyCode}) {
    return PaymentTransaction(
      id: id ?? this.id,
      userId: userId ?? this.userId,
      currencyCode: currencyCode ?? this.currencyCode,
      currencySymbol: currencySymbol ?? this.currencySymbol,
      amount: amount ?? this.amount,
      paymentGateway: paymentGateway ?? this.paymentGateway,
      orderId: orderId ?? this.orderId,
      paymentId: paymentId ?? this.paymentId,
      paymentSignature: paymentSignature ?? this.paymentSignature,
      paymentStatus: paymentStatus ?? this.paymentStatus,
      schoolId: schoolId ?? this.schoolId,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
      school: school ?? this.school,
    );
  }

  PaymentTransaction.fromJson(Map<String, dynamic> json)
      : id = json['id'] as int?,
        userId = json['user_id'] as int?,
        amount = double.parse((json['amount'] ?? 0).toString()),
        paymentGateway = json['payment_gateway'] as String?,
        orderId = json['order_id'] as String?,
        paymentId = json['payment_id'] as String?,
        paymentSignature = json['payment_signature'] as String?,
        paymentStatus = json['payment_status'] as String?,
        schoolId = json['school_id'] as int?,
        createdAt = json['created_at'] as String?,
        school = School.fromJson(Map.from(json['school'] ?? {})),
        currencyCode = json['currency_code'] as String?,
        currencySymbol = json['currency_symbol'] as String?,
        updatedAt = json['updated_at'] as String?;

  Map<String, dynamic> toJson() => {
        'id': id,
        'user_id': userId,
        'currency_code': currencyCode,
        'currency_symbol': currencySymbol,
        'amount': amount,
        'payment_gateway': paymentGateway,
        'order_id': orderId,
        'payment_id': paymentId,
        'payment_signature': paymentSignature,
        'payment_status': paymentStatus,
        'school_id': schoolId,
        'created_at': createdAt,
        'updated_at': updatedAt,
        'school': school?.toJson(),
      };
}
