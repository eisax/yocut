import 'package:yocut/app/routes.dart';
import 'package:yocut/cubits/authCubit.dart';
import 'package:yocut/cubits/downloadFeeReceiptCubit.dart';
import 'package:yocut/cubits/latestPaymentTransactionCubit.dart';
import 'package:yocut/cubits/prePaymentTasksCubit.dart';
import 'package:yocut/cubits/schoolConfigurationCubit.dart';
import 'package:yocut/data/models/classFeeType.dart';
import 'package:yocut/data/models/childFeeDetails.dart';
import 'package:yocut/data/models/paymentGateway.dart';
import 'package:yocut/data/models/student.dart';
import 'package:yocut/data/repositories/feeRepository.dart';
import 'package:yocut/data/repositories/paymentRepository.dart';
import 'package:yocut/ui/screens/childFeeDetails/widgets/advanceInstallmentAmountBottomsheet.dart';
import 'package:yocut/ui/screens/childFeeDetails/widgets/downloadReceiptDialog.dart';
import 'package:yocut/ui/screens/childFeeDetails/widgets/feeInformationContainer.dart';
import 'package:yocut/ui/screens/childFeeDetails/widgets/installments.dart';
import 'package:yocut/ui/screens/childFeeDetails/widgets/pendingTransactionWarningDialog.dart';
import 'package:yocut/ui/screens/childFeeDetails/widgets/selectPaymentMethodBottomsheet.dart';
import 'package:yocut/ui/widgets/customBackButton.dart';
import 'package:yocut/ui/widgets/customCircularProgressIndicator.dart';
import 'package:yocut/ui/widgets/customRoundedButton.dart';
import 'package:yocut/ui/widgets/customTabBarContainer.dart';
import 'package:yocut/ui/widgets/screenTopBackgroundContainer.dart';
import 'package:yocut/ui/widgets/tabBarBackgroundContainer.dart';
import 'package:yocut/utils/constants.dart';
import 'package:yocut/utils/labelKeys.dart';
import 'package:yocut/utils/utils.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
// import 'package:flutter_stripe/flutter_stripe.dart';
import 'package:get/get.dart';
// import 'package:razorpay_flutter/razorpay_flutter.dart';

///[We will check first that is there any recent(30 minutes) pending transaction by user or not]
///[If user has any pending transaciton then we will give them warning]

class ChildFeeDetailsScreen extends StatefulWidget {
  final ChildFeeDetails childFeeDetails;
  final Student child;
  const ChildFeeDetailsScreen(
      {super.key, required this.childFeeDetails, required this.child});

  static Widget routeInstance() {
    final arguments = Get.arguments as Map<String, dynamic>;
    return MultiBlocProvider(
      providers: [
        BlocProvider(
          create: (context) => PrePaymentTasksCubit(),
        ),
        BlocProvider(
            create: (context) =>
                LatestPaymentTransactionCubit(PaymentRepository())),
      ],
      child: ChildFeeDetailsScreen(
        childFeeDetails: arguments['childFeeDetails'] as ChildFeeDetails,
        child: arguments['child'] as Student,
      ),
    );
  }

  @override
  State<ChildFeeDetailsScreen> createState() => _ChildFeeDetailsScreenState();
}

class _ChildFeeDetailsScreenState extends State<ChildFeeDetailsScreen> {
  late String _currentlySelectedTabKey = compulsoryTitleKey;
  late final List<int> _toPayOptionalFeeIds = [];
  late bool _enablePayInInstallments = false;
  late bool showPendingTransactionDialog = true;
  late double _advanceAmount = 0;

  // final Razorpay _razorpay = Razorpay();

  // @override
  // void initState() {
  //   super.initState();
  //   _razorpay.on(Razorpay.EVENT_PAYMENT_SUCCESS, handleRazorpayPaymentSuccess);
  //   _razorpay.on(Razorpay.EVENT_PAYMENT_ERROR, handleRazorpayPaymentError);
  // }

  // @override
  // void dispose() {
  //   _razorpay.clear();
  //   super.dispose();
  // }

  String getCurrencySymbol() {
    return context
            .read<SchoolConfigurationCubit>()
            .getSchoolConfiguration()
            .schoolSettings
            .currencySymbol ??
        '';
  }

  TextStyle getPaidOnTextStyle() {
    return TextStyle(
        fontSize: 12.0,
        color: Theme.of(context).colorScheme.secondary.withValues(alpha: 0.75));
  }

  TextStyle getPaymentInfoTitleStyle() {
    return TextStyle(
        fontSize: 16.0, color: Theme.of(context).colorScheme.secondary);
  }

  TextStyle getPaymentInfoAmountValueStyle() {
    return TextStyle(
        fontSize: 16.0, color: Theme.of(context).colorScheme.primary);
  }

