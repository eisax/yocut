import 'package:yocut/app/routes.dart';
import 'package:yocut/cubits/childFeeDetailsCubit.dart';
import 'package:yocut/data/models/childFeeDetails.dart';
import 'package:yocut/data/models/student.dart';
import 'package:yocut/ui/widgets/customAppbar.dart';
import 'package:yocut/ui/widgets/customCircularProgressIndicator.dart';
import 'package:yocut/ui/widgets/customRefreshIndicator.dart';
import 'package:yocut/ui/widgets/errorContaineer.dart';
import 'package:yocut/ui/widgets/noDataContainer.dart';
import 'package:yocut/utils/labelKeys.dart';
import 'package:yocut/utils/utils.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get/get.dart';

class ChildFeesScreen extends StatefulWidget {
  final Student child;
  const ChildFeesScreen({super.key, required this.child});

  static Widget routeInstance() {
    return ChildFeesScreen(
      child: Get.arguments as Student,
    );
  }

  @override
  State<ChildFeesScreen> createState() => _ChildFeesScreenState();
}

class _ChildFeesScreenState extends State<ChildFeesScreen> {
  @override
  void initState() {
    super.initState();
    Future.delayed(Duration.zero, () {
      fetchChildFeeDetails();
    });
  }

  void fetchChildFeeDetails() {
    context
        .read<ChildFeeDetailsCubit>()
        .fetchChildFeeDetails(childId: widget.child.id ?? 0);
  }

  Widget _buildFeesContainer({required List<ChildFeeDetails> fees}) {
    return CustomRefreshIndicator(
      displacment: Utils.getScrollViewTopPadding(
          context: context,
          appBarHeightPercentage: Utils.appBarSmallerHeightPercentage),
      onRefreshCallback: () async {
        fetchChildFeeDetails();
      },
      child: ListView.builder(
          padding: EdgeInsets.only(
            bottom: 25,
            left: Utils.screenContentHorizontalPadding,
            right: Utils.screenContentHorizontalPadding,
            top: Utils.getScrollViewTopPadding(
              context: context,
              appBarHeightPercentage: Utils.appBarSmallerHeightPercentage,
            ),
          ),
          itemCount: fees.length,
          itemBuilder: (context, index) {
            final feeDetails = fees[index];
            final valueTextStyle = TextStyle(
                fontSize: 13.0,
                color:
                    Theme.of(context).colorScheme.secondary.withValues(alpha: 0.9));
            final feePaymentStatusKey = feeDetails.getFeePaymentStatus();
            final feePaymentStatusColor = feePaymentStatusKey == pendingKey
                ? Theme.of(context).colorScheme.error
                : (feePaymentStatusKey == paidKey)
                    ? Theme.of(context).colorScheme.onPrimary
                    : Theme.of(context).colorScheme.primary;
            return Padding(
              padding: EdgeInsets.only(bottom: 15),
              child: GestureDetector(
                onTap: () {
                  Get.toNamed(Routes.childFeeDetails, arguments: {
                    "childFeeDetails": feeDetails,
                    "child": widget.child
                  });
                },
                child: Container(
                  width: MediaQuery.of(context).size.width,
                  height: 100,
                  padding: EdgeInsets.symmetric(horizontal: 15, vertical: 12.5),
                  decoration: BoxDecoration(
                      color: Theme.of(context).colorScheme.surface,
                      borderRadius: BorderRadius.circular(10)),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        feeDetails.name ?? "",
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: TextStyle(
                            color: Theme.of(context).colorScheme.secondary),
                      ),
                      const Spacer(),
                      Row(
                        children: [
                          Text(
                            "${Utils.getTranslatedLabel(classKey)} : ${feeDetails.classDetails?.name ?? '-'}",
                            style: valueTextStyle,
                          ),
                          const Spacer(),
                          Text(
                            feeDetails.sessionYear?.name ?? "",
                            style: valueTextStyle,
                          ),
                        ],
                      ),
                      const SizedBox(height: 2.5),
                      Row(
                        children: [
                          Text(
                            "${Utils.getTranslatedLabel(statusKey)} : ",
                            style: valueTextStyle,
                          ),
                          Text(
                            Utils.getTranslatedLabel(feePaymentStatusKey),
                            style: valueTextStyle.copyWith(
                                color: feePaymentStatusColor),
                          ),
                          const Spacer(),
                          feePaymentStatusKey == paidKey
                              ? const SizedBox()
                              : feeDetails
                                      .didUserPaidPreviousCompulsoryFeeInInstallment()
                                  ? const SizedBox()
                                  : Text(
                                      "${Utils.getTranslatedLabel(dueDateKey)} : ${feeDetails.dueDate ?? ''}",
                                      style: valueTextStyle,
                                    ),
                        ],
                      )
                    ],
                  ),
                ),
              ),
            );
          }),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          BlocBuilder<ChildFeeDetailsCubit, ChildFeeDetailsState>(
              builder: (context, state) {
            if (state is ChildFeeDetailsFetchSuccess) {
              if (state.fees.isEmpty) {
                return Center(
                  child: NoDataContainer(titleKey: noFeesFoundKey),
                );
                
              }
              return _buildFeesContainer(fees: state.fees);
            }
            if (state is ChildFeeDetailsFetchFailure) {
              return Center(
                child: ErrorContainer(
                  errorMessageCode: state.errorMessage,
                  onTapRetry: () {
                    fetchChildFeeDetails();
                  },
                ),
              );
            }
            return Center(
              child: CustomCircularProgressIndicator(
                indicatorColor: Theme.of(context).colorScheme.primary,
              ),
            );
          }),
          Align(
            alignment: Alignment.topCenter,
            child: CustomAppBar(
              title: Utils.getTranslatedLabel(feesKey),
            ),
          ),
        ],
      ),
    );
  }
}
