import 'package:yocut/cubits/assignmentsCubit.dart';
import 'package:yocut/cubits/authCubit.dart';
import 'package:yocut/cubits/studentSubjectAndSlidersCubit.dart';
import 'package:yocut/data/models/subject.dart';
import 'package:yocut/ui/screens/home/cubits/assignmentsTabSelectionCubit.dart';
import 'package:yocut/ui/widgets/assignmentFilterBottomsheetContainer.dart';
import 'package:yocut/ui/widgets/assignmentListContainer.dart';
import 'package:yocut/ui/widgets/assignmentsSubjectsContainer.dart';
import 'package:yocut/ui/widgets/customRefreshIndicator.dart';
import 'package:yocut/ui/widgets/customTabBarContainer.dart';
import 'package:yocut/ui/widgets/svgButton.dart';
import 'package:yocut/ui/widgets/screenTopBackgroundContainer.dart';
import 'package:yocut/ui/widgets/tabBarBackgroundContainer.dart';
import 'package:yocut/utils/labelKeys.dart';
import 'package:yocut/utils/utils.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

enum AssignmentFilters {
  assignedDateLatest,
  assignedDateOldest,
  dueDateLatest,
  dueDateOldest
}

class AssignmentsContainer extends StatefulWidget {
  //Need this flag in order to show the assignments container
  //in background when bottm menu is open

  //If it is just for background showing purpose then it will not reactive or not making any api call
  final bool isForBottomMenuBackground;
  const AssignmentsContainer({
    super.key,
    required this.isForBottomMenuBackground,
  });

  @override
  State<AssignmentsContainer> createState() => _AssignmentsContainerState();
}

class _AssignmentsContainerState extends State<AssignmentsContainer> {
  late AssignmentFilters selectedAssignmentFilter =
      AssignmentFilters.assignedDateLatest;

  late final ScrollController _scrollController = ScrollController()
    ..addListener(_assignmentsScrollListener);

  void _assignmentsScrollListener() {
    if (_scrollController.offset ==
        _scrollController.position.maxScrollExtent) {
      if (context.read<AssignmentsCubit>().hasMore()) {
        context.read<AssignmentsCubit>().fetchMoreAssignments(
              childId: 0,
              isSubmitted: context
                  .read<AssignmentsTabSelectionCubit>()
                  .isAssignmentSubmitted(),
              useParentApi: context.read<AuthCubit>().isParent(),
            );
        //to scroll to last in order for users to see the progress
        Future.delayed(const Duration(milliseconds: 10), () {
          _scrollController.animateTo(
            _scrollController.position.maxScrollExtent,
            duration: const Duration(milliseconds: 500),
            curve: Curves.easeIn,
          );
        });
      }
    }
  }

  @override
  void initState() {
    Future.delayed(Duration.zero, () {
      if (!widget.isForBottomMenuBackground) {
        fetchAssignments();
      }
    });
    fetchAssignments();
    super.initState();
  }

  @override
  void dispose() {
    _scrollController.removeListener(_assignmentsScrollListener);
    _scrollController.dispose();
    super.dispose();
  }

  void fetchAssignments() {
    context.read<AssignmentsCubit>().fetchAssignments(
          childId: 0,
          isSubmitted: context
              .read<AssignmentsTabSelectionCubit>()
              .isAssignmentSubmitted(),
          classSubjectId: context
              .read<AssignmentsTabSelectionCubit>()
              .state
              .assignmentFilterByClassSubjectId,
          useParentApi: context.read<AuthCubit>().isParent(),
        );
  }

  void changeAssignmentFilter(AssignmentFilters assignmentFilter) {
    setState(() {
      selectedAssignmentFilter = assignmentFilter;
    });
  }