  ///[This will to determine wheather to show pay in installment button or not]
  bool showPayInInstallmentsContainer() {
    //if intallment allowed by school
    if (widget.childFeeDetails.includeFeeInstallments ?? false) {
      return (widget.childFeeDetails
          .hasPaidCompulsoryFullyOrUsingInstallment());
    }
    return false;
  }

  //
  void onTapSelectOptionalFee({required int optionalFeeId}) {
    if (_toPayOptionalFeeIds.contains(optionalFeeId)) {
      _toPayOptionalFeeIds.removeWhere((element) => element == optionalFeeId);
    } else {
      _toPayOptionalFeeIds.add(optionalFeeId);
    }
    setState(() {});
  }

  void navigateToConfirmPaymentScreen() {
    Get.offNamed(Routes.confirmPayment);
  }

  // void handleRazorpayPaymentSuccess(PaymentSuccessResponse response) {
  //   navigateToConfirmPaymentScreen();
  // }

  // void handleRazorpayPaymentError(PaymentFailureResponse response) {
  //   navigateToConfirmPaymentScreen();
  // }

  void payWithRazorpay({required String razorpayApiKey}) async {
    try {
      var options = {
        'key': razorpayApiKey,
        'amount': context.read<PrePaymentTasksCubit>().getRazorpayAmountToPay(),
        'order_id': context.read<PrePaymentTasksCubit>().getRazorpayOrderId(),
        'name': context
                .read<SchoolConfigurationCubit>()
                .getSchoolConfiguration()
                .schoolSettings
                .schoolName ??
            '',
        'prefill': {
          'contact': context.read<AuthCubit>().getParentDetails().mobile ?? "",
          'email': context.read<AuthCubit>().getParentDetails().email ?? ""
        },
      };
      // _razorpay.open(options);
    } catch (e) {
      navigateToConfirmPaymentScreen();
    }
  }

  // ///[To make payment using stripe sdk]
  // void payWithStripe({required String stripePublishableKey}) async {
  //   try {
  //     Stripe.publishableKey = stripePublishableKey;

  //     await Stripe.instance.initPaymentSheet(
  //       paymentSheetParameters: SetupPaymentSheetParameters(
  //         billingDetailsCollectionConfiguration:
  //             BillingDetailsCollectionConfiguration(
  //           address: AddressCollectionMode.full,
  //           email: CollectionMode.always,
  //           name: CollectionMode.always,
  //           phone: CollectionMode.always,
  //         ),
  //         paymentIntentClientSecret: context
  //             .read<PrePaymentTasksCubit>()
  //             .getStripePaymentClientSecret(),
  //         style: ThemeMode.light,
  //         merchantDisplayName: context
  //                 .read<SchoolConfigurationCubit>()
  //                 .getSchoolConfiguration()
  //                 .schoolSettings
  //                 .schoolName ??
  //             '',
  //       ),
  //     );

  //     //open payment sheet
  //     await Stripe.instance.presentPaymentSheet();

  //     navigateToConfirmPaymentScreen();
  //   } on StripeException catch (e) {
  //     ///[Payment cancel by user]
  //     if (e.error.code == FailureCode.Canceled) {
  //       navigateToConfirmPaymentScreen();
  //     }
  //   } on StripeConfigException catch (e) {
  //     if (kDebugMode) {
  //       print(e.message);
  //     }
  //     Utils.showCustomSnackBar(
  //         context: context,
  //         errorMessage: Utils.getTranslatedLabel(
  //             ErrorMessageKeysAndCode.defaultErrorMessageKey),
  //         backgroundColor: Theme.of(context).colorScheme.error);
  //   } catch (e) {
  //     if (kDebugMode) {
  //       print(e.toString());
  //     }
  //     Utils.showCustomSnackBar(
  //         context: context,
  //         errorMessage: Utils.getTranslatedLabel(
  //             ErrorMessageKeysAndCode.defaultErrorMessageKey),
  //         backgroundColor: Theme.of(context).colorScheme.error);
  //   }
  // }

  void prePaymentTasksListener(
      BuildContext context, PrePaymentTasksState state) {
    if (state is PrePaymentTasksFailure) {
      Utils.showCustomSnackBar(
          context: context,
          errorMessage:
              Utils.getErrorMessageFromErrorCode(context, state.errorMessage),
          backgroundColor: Theme.of(context).colorScheme.error);
    } else if (state is PrePaymentTasksSuccess) {
      if (state.paymentMethod.paymentMethod == stripePaymentMethodKey) {
        // payWithStripe(stripePublishableKey: state.paymentMethod.apiKey ?? "");
      } else if (state.paymentMethod.paymentMethod ==
          razorpayPaymentMethodKey) {
        payWithRazorpay(razorpayApiKey: state.paymentMethod.apiKey ?? "");
      }
    }
  }

