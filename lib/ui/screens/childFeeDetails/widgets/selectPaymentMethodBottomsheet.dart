import 'package:yocut/data/models/paymentGateway.dart';
import 'package:yocut/ui/widgets/bottomsheetTopTitleAndCloseButton.dart';
import 'package:yocut/utils/labelKeys.dart';
import 'package:yocut/utils/utils.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class SelectPaymentMethodBottomsheet extends StatelessWidget {
  final List<PaymentGeteway> paymentGeteways;
  const SelectPaymentMethodBottomsheet(
      {super.key, required this.paymentGeteways});

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Container(
        padding: EdgeInsets.symmetric(
          horizontal: MediaQuery.of(context).size.width * (0.075),
          vertical: MediaQuery.of(context).size.height * (0.04),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisSize: MainAxisSize.min,
          children: [
            BottomsheetTopTitleAndCloseButton(
              onTapCloseButton: () {
                Get.back();
              },
              titleKey: choosePayViaKey,
            ),
            Column(
              children: paymentGeteways.map((paymentGateway) {
                return ListTile(
                  onTap: () {
                    Get.back(result: paymentGateway);
                  },
                  tileColor:
                      Theme.of(context).colorScheme.secondary.withValues(alpha: 0.05),
                  dense: false,
                  title: Text(
                    "${Utils.getTranslatedLabel(payUsingKey)} ${paymentGateway.paymentMethod}",
                    style:
                        TextStyle(color: Theme.of(context).colorScheme.primary),
                  ),
                );
              }).toList(),
            ),
            const SizedBox(height: 25),
          ],
        ),
      ),
    );
  }
}
