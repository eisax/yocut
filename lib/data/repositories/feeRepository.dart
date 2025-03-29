import 'package:yocut/data/models/childFeeDetails.dart';
import 'package:yocut/data/models/paymentTransaction.dart';
import 'package:yocut/utils/api.dart';
import 'package:flutter/foundation.dart';

class FeeRepository {
  //
  Future<List<ChildFeeDetails>> fetchChildFeeDetails(
      {required int childId}) async {
    try {
      final result = await Api.get(
        url: Api.getStudentFeesDetailParent,
        useAuthToken: true,
        queryParameters: {
          "child_id": childId,
        },
      );
      return ((result['data'] ?? []) as List)
          .map((e) => ChildFeeDetails.fromJson(Map.from(e ?? {})))
          .toList();
    } catch (e) {
      if (kDebugMode) {
        print(e.toString());
      }
      throw ApiException(e.toString());
    }
  }

  Future<({PaymentTransaction paymentTransaction, Map<String, dynamic> data})>
      payCompulsoryFee(
          {required String paymentMethod,
          required int childId,
          required int feeId,
          List<int>? installmentIds,
          double? advanceAmount}) async {
    try {
      final result = await Api.post(body: {
        "payment_method": paymentMethod,
        "child_id": childId,
        "fees_id": feeId,
        "installment_ids": installmentIds ?? [],
        "advance": advanceAmount ?? 0
      }, url: Api.payChildCompulsoryFees, useAuthToken: true);

      ///[If paymentMethod is stripe or razorpay then it will have payment_intent]
      final data =
          Map<String, dynamic>.from(result['data']['payment_intent'] ?? {});
      return (
        paymentTransaction: PaymentTransaction.fromJson(
            Map.from(result['data']['payment_transaction'] ?? {})),
        data: data
      );
    } catch (e) {
      throw ApiException(e.toString());
    }
  }

  Future<({PaymentTransaction paymentTransaction, Map<String, dynamic> data})>
      payOptionalFees(
          {required String paymentMethod,
          required int childId,
          required int feeId,
          required List<int> optionalFeeIds}) async {
    try {
      final result = await Api.post(body: {
        "payment_method": paymentMethod,
        "child_id": childId,
        "fees_id": feeId,
        "optional_id": optionalFeeIds
      }, url: Api.payChildOptionalFees, useAuthToken: true);

      ///[If paymentMethod is stripe then it will have payment_intent]
      final data =
          Map<String, dynamic>.from(result['data']['payment_intent'] ?? {});
      return (
        paymentTransaction: PaymentTransaction.fromJson(
            Map.from(result['data']['payment_transaction'] ?? {})),
        data: data
      );
    } catch (e) {
      throw ApiException(e.toString());
    }
  }

  Future<String> getFeeReceipt(
      {required int childId, required int feeId}) async {
    try {
      final result = await Api.get(queryParameters: {
        "child_id": childId,
        "fees_id": feeId,
      }, url: Api.downloadFeeReceipt, useAuthToken: true);

      return result['pdf'] ?? "";
    } catch (e) {
      throw ApiException(e.toString());
    }
  }
}