  //
  void startPrePaymentProcess(
      {double? advanceAmount, List<int>? installmentIds}) {
    ///[Will check for multiple enabled payment gateways]
    final enabledPaymentGateways = context
        .read<SchoolConfigurationCubit>()
        .getSchoolConfiguration()
        .body.registration;

    ///[If there is only one enabled payment gateway then start the prepayment process]
    if (enabledPaymentGateways.length == 1) {
      context.read<PrePaymentTasksCubit>().performPrePaymentTasks(
          advanceAmount: advanceAmount,
          installmentIds: installmentIds,
          optionalFeeIds: _toPayOptionalFeeIds,
          compulsoryFee: _currentlySelectedTabKey == compulsoryTitleKey,
          paymentMethod: enabledPaymentGateways.first,
          childId: 0,
          feeId: widget.childFeeDetails.id ?? 0);
    } else {
      ///[If multiple payment gateway enabled by school then user need to select the payment gateway]
      Utils.showBottomSheet(
              child: SelectPaymentMethodBottomsheet(
                  paymentGeteways: enabledPaymentGateways),
              context: context)
          .then((selectedPaymentMethod) {
        if (selectedPaymentMethod != null) {
          ///[Start the prepayment process with selected payment gateway]
          context.read<PrePaymentTasksCubit>().performPrePaymentTasks(
              advanceAmount: advanceAmount,
              installmentIds: installmentIds,
              optionalFeeIds: _toPayOptionalFeeIds,
              compulsoryFee: _currentlySelectedTabKey == compulsoryTitleKey,
              paymentMethod: selectedPaymentMethod as PaymentGeteway,
              childId:  0,
              feeId: widget.childFeeDetails.id ?? 0);
        }
      });
    }
  }

  ///[Listener of latest payment transaction cubit]
  void latestPaymentTransactionListener(
      {required LatestPaymentTransactionState state,
      double? advanceAmount,
      List<int>? installmentIds}) {
    if (state is LatestPaymentTransactionFetchSuccess) {
      ///[If there is any pending transaciton by this user in recent time then show the warning]
      if (context
          .read<LatestPaymentTransactionCubit>()
          .doesUserHaveLatestPendingTransactions()) {
        ///[Show warning]
        Get.dialog<bool>(PendingTransactionWarningDialog()).then((value) {
          if (value != null && value) {
            startPrePaymentProcess(
                advanceAmount: advanceAmount, installmentIds: installmentIds);
          }
        });
      } else {
        startPrePaymentProcess(
            advanceAmount: advanceAmount, installmentIds: installmentIds);
      }
    } else if (state is LatestPaymentTransactionFetchFailure) {
      Utils.showCustomSnackBar(
          context: context,
          errorMessage:
              Utils.getErrorMessageFromErrorCode(context, state.errorMessage),
          backgroundColor: Theme.of(context).colorScheme.error);
    }
  }

  Widget _buildDownloadFeeReceiptButton() {
    if ((widget.childFeeDetails.paidFees ?? []).isEmpty) {
      return const SizedBox();
    }
    return GestureDetector(
      onTap: () {
        Get.dialog(BlocProvider(
          create: (context) => DownloadFeeReceiptCubit(FeeRepository()),
          child: DownloadReceiptDialog(
            child: widget.child,
            childFeeDetails: widget.childFeeDetails,
          ),
        ));
      },
      child: Container(
        decoration:
            BoxDecoration(border: Border.all(color: Colors.transparent)),
        child: Icon(
          CupertinoIcons.printer,
          color: Theme.of(context).scaffoldBackgroundColor,
        ),
      ),
    );
  }

