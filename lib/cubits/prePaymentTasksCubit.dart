import 'package:yocut/data/models/paymentGateway.dart';
import 'package:yocut/data/models/paymentTransaction.dart';
import 'package:yocut/data/repositories/feeRepository.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

abstract class PrePaymentTasksState {}

class PrePaymentTasksInitial extends PrePaymentTasksState {}

class PrePaymentTasksInProgress extends PrePaymentTasksState {}

class PrePaymentTasksSuccess extends PrePaymentTasksState {
  final Map<String, dynamic> data;
  final PaymentGeteway paymentMethod;
  final PaymentTransaction paymentTransaction;

  PrePaymentTasksSuccess(
      {required this.data,
      required this.paymentMethod,
      required this.paymentTransaction});
}

class PrePaymentTasksFailure extends PrePaymentTasksState {
  final String errorMessage;

  PrePaymentTasksFailure(this.errorMessage);
}

class PrePaymentTasksCubit extends Cubit<PrePaymentTasksState> {
  final FeeRepository _feeRepository = FeeRepository();

  PrePaymentTasksCubit() : super(PrePaymentTasksInitial());

  Future<void> performPrePaymentTasks(
      {required PaymentGeteway paymentMethod,
      required int childId,
      required int feeId,
      required bool compulsoryFee,
      List<int>? installmentIds,
      double? advanceAmount,
      List<int>? optionalFeeIds}) async {
    try {
      emit(PrePaymentTasksInProgress());
      final (:paymentTransaction, :data) = compulsoryFee
          ? await _feeRepository.payCompulsoryFee(
              advanceAmount: advanceAmount,
              installmentIds: installmentIds,
              paymentMethod: paymentMethod.paymentMethod ?? "",
              childId: childId,
              feeId: feeId)
          : await _feeRepository.payOptionalFees(
              paymentMethod: paymentMethod.paymentMethod ?? "",
              childId: childId,
              feeId: feeId,
              optionalFeeIds: optionalFeeIds ?? []);

      emit(PrePaymentTasksSuccess(
          data: data,
          paymentMethod: paymentMethod,
          paymentTransaction: paymentTransaction));
    } catch (e) {
      emit(PrePaymentTasksFailure(e.toString()));
    }
  }

  String getStripePaymentIntentId() {
    if (state is PrePaymentTasksSuccess) {
      return (state as PrePaymentTasksSuccess).data['id'].toString();
    }
    return "";
  }

  String getRazorpayOrderId() {
    if (state is PrePaymentTasksSuccess) {
      return (state as PrePaymentTasksSuccess).data['id'].toString();
    }
    return "";
  }

  double getRazorpayAmountToPay() {
    if (state is PrePaymentTasksSuccess) {
      return double.parse(
          ((state as PrePaymentTasksSuccess).data['amount'] ?? 0.0).toString());
    }
    return 0.0;
  }

  PaymentGeteway getSelectedPaymentMethod() {
    if (state is PrePaymentTasksSuccess) {
      return (state as PrePaymentTasksSuccess).paymentMethod;
    }
    return PaymentGeteway.fromJson({});
  }

  PaymentTransaction getPaymentTransaction() {
    if (state is PrePaymentTasksSuccess) {
      return (state as PrePaymentTasksSuccess).paymentTransaction;
    }
    return PaymentTransaction.fromJson({});
  }

  String getStripePaymentClientSecret() {
    if (state is PrePaymentTasksSuccess) {
      return (state as PrePaymentTasksSuccess).data['client_secret'].toString();
    }
    return "";
  }
}
