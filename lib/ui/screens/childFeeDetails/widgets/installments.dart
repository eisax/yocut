import 'package:yocut/cubits/schoolConfigurationCubit.dart';
import 'package:yocut/data/models/advanceFee.dart';
import 'package:yocut/data/models/childFeeDetails.dart';
import 'package:yocut/ui/screens/childFeeDetails/widgets/advanceInstallmentPaidAmountBottomsheet.dart';
import 'package:yocut/utils/labelKeys.dart';
import 'package:yocut/utils/utils.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class Installments extends StatelessWidget {
  final ChildFeeDetails childFeeDetails;
  const Installments({super.key, required this.childFeeDetails});

  TextStyle getPaidOnTextStyle({required BuildContext context}) {
    return TextStyle(
        fontSize: 12.0,
        color: Theme.of(context).colorScheme.secondary.withValues(alpha: 0.75));
  }

  TextStyle getPaymentInfoTitleStyle({required BuildContext context}) {
    return TextStyle(
        fontSize: 16.0, color: Theme.of(context).colorScheme.secondary);
  }

  String getCurrencySymbol({required BuildContext context}) {
    return context
            .read<SchoolConfigurationCubit>()
            .getSchoolConfiguration()
            .schoolSettings
            .currencySymbol ??
        '';
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 15),
      child: Column(
        children: (childFeeDetails.installments ?? []).map((installment) {
          ///[If no amount to pay in installment then show nothing in ui]
          if ((installment.minimumAmount ?? 0.0) == 0.0) {
            return const SizedBox();
          }
          final isThisCurrentInstallment = installment.isCurrent ?? false;

          Color installmentNameColor = (installment.isCurrent ?? false)
              ? Theme.of(context).colorScheme.primary
              : Theme.of(context).colorScheme.secondary;

          List<AdvanceFee> advanceFees = childFeeDetails
              .installmentAdvancePaidAmount(installmentId: installment.id ?? 0);

          double totalAdvancePaidAmount = 0.0;
          for (var advanceFee in advanceFees) {
            totalAdvancePaidAmount =
                totalAdvancePaidAmount + (advanceFee.amount ?? 0.0);
          }

          double installmentAmount =
              (installment.minimumAmount ?? 0.0) - totalAdvancePaidAmount;
          ;

          return Container(
            padding: EdgeInsets.symmetric(vertical: 7.5),
            decoration: BoxDecoration(
                border: Border(
                    bottom: BorderSide(
                        color: Theme.of(context)
                            .colorScheme
                            .secondary
                            .withValues(alpha: 0.25)))),
            margin: const EdgeInsets.only(bottom: 5),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            children: [
                              Text(
                                installment.name ?? "",
                                style: TextStyle(
                                    fontWeight: isThisCurrentInstallment
                                        ? FontWeight.bold
                                        : null,
                                    color: installmentNameColor),
                              ),
                              SizedBox(
                                width:
                                    (installment.isPaid ?? false) ? 2.5 : 0.0,
                              ),
                              (installment.isPaid ?? false)
                                  ? Icon(Icons.verified,
                                      size: 14.0,
                                      color: Theme.of(context)
                                          .colorScheme
                                          .onPrimary)
                                  : const SizedBox()
                            ],
                          ),
                          (installment.isPaid ?? false)
                              ? Text(
                                  "${Utils.getTranslatedLabel(paidOnKey)} ${Utils.formatDate(DateTime.parse(childFeeDetails.installmentPaidDate(installmentId: installment.id ?? 0)))}",
                                  style: getPaidOnTextStyle(context: context),
                                )
                              : Text(
                                  "${Utils.getTranslatedLabel(dueDateKey)} : ${installment.dueDate ?? '-'}",
                                  style: TextStyle(
                                      fontSize: 12,
                                      color: installment.isInstallmentOverdue()
                                          ? Theme.of(context).colorScheme.error
                                          : Theme.of(context)
                                              .colorScheme
                                              .secondary
                                              .withValues(alpha: 0.75)),
                                )
                        ],
                      ),
                    ),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.end,
                      children: [
                        Text(
                          "${getCurrencySymbol(context: context)}${installmentAmount.toStringAsFixed(2)}",
                          style: TextStyle(
                              fontWeight: isThisCurrentInstallment
                                  ? FontWeight.bold
                                  : null,
                              color: Theme.of(context).colorScheme.primary),
                        ),
                        installment.isInstallmentOverdue()
                            ? Text(
                                "${getCurrencySymbol(context: context)}${(installment.dueChargeAmount ?? 0.0).toStringAsFixed(2)}",
                                style: TextStyle(
                                    fontSize: 13.0,
                                    color: Theme.of(context).colorScheme.error),
                              )
                            : const SizedBox()
                      ],
                    ),
                  ],
                ),
                (installment.isPaid ?? false)
                    ? const SizedBox()
                    : installment.isInstallmentOverdue()
                        ? Text(
                            "Due charge is ${installment.dueCharges?.toStringAsFixed(2) ?? '-'}% of decided installment amount",
                            style: TextStyle(
                                fontSize: 12.0,
                                color: Theme.of(context)
                                    .colorScheme
                                    .secondary
                                    .withValues(alpha: 0.75)),
                          )
                        : const SizedBox(),
                advanceFees.isEmpty
                    ? const SizedBox()
                    : Padding(
                        padding: const EdgeInsets.only(top: 5.0),
                        child: Row(
                          children: [
                            Text(Utils.getTranslatedLabel(advancePaidAmountKey),
                                style: getPaidOnTextStyle(context: context)),
                            const SizedBox(
                              width: 2.5,
                            ),
                            GestureDetector(
                              onTap: () {
                                Utils.showBottomSheet(
                                    child:
                                        AdvanceInstallmentPaidAmountBottomsheet(
                                      advanceFees: advanceFees,
                                    ),
                                    context: context);
                              },
                              child: Container(
                                decoration: BoxDecoration(
                                  border: Border.all(color: Colors.transparent),
                                ),
                                child: Icon(
                                  CupertinoIcons.info,
                                  size: 13.0,
                                ),
                              ),
                            ),
                            const Spacer(),
                            Text(
                              "${getCurrencySymbol(context: context)}${(totalAdvancePaidAmount).toStringAsFixed(2)}",
                              style: TextStyle(
                                  fontSize: 13.0,
                                  color: Theme.of(context).colorScheme.primary),
                            )
                          ],
                        ),
                      ),
              ],
            ),
          );
        }).toList(),
      ),
    );
  }
}
