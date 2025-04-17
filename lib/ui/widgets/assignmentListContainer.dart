import 'package:yocut/app/routes.dart';
import 'package:yocut/cubits/assignmentsCubit.dart';
import 'package:yocut/cubits/authCubit.dart';
import 'package:yocut/data/models/assignment.dart';
import 'package:yocut/ui/widgets/assignmentsContainer.dart';
import 'package:yocut/ui/widgets/customShimmerContainer.dart';
import 'package:yocut/ui/widgets/errorContaineer.dart';
import 'package:yocut/ui/widgets/noDataContainer.dart';
import 'package:yocut/ui/widgets/shimmerLoadingContainer.dart';
import 'package:yocut/ui/widgets/subjectImageContainer.dart';
import 'package:yocut/utils/animationConfiguration.dart';
import 'package:yocut/utils/labelKeys.dart';
import 'package:yocut/utils/utils.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get/get.dart';

class AssignmentListContainer extends StatelessWidget {
  final String assignmentTabTitle;
  final int? childId;
  final int currentSelectedSubjectId;
  final AssignmentFilters selectedAssignmentFilter;
  final int isAssignmentSubmitted;
  final bool animateItems;
  const AssignmentListContainer({
    super.key,
    required this.assignmentTabTitle,
    required this.currentSelectedSubjectId,
    this.childId,
    required this.selectedAssignmentFilter,
    required this.isAssignmentSubmitted,
    this.animateItems = true,
  });

