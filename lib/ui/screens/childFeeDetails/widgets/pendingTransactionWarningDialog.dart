import 'package:yocut/utils/labelKeys.dart';
import 'package:yocut/utils/utils.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class PendingTransactionWarningDialog extends StatelessWidget {
  const PendingTransactionWarningDialog({super.key});

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      content: Padding(
        padding: const EdgeInsets.only(top: 15),
        child: Text(
          Utils.getTranslatedLabel(pendingPaymentTransactionWarningKey),
          style: TextStyle(
              color: Theme.of(context).colorScheme.secondary.withValues(alpha: 0.9),
              fontSize: 16.0,
              fontWeight: FontWeight.w600),
        ),
      ),
      actions: [
        CupertinoButton(
            child: Text(Utils.getTranslatedLabel(waitKey)),
            onPressed: () {
              Get.back(result: false);
            }),
        CupertinoButton(
            child: Text(Utils.getTranslatedLabel(continuePaymentKey)),
            onPressed: () {
              Get.back(result: true);
            }),
      ],
    );
  }
}
