import 'package:yocut/data/models/paymentTransaction.dart';
import 'package:yocut/data/repositories/paymentRepository.dart';
import 'package:yocut/utils/constants.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

abstract class LatestPaymentTransactionState {}

class LatestPaymentTransactionInitial extends LatestPaymentTransactionState {}

class LatestPaymentTransactionFetchInProgress
    extends LatestPaymentTransactionState {}

class LatestPaymentTransactionFetchSuccess
    extends LatestPaymentTransactionState {
  List<PaymentTransaction> transactions;

  LatestPaymentTransactionFetchSuccess({required this.transactions});
}

class LatestPaymentTransactionFetchFailure
    extends LatestPaymentTransactionState {
  final String errorMessage;

  LatestPaymentTransactionFetchFailure(this.errorMessage);
}

class LatestPaymentTransactionCubit
    extends Cubit<LatestPaymentTransactionState> {
  final PaymentRepository _paymentRepository;

  LatestPaymentTransactionCubit(this._paymentRepository)
      : super(LatestPaymentTransactionInitial());

  void fetchLatestPaymentTransactions() async {
    try {
      emit(LatestPaymentTransactionFetchInProgress());

      emit(LatestPaymentTransactionFetchSuccess(
          transactions:
              await _paymentRepository.getTransactions(fetchLatest: true)));
    } catch (e) {
      emit(LatestPaymentTransactionFetchFailure(e.toString()));
    }
  }

  List<PaymentTransaction> getLatestPaymentTransactions() {
    return state is LatestPaymentTransactionFetchSuccess
        ? (state as LatestPaymentTransactionFetchSuccess).transactions
        : [];
  }

  bool doesUserHaveLatestPendingTransactions() {
    return getLatestPaymentTransactions()
        .where(
            (element) => element.paymentStatus == pendingTransactionStatusKey)
        .toList()
        .isNotEmpty;
  }
}
