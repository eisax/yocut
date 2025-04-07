// import 'package:dio/dio.dart';
import 'package:yocut/utils/errorMessageKeysAndCodes.dart';
// import 'package:flutter/services.dart';
// import 'package:flutter_stripe/flutter_stripe.dart';

// ignore: avoid_classes_with_only_static_members
class StripeService {
  static String paymentIntentSuccessResponse = "succeeded";
  //For other response visit this  https://stripe.com/docs/api/payment_intents/object and refer status section

  static String apiBase = 'https://api.stripe.com/v1';
  static String paymentApiUrl = '${StripeService.apiBase}/payment_intents';

  static init(String? stripeId, String? stripeMode) {
    // Stripe.publishableKey = stripeId ?? '';
  }

  static payWithPaymentSheet({
    String amount = "0",
    String currency = 'INR',
    String clientSecret = '',
    String paymentIntentId = '',
    String merchantDisplayName = "",
  }) async {
    try {
      //setting up Payment Sheet
      // await Stripe.instance.initPaymentSheet(
      //   paymentSheetParameters: SetupPaymentSheetParameters(
      //     paymentIntentClientSecret: clientSecret,
      //     style: ThemeMode.light,
      //     merchantDisplayName: merchantDisplayName,
      //   ),
      // );

      //open payment sheet
      // await Stripe.instance.presentPaymentSheet();
    } catch (e) {
      throw Exception(ErrorMessageKeysAndCode.defaultErrorMessageCode);
    }
  }

  static StripeTransactionResponse getPlatformExceptionErrorResult(err) {
    String message = 'Something went wrong';
    if (err.code == 'cancelled') {
      message = 'Transaction cancelled';
    }
    return StripeTransactionResponse(
      message: message,
      success: false,
      status: 'cancelled',
    );
  }
}

class StripeTransactionResponse {
  final String? message, status;
  bool? success;

  StripeTransactionResponse({this.message, this.success, this.status});
}
