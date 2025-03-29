// ignore: depend_on_referenced_packages
import 'package:bloc/bloc.dart';
import 'package:yocut/data/repositories/studentRepository.dart';
import 'package:yocut/utils/stripeService.dart';
import 'package:flutter/foundation.dart';

abstract class PostFeesPaymentState {}

class PostFeesPaymentInitial extends PostFeesPaymentState {}

class PostFeesPaymentSuccess extends PostFeesPaymentState {}

class PostFeesPaymentFailure extends PostFeesPaymentState {
  final String errorMessage;

  PostFeesPaymentFailure(this.errorMessage);
}

class PostFeesPaymentInProgress extends PostFeesPaymentState {}

class PostFeesPaymentCubit extends Cubit<PostFeesPaymentState> {
  final StudentRepository _studentRepository;

  PostFeesPaymentCubit(this._studentRepository)
      : super(PostFeesPaymentInitial());

  Future<void> storeFees({
    required int? status,
    required String transactionId,
    required int childId,
    required bool verifyStripePaymentIntent,
    String? stripePaymentSecretKey,
    String? paymentIntentId,
    String? paymentId,
    String? paymentSignature,
  }) async {
    emit(PostFeesPaymentInProgress());
    try {
      if (status == 1 || verifyStripePaymentIntent) {
        // 1 is success when calling this function
        if (verifyStripePaymentIntent) {
          final paymentIntentStatus =
              await _studentRepository.confirmStripePayment(
            paymentIntentId: paymentIntentId ?? "",
            paymentSecretKey: stripePaymentSecretKey ?? "",
          );

          if (paymentIntentStatus !=
              StripeService.paymentIntentSuccessResponse) {
            throw Exception("Payment failed");
          }
        }
        await _studentRepository.storeFees(
          childId: childId,
          transactionId: transactionId,
          paymentId: paymentId,
          paymentSignature: paymentSignature,
        );
        emit(PostFeesPaymentSuccess());
      } else {
        if (kDebugMode) {
          print("Payment Error because of status.");
        }
        await _studentRepository.failPaymentTransaction(
          transactionId: transactionId,
        );
        emit(PostFeesPaymentFailure("Payment failed"));
      }
    } catch (e, st) {
      if (kDebugMode) {
        print("Payment Error: $e $st");
      }
      await _studentRepository.failPaymentTransaction(
        transactionId: transactionId,
      );
      emit(PostFeesPaymentFailure(e.toString()));
    }
  }
}