  void onTapFilterButton() {
    showModalBottomSheet(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(Utils.bottomSheetTopRadius),
          topRight: Radius.circular(Utils.bottomSheetTopRadius),
        ),
      ),
      context: context,
      builder: (_) => AssignmentFilterBottomsheetContainer(
        changeAssignmentFilter: changeAssignmentFilter,
        initialAssignmentFilterValue: selectedAssignmentFilter,
      ),
    );
  }

  Widget _buildMySubjectsListContainer() {
    return BlocBuilder<StudentSubjectsAndSlidersCubit,
        StudentSubjectsAndSlidersState>(
      builder: (context, state) {
        //
        List<Subject> subjects = context
            .read<StudentSubjectsAndSlidersCubit>()
            .getSubjectsForAssignmentContainer();

        return BlocBuilder<AssignmentsTabSelectionCubit,
            AssignmentsTabSelectionState>(
          bloc: context.read<AssignmentsTabSelectionCubit>(),
          builder: (context, state) {
            return AssignmentsSubjectContainer(
              cubitAndState: "assignment",
              subjects: subjects,
              onTapSubject: (int classSubjectId) {
                context
                    .read<AssignmentsTabSelectionCubit>()
                    .changeAssignmentFilterBySubjectId(classSubjectId);
                fetchAssignments();
              },
              selectedClassSubjectId: state.assignmentFilterByClassSubjectId,
            );
          },
        );
      },
    );
  }

  Widget _buildAppBarContainer() {
    return ScreenTopBackgroundContainer(
      child: LayoutBuilder(
        builder: (context, boxConstraints) {
          return Stack(
            children: [
              BlocBuilder<AssignmentsTabSelectionCubit,
                  AssignmentsTabSelectionState>(
                builder: (context, state) {
                  return state.assignmentFilterTabTitle == submittedKey
                      ? const SizedBox()
                      : Align(
                          alignment: AlignmentDirectional.topEnd,
                          child: Padding(
                            padding: EdgeInsetsDirectional.only(
                              end: Utils.screenContentHorizontalPadding,
                            ),
                            child: SvgButton(
                              onTap: () {
                                onTapFilterButton();
                              },
                              svgIconUrl: Utils.getImagePath("filter_icon.svg"),
                            ),
                          ),
                        );
                },
              ),
              Align(
                alignment: Alignment.topCenter,
                child: Container(
                  alignment: Alignment.topCenter,
                  width: boxConstraints.maxWidth * (0.5),
                  child: Text(
                    Utils.getTranslatedLabel(assignmentsKey),
                    style: TextStyle(
                      color: Theme.of(context).scaffoldBackgroundColor,
                      fontSize: Utils.screenTitleFontSize,
                    ),
                  ),
                ),
              ),
              BlocBuilder<AssignmentsTabSelectionCubit,
                  AssignmentsTabSelectionState>(
                bloc: context.read<AssignmentsTabSelectionCubit>(),
                builder: (context, state) {
                  return AnimatedAlign(
                    curve: Utils.tabBackgroundContainerAnimationCurve,
                    duration: Utils.tabBackgroundContainerAnimationDuration,
                    alignment: state.assignmentFilterTabTitle == assignedKey
                        ? AlignmentDirectional.centerStart
                        : AlignmentDirectional.centerEnd,
                    child: TabBarBackgroundContainer(
                      boxConstraints: boxConstraints,
                    ),
                  );
                },
              ),
              BlocBuilder<AssignmentsTabSelectionCubit,
                  AssignmentsTabSelectionState>(
                bloc: context.read<AssignmentsTabSelectionCubit>(),
                builder: (context, state) {
                  return CustomTabBarContainer(
                    boxConstraints: boxConstraints,
                    alignment: AlignmentDirectional.centerStart,
                    isSelected: state.assignmentFilterTabTitle == assignedKey,
                    onTap: () {
                      context
                          .read<AssignmentsTabSelectionCubit>()
                          .changeAssignmentFilterTabTitle(assignedKey);
                      fetchAssignments();
                    },
                    titleKey: assignedKey,
                  );
                },
              ),
              BlocBuilder<AssignmentsTabSelectionCubit,
                  AssignmentsTabSelectionState>(
                bloc: context.read<AssignmentsTabSelectionCubit>(),
                builder: (context, state) {
                  return CustomTabBarContainer(
                    boxConstraints: boxConstraints,
                    alignment: AlignmentDirectional.centerEnd,
                    isSelected: state.assignmentFilterTabTitle == submittedKey,
                    onTap: () {
                      context
                          .read<AssignmentsTabSelectionCubit>()
                          .changeAssignmentFilterTabTitle(submittedKey);
                      fetchAssignments();
                    },
                    titleKey: submittedKey,
                  );
                },
              ),
            ],
          );
        },
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        CustomRefreshIndicator(
          displacment: Utils.getScrollViewTopPadding(
            context: context,
            appBarHeightPercentage: Utils.appBarBiggerHeightPercentage,
          ),
          onRefreshCallback: () {
            fetchAssignments();
          },
          child: SizedBox(
            height: double.maxFinite,
            child: SingleChildScrollView(
              controller: _scrollController,
              physics: const AlwaysScrollableScrollPhysics(),
              padding: EdgeInsets.only(
                top: Utils.getScrollViewTopPadding(
                  context: context,
                  appBarHeightPercentage: Utils.appBarBiggerHeightPercentage,
                ),
                bottom: Utils.getScrollViewBottomPadding(context),
              ),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  _buildMySubjectsListContainer(),
                  SizedBox(
                    height: MediaQuery.of(context).size.height * (0.035),
                  ),
                  BlocBuilder<AssignmentsTabSelectionCubit,
                      AssignmentsTabSelectionState>(
                    builder: (context, state) {
                      return AssignmentListContainer(
                        animateItems: !widget
                            .isForBottomMenuBackground, //if it's just for background don't animate items
                        assignmentTabTitle: state.assignmentFilterTabTitle,
                        currentSelectedSubjectId:
                            state.assignmentFilterByClassSubjectId,
                        selectedAssignmentFilter: selectedAssignmentFilter,
                        isAssignmentSubmitted: context
                            .read<AssignmentsTabSelectionCubit>()
                            .isAssignmentSubmitted(),
                      );
                    },
                  ),
                ],
              ),
            ),
          ),
        ),
        Align(
          alignment: Alignment.topCenter,
          child: _buildAppBarContainer(),
        )
      ],
    );
  }
}
