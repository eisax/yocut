import 'package:yocut/data/models/paymentTransaction.dart';
import 'package:yocut/utils/api.dart';

class PaymentRepository {
  ///[Make it more flexible to support more payment method]
  Future<PaymentTransaction> confirmPayment(
      {required int paymentTransactionId}) async {
    try {
      final result = await Api.get(
          url: Api.confirmPayment,
          useAuthToken: true,
          queryParameters: {"payment_transaction_id": paymentTransactionId});

      return PaymentTransaction.fromJson(Map.from(result['data'] ?? {}));
    } catch (e) {
      throw ApiException(e.toString());
    }
  }

  Future<List<PaymentTransaction>> getTransactions({bool? fetchLatest}) async {
    try {
      final result = await Api.get(
          url: Api.getTransactions,
          queryParameters: {"latest_only": (fetchLatest ?? false) ? 1 : 0},
          useAuthToken: true);
      return ((result['data'] ?? []) as List)
          .map((paymentTransaction) =>
              PaymentTransaction.fromJson(Map.from(paymentTransaction ?? {})))
          .toList();
    } catch (e) {
      print(e.toString());
      throw ApiException(e.toString());
    }
  }
}
