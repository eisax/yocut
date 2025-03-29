import 'package:yocut/ui/widgets/bottomsheetTopTitleAndCloseButton.dart';
import 'package:yocut/ui/widgets/customRoundedButton.dart';
import 'package:yocut/ui/widgets/customTextFieldContainer.dart';
import 'package:yocut/utils/labelKeys.dart';
import 'package:yocut/utils/utils.dart';
import 'package:flutter/material.dart';
import 'package:get/route_manager.dart';

class AdvanceInstallmentAmountBottomsheet extends StatefulWidget {
  final double advanceInstallmentAmount;
  final double maximumAmountLimit;
  const AdvanceInstallmentAmountBottomsheet(
      {super.key,
      required this.maximumAmountLimit,
      required this.advanceInstallmentAmount});

  @override
  State<AdvanceInstallmentAmountBottomsheet> createState() =>
      _AdvanceInstallmentAmountBottomsheetState();
}

class _AdvanceInstallmentAmountBottomsheetState
    extends State<AdvanceInstallmentAmountBottomsheet> {
  late final TextEditingController _textEditingController =
      TextEditingController(text: widget.advanceInstallmentAmount.toString());

  @override
  void dispose() {
    _textEditingController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.only(
          bottom: MediaQuery.of(context).viewInsets.bottom,
          left: MediaQuery.of(context).size.width * (0.075),
          right: MediaQuery.of(context).size.width * (0.075)),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: [
          const SizedBox(
            height: 25,
          ),
          BottomsheetTopTitleAndCloseButton(
            onTapCloseButton: () {
              Get.back();
            },
            titleKey: changeInstallmentAmountKey,
          ),
          CustomTextFieldContainer(
              bottomPadding: 5,
              textEditingController: _textEditingController,
              hideText: false,
              hintTextKey: installmentAmountKey),
          const SizedBox(
            height: 10,
          ),
          Center(
            child: CustomRoundedButton(
              height: 40,
              widthPercentage: 0.3,
              backgroundColor: Theme.of(context).colorScheme.primary,
              buttonTitle: submitKey,
              showBorder: false,
              onTap: () {
                FocusScope.of(context).unfocus();
                final advanceAmount =
                    double.tryParse(_textEditingController.text.trim());
                if (advanceAmount == null) {
                  Utils.showCustomSnackBar(
                      context: context,
                      errorMessage:
                          Utils.getTranslatedLabel(pleaseEnterValidAmountKey),
                      backgroundColor: Theme.of(context).colorScheme.error);
                  return;
                }

                if (advanceAmount <= 0.0) {
                  Utils.showCustomSnackBar(
                      context: context,
                      errorMessage:
                          Utils.getTranslatedLabel(pleaseEnterValidAmountKey),
                      backgroundColor: Theme.of(context).colorScheme.error);
                  return;
                }

                if (advanceAmount.toDouble() > widget.maximumAmountLimit) {
                  Utils.showCustomSnackBar(
                      context: context,
                      errorMessage:
                          "${Utils.getTranslatedLabel(maximumAmountIsKey)} ${widget.maximumAmountLimit.toStringAsFixed(2)}",
                      backgroundColor: Theme.of(context).colorScheme.error);
                  return;
                }

                Get.back(result: advanceAmount);
              },
            ),
          ),
          const SizedBox(
            height: 50,
          ),
        ],
      ),
    );
  }
}
