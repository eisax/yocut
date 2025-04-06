import 'dart:convert';
import 'dart:io';

import 'package:yocut/data/repositories/feeRepository.dart';
import 'package:yocut/utils/errorMessageKeysAndCodes.dart';

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:path_provider/path_provider.dart';

abstract class DownloadFeeReceiptState {}

class DownloadFeeReceiptInitial extends DownloadFeeReceiptState {}

class DownloadFeeReceiptInProgress extends DownloadFeeReceiptState {}

class DownloadFeeReceiptSuccess extends DownloadFeeReceiptState {
  final String downloadedFilePath;

  DownloadFeeReceiptSuccess({required this.downloadedFilePath});
}

class DownloadFeeReceiptFailure extends DownloadFeeReceiptState {
  final String errorMessage;

  DownloadFeeReceiptFailure(this.errorMessage);
}

class DownloadFeeReceiptCubit extends Cubit<DownloadFeeReceiptState> {
  final FeeRepository _feeRepository;

  DownloadFeeReceiptCubit(this._feeRepository)
      : super(DownloadFeeReceiptInitial());

  void downloadFeeReceipt({required int childId, required int feeId}) async {
    try {
      emit(DownloadFeeReceiptInProgress());

      String filePath = "";
      final path = (await getApplicationDocumentsDirectory()).path;
      filePath = "$path/Fees-Receipts/$childId-$feeId.pdf";

      final File file = File(filePath);

      final receiptContent =
          await _feeRepository.getFeeReceipt(childId: childId, feeId: feeId);
      await file.create(recursive: true);

      await file.writeAsBytes(base64Decode(receiptContent));
      emit(DownloadFeeReceiptSuccess(downloadedFilePath: filePath));
    } catch (e) {
      emit(DownloadFeeReceiptFailure(
          ErrorMessageKeysAndCode.defaultErrorMessageKey));
    }
  }
}
