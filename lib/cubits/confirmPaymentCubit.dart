import 'package:yocut/data/models/paymentTransaction.dart';
import 'package:yocut/data/repositories/paymentRepository.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

abstract class ConfirmPaymentState {}

class ConfirmPaymentInitial extends ConfirmPaymentState {}

class ConfirmPaymentInProgress extends ConfirmPaymentState {}

class ConfirmPaymentSuccess extends ConfirmPaymentState {
  final PaymentTransaction paymentTransaction;

  ConfirmPaymentSuccess({required this.paymentTransaction});
}

class ConfirmPaymentFailure extends ConfirmPaymentState {
  final String errorMessage;

  ConfirmPaymentFailure(this.errorMessage);
}

class ConfirmPaymentCubit extends Cubit<ConfirmPaymentState> {
  final PaymentRepository _paymentRepository;

  ConfirmPaymentCubit(this._paymentRepository) : super(ConfirmPaymentInitial());

  void confirmPayment({required PaymentTransaction paymentTransaction}) async {
    try {
      emit(ConfirmPaymentInProgress());
      emit(ConfirmPaymentSuccess(
          paymentTransaction: await _paymentRepository.confirmPayment(
              paymentTransactionId: paymentTransaction.id ?? 0)));
    } catch (e) {
      emit(ConfirmPaymentFailure(e.toString()));
    }
  }
}
