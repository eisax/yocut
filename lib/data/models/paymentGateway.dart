class PaymentGeteway {
  final int? id;
  final String? paymentMethod;
  final String? apiKey;
  final String? currencyCode;

  PaymentGeteway({
    this.id,
    this.paymentMethod,
    this.apiKey,
    this.currencyCode,
  });

  PaymentGeteway copyWith({
    int? id,
    String? paymentMethod,
    String? apiKey,
    String? currencyCode,
  }) {
    return PaymentGeteway(
      id: id ?? this.id,
      paymentMethod: paymentMethod ?? this.paymentMethod,
      apiKey: apiKey ?? this.apiKey,
      currencyCode: currencyCode ?? this.currencyCode,
    );
  }

  PaymentGeteway.fromJson(Map<String, dynamic> json)
      : id = json['id'] as int?,
        paymentMethod = json['payment_method'] as String?,
        apiKey = json['api_key'] as String?,
        currencyCode = json['currency_code'] as String?;

  Map<String, dynamic> toJson() => {
        'id': id,
        'payment_method': paymentMethod,
        'api_key': apiKey,
        'currency_code': currencyCode
      };
}
