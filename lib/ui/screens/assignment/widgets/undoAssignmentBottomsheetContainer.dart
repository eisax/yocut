import 'package:yocut/cubits/undoAssignmentSubmissionCubit.dart';
import 'package:yocut/ui/widgets/bottomsheetTopTitleAndCloseButton.dart';
import 'package:yocut/ui/widgets/customRoundedButton.dart';
import 'package:yocut/utils/labelKeys.dart';
import 'package:yocut/utils/utils.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get/route_manager.dart';

class UndoAssignmentBottomsheetContainer extends StatefulWidget {
  final int assignmentSubmissionId;
  const UndoAssignmentBottomsheetContainer({
    super.key,
    required this.assignmentSubmissionId,
  });

  @override
  State<UndoAssignmentBottomsheetContainer> createState() =>
      _UndoAssignmentBottomsheetContainerState();
}

class _UndoAssignmentBottomsheetContainerState
    extends State<UndoAssignmentBottomsheetContainer> {
  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(
        horizontal: MediaQuery.of(context).size.width * (0.075),
        vertical: MediaQuery.of(context).size.height * (0.04),
      ),
      decoration: BoxDecoration(
        color: Theme.of(context).scaffoldBackgroundColor,
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(Utils.bottomSheetTopRadius),
          topRight: Radius.circular(Utils.bottomSheetTopRadius),
        ),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          BottomsheetTopTitleAndCloseButton(
            onTapCloseButton: () {
              if (context.read<UndoAssignmentSubmissionCubit>().state
                  is UndoAssignmentSubmissionInProgress) {
                return;
              }
              Get.back();
            },
            titleKey: undoSubmissionKey,
          ),
          SizedBox(
            height: MediaQuery.of(context).size.height * (0.0125),
          ),
          Text(
            Utils.getTranslatedLabel(undoSubmissionWarningKey),
            textAlign: TextAlign.center,
            style: TextStyle(
              fontSize: 16.0,
              color: Theme.of(context).colorScheme.secondary,
            ),
          ),
          SizedBox(
            height: MediaQuery.of(context).size.height * (0.025),
          ),
          BlocConsumer<UndoAssignmentSubmissionCubit,
              UndoAssignmentSubmissionState>(
            listener: (context, state) {
              if (state is UndoAssignmentSubmissionFailure) {
                Get.back(
                    result: {"error": true, "message": state.errorMessage});
              } else if (state is UndoAssignmentSubmissionSuccess) {
                Get.back(result: {
                  "error": false,
                });
              }
            },
            builder: (context, state) {
              return PopScope(
                canPop: context.read<UndoAssignmentSubmissionCubit>().state
                    is! UndoAssignmentSubmissionInProgress,
                child: CustomRoundedButton(
                  onTap: () {
                    if (state is UndoAssignmentSubmissionInProgress) {
                      return;
                    }
                    context
                        .read<UndoAssignmentSubmissionCubit>()
                        .undoAssignmentSubmission(
                          assignmentSubmissionId: widget.assignmentSubmissionId,
                        );
                  },
                  height: 40,
                  textSize: 16.0,
                  widthPercentage: 0.45,
                  titleColor: Theme.of(context).scaffoldBackgroundColor,
                  backgroundColor: Theme.of(context).colorScheme.primary,
                  buttonTitle: Utils.getTranslatedLabel(
                    state is UndoAssignmentSubmissionInProgress
                        ? undoingKey
                        : undoKey,
                  ),
                  showBorder: false,
                ),
              );
            },
          )
        ],
      ),
    );
  }
}