  Widget _buildShimmerLoadingAssignmentContainer(BuildContext context) {
    return Container(
      width: MediaQuery.of(context).size.width,
      margin: EdgeInsets.only(
        bottom: 20,
        left: MediaQuery.of(context).size.width * (0.075),
        right: MediaQuery.of(context).size.width * (0.075),
      ),
      height: 90,
      child: LayoutBuilder(
        builder: (context, boxConstraints) {
          return ShimmerLoadingContainer(
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                CustomShimmerContainer(
                  borderRadius: 10,
                  height: boxConstraints.maxHeight,
                  width: boxConstraints.maxWidth * (0.26),
                ),
                SizedBox(
                  width: boxConstraints.maxWidth * (0.05),
                ),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    SizedBox(
                      height: boxConstraints.maxHeight * (0.075),
                    ),
                    CustomShimmerContainer(
                      borderRadius: 10,
                      width: boxConstraints.maxWidth * (0.6),
                    ),
                    SizedBox(
                      height: boxConstraints.maxHeight * (0.075),
                    ),
                    CustomShimmerContainer(
                      height: 8,
                      borderRadius: 10,
                      width: boxConstraints.maxWidth * (0.45),
                    ),
                    const Spacer(),
                    CustomShimmerContainer(
                      height: 8,
                      borderRadius: 10,
                      width: boxConstraints.maxWidth * (0.3),
                    ),
                    SizedBox(
                      height: boxConstraints.maxHeight * (0.075),
                    ),
                  ],
                ),
              ],
            ),
          );
        },
      ),
    );
  }

  List<Assignment> _getAssignmentsByAssignmentFilters(
    List<Assignment> assignments,
  ) {
    List<Assignment> sortedAssignments = assignments;
    if (selectedAssignmentFilter == AssignmentFilters.dueDateLatest) {
      sortedAssignments
          .sort((first, second) => second.dueDate.compareTo(first.dueDate));
    } else if (selectedAssignmentFilter == AssignmentFilters.dueDateOldest) {
      sortedAssignments
          .sort((first, second) => first.dueDate.compareTo(second.dueDate));
    } else if (selectedAssignmentFilter ==
        AssignmentFilters.assignedDateLatest) {
      sortedAssignments
          .sort((first, second) => second.createdAt.compareTo(first.createdAt));
    } else if (selectedAssignmentFilter ==
        AssignmentFilters.assignedDateOldest) {
      sortedAssignments
          .sort((first, second) => first.createdAt.compareTo(second.createdAt));
    }

    return sortedAssignments;
  }

  Widget _buildAssignmentContainer({
    required Assignment assignment,
    required BuildContext context,
    required int index,
    required int totalAssignments,
    required bool hasMoreAssignments,
    required bool hasMoreAssignmentsInProgress,
    required bool fetchMoreAssignmentsFailure,
  }) {
    final bool assginmentSubmitted = assignment.assignmentSubmission.id != 0;

    return Column(
      children: [
        Animate(
          effects:
              animateItems ? listItemAppearanceEffects(itemIndex: index) : null,
          child: GestureDetector(
            onTap: () {
              Get.toNamed(Routes.assignment, arguments: assignment);
            },
            child: Container(
              margin: EdgeInsetsDirectional.only(
                bottom: 20.0,
                start: MediaQuery.of(context).size.width * (0.15),
                end: MediaQuery.of(context).size.width * (0.075),
              ),
              decoration: BoxDecoration(
                color: Theme.of(context).colorScheme.surface,
                borderRadius: BorderRadius.circular(15),
              ),
              width: MediaQuery.of(context).size.width,
              height: 100,
              child: LayoutBuilder(
                builder: (context, boxConstraints) {
                  final assignmentSubmittedStatusKey =
                      Utils.getAssignmentSubmissionStatusKey(
                    assignment.assignmentSubmission.status,
                  );
                  return Stack(
                    clipBehavior: Clip.none,
                    children: [
                      PositionedDirectional(
                        top: boxConstraints.maxHeight * (0.5) -
                            boxConstraints.maxWidth * (0.118),
                        start: boxConstraints.maxWidth * (-0.125),
                        child: SubjectImageContainer(
                          showShadow: true,
                          animate: animateItems,
                          height: boxConstraints.maxWidth * (0.235),
                          radius: 10,
                          subject: assignment.subject,
                          width: boxConstraints.maxWidth * (0.26),
                        ),
                      ),
                      Align(
                        alignment: AlignmentDirectional.topStart,
                        child: Padding(
                          padding: EdgeInsetsDirectional.only(
                            start: boxConstraints.maxWidth * (0.175),
                            top: boxConstraints.maxHeight * (0.125),
                            bottom: boxConstraints.maxHeight * (0.075),
                          ),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Row(
                                children: [
                                  SizedBox(
                                    width: boxConstraints.maxWidth * 0.52,
                                    child: Text(
                                      assignment.name,
                                      maxLines: 1,
                                      overflow: TextOverflow.ellipsis,
                                      style: TextStyle(
                                        color: Theme.of(context)
                                            .colorScheme
                                            .secondary,
                                        fontWeight: FontWeight.w600,
                                        fontSize: 14.0,
                                      ),
                                      textAlign: TextAlign.start,
                                    ),
                                  ),
                                  !assginmentSubmitted
                                      ? Container(
                                          alignment:
                                              AlignmentDirectional.centerEnd,
                                          width:
                                              boxConstraints.maxWidth * (0.25),
                                          child: Text(
                                            "${assignment.createdAt.day.toString().padLeft(2, '0')}-${assignment.createdAt.month.toString().padLeft(2, '0')}-${assignment.createdAt.year}",
                                            maxLines: 1,
                                            overflow: TextOverflow.ellipsis,
                                            style: TextStyle(
                                              color: Theme.of(context)
                                                  .colorScheme
                                                  .onSurface,
                                              fontWeight: FontWeight.w400,
                                              fontSize: 10.5,
                                            ),
                                          ),
                                        )
                                      : assignmentSubmittedStatusKey.isEmpty
                                          ? const SizedBox()
                                          : Container(
                                              alignment: Alignment.center,
                                              width: boxConstraints.maxWidth *
                                                  (0.27),
                                              decoration: BoxDecoration(
                                                color: assignmentSubmittedStatusKey ==
                                                        acceptedKey
                                                    ? Theme.of(context)
                                                        .colorScheme
                                                        .onPrimary
                                                    : assignmentSubmittedStatusKey ==
                                                                inReviewKey ||
                                                            assignmentSubmittedStatusKey ==
                                                                resubmittedKey
                                                        ? Theme.of(context)
                                                            .colorScheme
                                                            .primary
                                                        : Theme.of(context)
                                                            .colorScheme
                                                            .error,
                                                borderRadius:
                                                    BorderRadius.circular(2.5),
                                              ),
                                              padding:
                                                  const EdgeInsets.symmetric(
                                                vertical: 2,
                                              ),
                                              child: Text(
                                                Utils.getTranslatedLabel(
                                                  assignmentSubmittedStatusKey,
                                                ), //
                                                maxLines: 1,
                                                overflow: TextOverflow.ellipsis,
                                                style: TextStyle(
                                                  fontSize: 10.75,
                                                  color: Theme.of(context)
                                                      .scaffoldBackgroundColor,
                                                ),
                                              ),
                                            ),
                                ],
                              ),
                              SizedBox(
                                height: boxConstraints.maxHeight *
                                    (assignment.instructions.isEmpty
                                        ? 0
                                        : 0.05),
                              ),
                              assignment.instructions.isEmpty
                                  ? const SizedBox()
                                  : Text(
                                      assignment.instructions,
                                      //if assignment subject is selected then maxLines should be 2 else it is 1,
                                      maxLines:
                                          currentSelectedSubjectId != 0 ? 2 : 1,
                                      overflow: TextOverflow.ellipsis,
                                      style: TextStyle(
                                        height: 1.0,
                                        color: Theme.of(context)
                                            .colorScheme
                                            .secondary,
                                        fontWeight: FontWeight.w400,
                                        fontSize: 12.0,
                                      ),
                                    ),
                              SizedBox(
                                height: boxConstraints.maxHeight * (0.075),
                              ),
                              currentSelectedSubjectId != 0
                                  ? const SizedBox()
                                  : Text(
                                      assignment.subject
                                          .getSubjectName(context: context),
                                      maxLines: 1,
                                      overflow: TextOverflow.ellipsis,
                                      style: TextStyle(
                                        height: 1.0,
                                        color: Theme.of(context)
                                            .colorScheme
                                            .secondary,
                                        fontWeight: FontWeight.w400,
                                        fontSize: 11.0,
                                      ),
                                    ),
                              const Spacer(),
                              Text(
                                Utils.formatAssignmentDueDate(
                                  assignment.dueDate,
                                  context,
                                ),
                                style: TextStyle(
                                  color:
                                      Theme.of(context).colorScheme.onSurface,
                                  fontWeight: FontWeight.w400,
                                  fontSize: 10.5,
                                ),
                              )
                            ],
                          ),
                        ),
                      ),
                    ],
                  );
                },
              ),
            ),
          ),
        ),
        //show assignment loading container after last assinment container
        if (index == (totalAssignments - 1) &&
            hasMoreAssignments &&
            hasMoreAssignmentsInProgress)
          _buildShimmerLoadingAssignmentContainer(context),

        if (index == (totalAssignments - 1) &&
            hasMoreAssignments &&
            fetchMoreAssignmentsFailure)
          Center(
            child: CupertinoButton(
              child: Text(Utils.getTranslatedLabel(retryKey)),
              onPressed: () {
                context.read<AssignmentsCubit>().fetchMoreAssignments(
                      childId: childId ?? 0,
                      isSubmitted: isAssignmentSubmitted,
                      useParentApi: context.read<AuthCubit>().isParent(),
                    );
              },
            ),
          )
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<AssignmentsCubit, AssignmentsState>(
      builder: (context, state) {
        if (state is AssignmentsFetchSuccess) {
          //fetch assignments based on assignment selected assignment tab type
          List<Assignment> assignments = assignmentTabTitle == assignedKey
              ? context.read<AssignmentsCubit>().getAssignedAssignments()
              : context.read<AssignmentsCubit>().getSubmittedAssignments();

          //fetch assginemnt based on applied filters
          //filters applied only for assgined tab
          if (assignmentTabTitle == assignedKey) {
            assignments = _getAssignmentsByAssignmentFilters(assignments);
          }

          return assignments.isEmpty
              ? NoDataContainer(
                  titleKey: assignmentTabTitle == assignedKey
                      ? noAssignmentsToSubmitKey
                      : notSubmittedAnyAssignmentKey,
                  animate: animateItems,
                )
              : Column(
                  children: List.generate(assignments.length, (index) => index)
                      .map(
                        (index) => _buildAssignmentContainer(
                          context: context,
                          hasMoreAssignmentsInProgress:
                              state.fetchMoreAssignmentsInProgress,
                          assignment: assignments[index],
                          totalAssignments: assignments.length,
                          index: index,
                          hasMoreAssignments:
                              context.read<AssignmentsCubit>().hasMore(),
                          fetchMoreAssignmentsFailure:
                              state.moreAssignmentsFetchError,
                        ),
                      )
                      .toList(),
                );
        }
        if (state is AssignmentsFetchFailure) {
          return Center(
            child: ErrorContainer(
              onTapRetry: () {
                context.read<AssignmentsCubit>().fetchAssignments(
                      page: state.page,
                      classSubjectId: state.classSubjectId,
                      childId: childId ?? 0,
                      isSubmitted: isAssignmentSubmitted,
                      useParentApi: context.read<AuthCubit>().isParent(),
                    );
              },
              animate: animateItems,
              errorMessageCode: state.errorMessage,
            ),
          );
        }

        return Column(
          children: List.generate(
            Utils.defaultShimmerLoadingContentCount,
            (index) => _buildShimmerLoadingAssignmentContainer(context),
          ),
        );
      },
    );
  }
}