  Widget _buildAppBar() {
    return ScreenTopBackgroundContainer(
      child: LayoutBuilder(
        builder: (context, boxConstraints) {
          return Stack(
            clipBehavior: Clip.none,
            children: [
              CustomBackButton(
                onTap: () {
                  if (context.read<PrePaymentTasksCubit>().state
                      is PrePaymentTasksInProgress) {
                    return;
                  }
                  if (context.read<LatestPaymentTransactionCubit>().state
                      is LatestPaymentTransactionFetchInProgress) {
                    return;
                  }
                  Get.back();
                },
              ),
              Align(
                  alignment: AlignmentDirectional.topEnd,
                  child: Padding(
                    padding: EdgeInsetsDirectional.only(
                        end: Utils.screenContentHorizontalPadding),
                    child: _buildDownloadFeeReceiptButton(),
                  )),
              Align(
                alignment: Alignment.topCenter,
                child: Container(
                  alignment: Alignment.topCenter,
                  width: boxConstraints.maxWidth * (0.5),
                  child: Text(
                    Utils.getTranslatedLabel(feeDetailsKey),
                    style: TextStyle(
                      color: Theme.of(context).scaffoldBackgroundColor,
                      fontSize: Utils.screenTitleFontSize,
                    ),
                  ),
                ),
              ),
              AnimatedAlign(
                curve: Utils.tabBackgroundContainerAnimationCurve,
                duration: Utils.tabBackgroundContainerAnimationDuration,
                alignment: _currentlySelectedTabKey == compulsoryTitleKey
                    ? AlignmentDirectional.centerStart
                    : AlignmentDirectional.centerEnd,
                child:
                    TabBarBackgroundContainer(boxConstraints: boxConstraints),
              ),
              CustomTabBarContainer(
                boxConstraints: boxConstraints,
                alignment: AlignmentDirectional.centerStart,
                isSelected: _currentlySelectedTabKey == compulsoryTitleKey,
                onTap: () {
                  if (context.read<PrePaymentTasksCubit>().state
                      is PrePaymentTasksInProgress) {
                    return;
                  }
                  if (context.read<LatestPaymentTransactionCubit>().state
                      is LatestPaymentTransactionFetchInProgress) {
                    return;
                  }
                  setState(() {
                    _currentlySelectedTabKey = compulsoryTitleKey;
                  });
                },
                titleKey: compulsoryTitleKey,
              ),
              CustomTabBarContainer(
                boxConstraints: boxConstraints,
                alignment: AlignmentDirectional.centerEnd,
                isSelected: _currentlySelectedTabKey == optionalTitleKey,
                onTap: () {
                  if (context.read<PrePaymentTasksCubit>().state
                      is PrePaymentTasksInProgress) {
                    return;
                  }
                  if (context.read<LatestPaymentTransactionCubit>().state
                      is LatestPaymentTransactionFetchInProgress) {
                    return;
                  }
                  setState(() {
                    _currentlySelectedTabKey = optionalTitleKey;
                  });
                },
                titleKey: optionalTitleKey,
              ),
            ],
          );
        },
      ),
    );
  }

  Widget _buildPaymentInfoBackgroundContainer({required Widget child}) {
    return Container(
      width: MediaQuery.of(context).size.width,
      decoration: BoxDecoration(
          color: Theme.of(context).scaffoldBackgroundColor,
          boxShadow: [
            BoxShadow(
                blurRadius: 7.5,
                color: Colors.black26,
                spreadRadius: 2.5,
                offset: Offset(0, 0))
          ],
          borderRadius: BorderRadius.only(
            topLeft: Radius.circular(Utils.bottomSheetTopRadius),
            topRight: Radius.circular(Utils.bottomSheetTopRadius),
          )),
      padding: EdgeInsets.symmetric(horizontal: 20.0, vertical: 25.0),
      child: child,
    );
  }

  Widget _buildAdvanceAmountContainer() {
    return Row(
      children: [
        Text(
          Utils.getTranslatedLabel(advanceAmountKey),
          style: getPaymentInfoTitleStyle(),
        ),
        const Spacer(),
        Text(
          "${getCurrencySymbol()}${_advanceAmount.toStringAsFixed(2)}",
          style: getPaymentInfoAmountValueStyle(),
        ),
        GestureDetector(
          onTap: () {
            ///[To change the installment amount]
            Utils.showBottomSheet(
                    enableDrag: true,
                    child: AdvanceInstallmentAmountBottomsheet(
                        advanceInstallmentAmount: _advanceAmount,
                        maximumAmountLimit: widget.childFeeDetails
                            .maximumAdvanceInstallmentAmount()),
                    context: context)
                .then((value) {
              if (value != null) {
                _advanceAmount = value as double;
                setState(() {});
              }
            });
          },
          child: Container(
            padding: EdgeInsets.symmetric(horizontal: 2.5, vertical: 2.5),
            decoration:
                BoxDecoration(border: Border.all(color: Colors.transparent)),
            child: Icon(
              Icons.edit,
              size: 18,
              color: Theme.of(context).colorScheme.secondary.withValues(alpha: 0.3),
            ),
          ),
        )
      ],
    );
  }

  ///[If compulsory fee is selected then show payment info]
  Widget _buildCompulsoryInstallmentPaymentInfoContainer() {
    final outstandingInstallmentsAmount =
        widget.childFeeDetails.getOutstandingInstallmentAmount();

    final currentInstallmentAmount =
        (widget.childFeeDetails.currentInstallment().isPaid ?? false)
            ? 0.0
            : widget.childFeeDetails.currentInstallment().minimumAmount ?? 0.0;

    final totalAmount = outstandingInstallmentsAmount +
        currentInstallmentAmount +
        _advanceAmount;

    List<int> installmentIds = [];
    installmentIds.add(widget.childFeeDetails.currentInstallment().id ?? 0);
    for (var installment in widget.childFeeDetails.dueInstallments()) {
      installmentIds.add(installment.id ?? 0);
    }

    return _buildPaymentInfoBackgroundContainer(
        child: Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisSize: MainAxisSize.min,
      children: [
        outstandingInstallmentsAmount != 0.0
            ? Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Row(
                    children: [
                      Text(
                        Utils.getTranslatedLabel(outstandingInstallmentKey),
                        style: getPaymentInfoTitleStyle(),
                      ),
                      const Spacer(),
                      Text(
                        "${getCurrencySymbol()}${outstandingInstallmentsAmount.toStringAsFixed(2)}",
                        style: getPaymentInfoAmountValueStyle(),
                      )
                    ],
                  ),
                  const Divider(),
                ],
              )
            : const SizedBox(),
        (widget.childFeeDetails.currentInstallment().isPaid ?? false)
            ? const SizedBox()
            : Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Row(
                    children: [
                      Text(
                        widget.childFeeDetails.currentInstallment().name ?? '',
                        style: getPaymentInfoTitleStyle(),
                      ),
                      const Spacer(),
                      Text(
                        "${getCurrencySymbol()}${currentInstallmentAmount.toStringAsFixed(2)}",
                        style: getPaymentInfoAmountValueStyle(),
                      )
                    ],
                  ),
                  widget.childFeeDetails.hasAnyDueInstallment()
                      ? const Divider()
                      : const SizedBox()
                ],
              ),
        Column(
          mainAxisSize: MainAxisSize.min,
          children: [_buildAdvanceAmountContainer(), const Divider()],
        ),
        widget.childFeeDetails.hasAnyDueInstallment()
            ? Row(
                children: [
                  Text(
                    Utils.getTranslatedLabel(totalAmountKey),
                    style: getPaymentInfoTitleStyle(),
                  ),
                  const Spacer(),
                  Text(
                    "${getCurrencySymbol()}${totalAmount.toStringAsFixed(2)}",
                    style: getPaymentInfoAmountValueStyle(),
                  )
                ],
              )
            : const SizedBox(),
        (widget.childFeeDetails.currentInstallment().isPaid ?? false)
            ? Text(
                "${Utils.getTranslatedLabel(nextInstallmentPaymentStartsFromKey)} ${widget.childFeeDetails.currentInstallment().dueDate}",
                style: getPaidOnTextStyle(),
              )
            : const SizedBox(),
        const SizedBox(
          height: 15,
        ),
        _buildPayNowButton(
            installmentIds: installmentIds, advanceAmount: _advanceAmount)
      ],
    ));
  }

  ///[If compulsory fee is selected then show payment info]
  Widget _buildCompulsoryFullPaidPaymentInfoContainer() {
    final feeAmount = widget.childFeeDetails.totalCompulsoryFees ?? 0.0;
    final dueAmount = (widget.childFeeDetails.dueChargesAmount ?? 0.0);

    final totalAmount = feeAmount + dueAmount;
    return _buildPaymentInfoBackgroundContainer(
        child: Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Row(
          children: [
            Text(
              Utils.getTranslatedLabel(feeAmountKey),
              style: getPaymentInfoTitleStyle(),
            ),
            const Spacer(),
            Text(
              "${getCurrencySymbol()}${feeAmount.toStringAsFixed(2)}",
              style: getPaymentInfoAmountValueStyle(),
            )
          ],
        ),
        widget.childFeeDetails.isFeeOverDue()
            ? Row(
                children: [
                  Text(
                    Utils.getTranslatedLabel(dueAmountKey),
                    style: getPaymentInfoTitleStyle()
                        .copyWith(color: Theme.of(context).colorScheme.error),
                  ),
                  const Spacer(),
                  Text(
                    "${getCurrencySymbol()}${dueAmount.toStringAsFixed(2)}",
                    style: getPaymentInfoAmountValueStyle()
                        .copyWith(color: Theme.of(context).colorScheme.error),
                  )
                ],
              )
            : const SizedBox(),
        widget.childFeeDetails.isFeeOverDue()
            ? Row(
                children: [
                  Text(
                    Utils.getTranslatedLabel(totalAmountKey),
                    style: getPaymentInfoTitleStyle(),
                  ),
                  const Spacer(),
                  Text(
                    "${getCurrencySymbol()}${totalAmount.toStringAsFixed(2)}",
                    style: getPaymentInfoAmountValueStyle(),
                  )
                ],
              )
            : const SizedBox(),
        const SizedBox(
          height: 15,
        ),
        _buildPayNowButton()
      ],
    ));
  }

  Widget _buildOptionalBottmsheetPaymentInfoContainer() {
    if (!widget.childFeeDetails.hasOptionalFees()) {
      return const SizedBox();
    }

    if (widget.childFeeDetails.hasAnyUnpaidOptionlFee()) {
      double totalAmount = 0.0;
      for (var optionalFee in (widget.childFeeDetails.optionalFees ??
          ([] as List<ClassFeeType>))) {
        if (_toPayOptionalFeeIds.contains(optionalFee.id)) {
          totalAmount = (optionalFee.amount ?? 0.0) + totalAmount;
        }
      }

      //
      return _buildPaymentInfoBackgroundContainer(
          child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Row(
            children: [
              Text(
                Utils.getTranslatedLabel(totalAmountKey),
                style: getPaymentInfoTitleStyle(),
              ),
              const Spacer(),
              Text(
                "${getCurrencySymbol()}${totalAmount.toStringAsFixed(2)}",
                style: getPaymentInfoAmountValueStyle(),
              )
            ],
          ),

          //
          const SizedBox(
            height: 15,
          ),
          _buildPayNowButton()
        ],
      ));
    }

    return const SizedBox();
  }

  Widget _buildCompulsoryBottomPaymentInfoContainer() {
    if (widget.childFeeDetails.isCompulsoryFeeFullyPaid()) {
      return const SizedBox();
    }

    bool usedInstallment = _enablePayInInstallments ||
        (widget.childFeeDetails
            .didUserPaidPreviousCompulsoryFeeInInstallment());

    if (usedInstallment) {
      return _buildCompulsoryInstallmentPaymentInfoContainer();
    }

    return _buildCompulsoryFullPaidPaymentInfoContainer();
  }

  Widget _buildPayNowButton(
      {double? advanceAmount, List<int>? installmentIds}) {
    return BlocConsumer<LatestPaymentTransactionCubit,
        LatestPaymentTransactionState>(
      listener: (context, state) {
        latestPaymentTransactionListener(
            state: state,
            advanceAmount: advanceAmount,
            installmentIds: installmentIds);
      },
      builder: (context, state) {
        return BlocConsumer<PrePaymentTasksCubit, PrePaymentTasksState>(
          listener: prePaymentTasksListener,
          builder: (context, paymentTaskState) {
            return PopScope(
              canPop: (state is! LatestPaymentTransactionFetchInProgress) &&
                  (paymentTaskState is! PrePaymentTasksInProgress),
              child: CustomRoundedButton(
                height: 35,
                radius: 5.0,
                widthPercentage: 0.9,
                backgroundColor: Theme.of(context).colorScheme.primary,
                buttonTitle: Utils.getTranslatedLabel(payNowKey),
                showBorder: false,
                child: (paymentTaskState is PrePaymentTasksInProgress) ||
                        (state is LatestPaymentTransactionFetchInProgress)
                    ? CustomCircularProgressIndicator(
                        widthAndHeight: 20,
                        strokeWidth: 2,
                      )
                    : null,
                onTap: () {
                  if (state is LatestPaymentTransactionFetchInProgress) {
                    return;
                  }
                  if (paymentTaskState is PrePaymentTasksInProgress) {
                    return;
                  }

                  if (_currentlySelectedTabKey == optionalTitleKey) {
                    ///
                    if (_toPayOptionalFeeIds.isEmpty) {
                      Utils.showCustomSnackBar(
                          context: context,
                          errorMessage: Utils.getTranslatedLabel(
                              pleaseSelectAtLeastOneOptionalFeeKey),
                          backgroundColor: Theme.of(context).colorScheme.error);
                      return;
                    }

                    ///
                  } else {
                    if ((widget.childFeeDetails.currentInstallment().isPaid ??
                        false)) {
                      if (_advanceAmount <= 0.0) {
                        Utils.showCustomSnackBar(
                            context: context,
                            errorMessage: Utils.getTranslatedLabel(
                                advanceAmountCanNotBeZeroKey),
                            backgroundColor:
                                Theme.of(context).colorScheme.error);
                        return;
                      }
                    }
                  }

                  context
                      .read<LatestPaymentTransactionCubit>()
                      .fetchLatestPaymentTransactions();
                },
              ),
            );
          },
        );
      },
    );
  }

  Widget _buildOptionalFeesContainer() {
    return Column(
      children: [
        Column(
          children: widget.childFeeDetails.optionalFees?.map((optionalFee) {
                final isFeeSelectedToPay =
                    _toPayOptionalFeeIds.contains(optionalFee.id ?? 0);

                return Container(
                  margin: EdgeInsets.only(bottom: 15),
                  decoration: BoxDecoration(
                      border: Border(
                          bottom: BorderSide(
                              color: Theme.of(context)
                                  .colorScheme
                                  .primary
                                  .withValues(alpha: 0.25)))),
                  padding: EdgeInsets.only(
                    bottom: 10,
                  ),
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      ///
                      (context
                              .read<SchoolConfigurationCubit>()
                              .getSchoolConfiguration()
                              .isOnlineFeePaymentEnable())
                          ? (optionalFee.isPaid ?? false)
                              ? Icon(Icons.verified,
                                  color:
                                      Theme.of(context).colorScheme.onPrimary)
                              : GestureDetector(
                                  onTap: () {
                                    onTapSelectOptionalFee(
                                        optionalFeeId: optionalFee.id ?? 0);
                                  },
                                  child: Container(
                                    width: 20,
                                    height: 20,
                                    decoration: BoxDecoration(
                                        border: Border.all(
                                            color: Theme.of(context)
                                                .colorScheme
                                                .primary)),
                                    alignment: Alignment.center,
                                    child: isFeeSelectedToPay
                                        ? Icon(
                                            Icons.check,
                                            size: 15.0,
                                            color: Theme.of(context)
                                                .colorScheme
                                                .primary,
                                          )
                                        : const SizedBox(),
                                  ),
                                )
                          : const SizedBox(),
                      SizedBox(
                        width: (context
                                .read<SchoolConfigurationCubit>()
                                .getSchoolConfiguration()
                                .isOnlineFeePaymentEnable())
                            ? 10
                            : 0,
                      ),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(optionalFee.feesType?.name ?? ""),
                            (optionalFee.isPaid ?? false)
                                ? Row(
                                    children: [
                                      Text(
                                        Utils.getTranslatedLabel(paidOnKey),
                                        style: getPaidOnTextStyle(),
                                      ),
                                      const SizedBox(
                                        width: 5.0,
                                      ),
                                      Text(
                                        Utils.formatDate(DateTime.parse(widget
                                            .childFeeDetails
                                            .optionalPaidDate(
                                                optionalFeeId:
                                                    optionalFee.id ?? 0))),
                                        style: TextStyle(
                                            fontSize: 12.0,
                                            color: Theme.of(context)
                                                .colorScheme
                                                .secondary
                                                .withValues(alpha: 0.75)),
                                      ),
                                    ],
                                  )
                                : const SizedBox(),
                          ],
                        ),
                      ),
                      const SizedBox(
                        width: 7.5,
                      ),
                      Text(
                        "${getCurrencySymbol()}${(optionalFee.amount ?? 0).toStringAsFixed(2)}",
                        style: TextStyle(
                            color: Theme.of(context).colorScheme.primary),
                      ),
                    ],
                  ),
                );
              }).toList() ??
              [],
        ),
        const SizedBox(
          height: 15.0,
        ),
      ],
    );
  }

  ///[To build the compulsory fee related ui]
  Widget _buildCompulsoryFeesContainer() {
    return Column(
      children: [
        ///[If user has already made any transaction using installment then hide the due date for full compulsory payment]
        widget.childFeeDetails
                    .didUserPaidPreviousCompulsoryFeeInInstallment() ||
                _enablePayInInstallments ||
                widget.childFeeDetails.isCompulsoryFeeFullyPaid()
            ? const SizedBox()
            : Column(
                children: [
                  Row(
                    children: [
                      Text("${Utils.getTranslatedLabel(dueDateKey)} "),
                      const Spacer(),
                      Text(
                        widget.childFeeDetails.dueDate ?? '-',
                        style: TextStyle(
                            color: Theme.of(context).colorScheme.primary),
                      )
                    ],
                  ),
                  const Divider(),
                  const SizedBox(
                    height: 5.0,
                  ),
                ],
              ),

        Column(
          children: widget.childFeeDetails.compulsoryFees
                  ?.map((compulsoryFee) => Container(
                        margin: EdgeInsets.only(bottom: 15),
                        decoration: BoxDecoration(
                            border: Border(
                                bottom: BorderSide(
                                    color: Theme.of(context)
                                        .colorScheme
                                        .primary
                                        .withValues(alpha: 0.25)))),
                        padding: EdgeInsets.only(
                          bottom: 10,
                        ),
                        child: Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Expanded(
                              child: Text(compulsoryFee.feesType?.name ?? ""),
                            ),
                            const SizedBox(
                              width: 7.5,
                            ),
                            Text(
                              "${getCurrencySymbol()}${(compulsoryFee.amount ?? 0).toStringAsFixed(2)}",
                              style: TextStyle(
                                  color: Theme.of(context).colorScheme.primary),
                            ),
                          ],
                        ),
                      ))
                  .toList() ??
              [],
        ),

        //
        (widget.childFeeDetails
                    .didUserPaidPreviousCompulsoryFeeInInstallment() ||
                _enablePayInInstallments ||
                widget.childFeeDetails.isCompulsoryFeeFullyPaid())
            ? const SizedBox()
            : widget.childFeeDetails.isFeeOverDue()
                ? Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(Utils.getTranslatedLabel(dueKey)),
                      Text(" (${widget.childFeeDetails.dueCharges}%)"),
                      const Spacer(),
                      Text(
                        "${getCurrencySymbol()}${widget.childFeeDetails.dueChargesAmount}",
                        style: TextStyle(
                            color: Theme.of(context).colorScheme.primary),
                      ),
                    ],
                  )
                : const SizedBox(),

        const SizedBox(
          height: 2.5,
        ),
        Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(Utils.getTranslatedLabel(totalFeeKey)),
            const Spacer(),
            Text(
              "${getCurrencySymbol()}${widget.childFeeDetails.totalCompulsoryFees?.toStringAsFixed(2)}",
              style: TextStyle(color: Theme.of(context).colorScheme.primary),
            ),
          ],
        ),

        widget.childFeeDetails.hasUserPaidFullFeeWithoutInstallment()
            ? Column(
                children: [
                  const Divider(),
                  Row(
                    children: [
                      Text(
                        Utils.getTranslatedLabel(paidOnKey),
                      ),
                      const Spacer(),
                      Text(
                        Utils.formatDate(DateTime.parse(widget.childFeeDetails
                            .fullCompulsoryFeePaidDate())),
                        style: TextStyle(
                            color: Theme.of(context).colorScheme.primary),
                      )
                    ],
                  ),
                ],
              )
            : const SizedBox(),

        //
        showPayInInstallmentsContainer()
            ? Column(
                children: [
                  const Divider(),
                  const SizedBox(
                    height: 12.5,
                  ),
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(Utils.getTranslatedLabel(payInInstallmentsKey)),
                      const Spacer(),
                      SizedBox(
                        height: 20,
                        child: Transform.scale(
                          scale: 0.75,
                          child: Switch(
                              value: _enablePayInInstallments,
                              onChanged: (value) {
                                _enablePayInInstallments = value;
                                setState(() {});
                              }),
                        ),
                      )
                    ],
                  ),
                ],
              )
            : const SizedBox(),

        ///[Installments ui]
        _enablePayInInstallments ||
                (widget.childFeeDetails
                    .didUserPaidPreviousCompulsoryFeeInInstallment())
            ? Column(
                children: [
                  const Divider(),
                  Installments(childFeeDetails: widget.childFeeDetails),
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        Utils.getTranslatedLabel(remainingAmountKey),
                        style: TextStyle(
                          color: Theme.of(context)
                              .colorScheme
                              .secondary
                              .withValues(alpha: 0.85),
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      const Spacer(),
                      Text(
                        "${getCurrencySymbol()}${widget.childFeeDetails.remainingInstallmentAmount().toStringAsFixed(2)}",
                        style: TextStyle(
                            fontWeight: FontWeight.w600,
                            color: Theme.of(context).colorScheme.primary),
                      ),
                    ],
                  ),
                ],
              )
            : const SizedBox(),
        const SizedBox(
          height: 50,
        ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          Align(
            alignment: Alignment.topCenter,
            child: SingleChildScrollView(
              padding: EdgeInsets.only(
                  bottom: MediaQuery.of(context).size.height * (0.3),
                  left: Utils.screenContentHorizontalPadding,
                  right: Utils.screenContentHorizontalPadding,
                  top: Utils.getScrollViewTopPadding(
                      context: context,
                      appBarHeightPercentage:
                          Utils.appBarBiggerHeightPercentage)),
              child: Column(
                children: [
                  FeeInformationContainer(
                      child: widget.child,
                      childFeeDetails: widget.childFeeDetails),
                  Padding(
                    padding: const EdgeInsets.symmetric(vertical: 15.0),
                    child: const Divider(),
                  ),
                  _currentlySelectedTabKey == compulsoryTitleKey
                      ? _buildCompulsoryFeesContainer()
                      : _buildOptionalFeesContainer()
                ],
              ),
            ),
          ),
          Align(
            alignment: Alignment.topCenter,
            child: _buildAppBar(),
          ),
          Align(
            alignment: Alignment.bottomCenter,
            child: context
                    .read<SchoolConfigurationCubit>()
                    .getSchoolConfiguration()
                    .isOnlineFeePaymentEnable()
                ? (_currentlySelectedTabKey == compulsoryTitleKey)
                    ? _buildCompulsoryBottomPaymentInfoContainer()
                    : _buildOptionalBottmsheetPaymentInfoContainer()
                : const SizedBox(),
          ),
        ],
      ),
    );
  }
}
