import 'package:yocut/cubits/assignmentsCubit.dart';
import 'package:yocut/cubits/authCubit.dart';
import 'package:yocut/data/models/subject.dart';
import 'package:yocut/data/repositories/assignmentRepository.dart';
import 'package:yocut/ui/widgets/assignmentFilterBottomsheetContainer.dart';
import 'package:yocut/ui/widgets/assignmentsContainer.dart';
import 'package:yocut/ui/widgets/assignmentListContainer.dart';
import 'package:yocut/ui/widgets/assignmentsSubjectsContainer.dart';
import 'package:yocut/ui/widgets/customBackButton.dart';
import 'package:yocut/ui/widgets/customRefreshIndicator.dart';
import 'package:yocut/ui/widgets/customTabBarContainer.dart';
import 'package:yocut/ui/widgets/screenTopBackgroundContainer.dart';
import 'package:yocut/ui/widgets/svgButton.dart';
import 'package:yocut/ui/widgets/tabBarBackgroundContainer.dart';
import 'package:yocut/utils/labelKeys.dart';
import 'package:yocut/utils/utils.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get/get.dart';

class ChildAssignmentsScreen extends StatefulWidget {
  final int childId;
  final List<Subject> subjects;
  const ChildAssignmentsScreen({
    Key? key,
    required this.childId,
    required this.subjects,
  }) : super(key: key);

  @override
  State<ChildAssignmentsScreen> createState() => _ChildAssignmentsScreenState();

  static Widget routeInstance() {
    final arguments = Get.arguments as Map<String, dynamic>;
    return BlocProvider<AssignmentsCubit>(
        create: (context) => AssignmentsCubit(AssignmentRepository()),
        child: ChildAssignmentsScreen(
          childId: arguments['childId'],
          subjects: arguments['subjects'],
        ));
  }
}

class _ChildAssignmentsScreenState extends State<ChildAssignmentsScreen> {
  String _assignmentStatusTabTitle = assignedKey;

  int _currentlySelectedClassSubjectId = 0;

  late AssignmentFilters selectedAssignmentFilter =
      AssignmentFilters.assignedDateLatest;

  late final ScrollController _scrollController = ScrollController()
    ..addListener(_assignmentsScrollListener);

  int isAssignmentSubmitted() {
    return _assignmentStatusTabTitle == assignedKey ? 0 : 1;
  }

  void _assignmentsScrollListener() {
    if (_scrollController.offset ==
        _scrollController.position.maxScrollExtent) {
      if (context.read<AssignmentsCubit>().hasMore()) {
        context.read<AssignmentsCubit>().fetchMoreAssignments(
              childId: widget.childId,
              isSubmitted: isAssignmentSubmitted(),
              useParentApi: context.read<AuthCubit>().isParent(),
            );
      }
    }
  }

  @override
  void initState() {
    Future.delayed(Duration.zero, () {
      fetchAssignments();
    });
    super.initState();
  }

  void fetchAssignments() {
    context.read<AssignmentsCubit>().fetchAssignments(
          useParentApi: context.read<AuthCubit>().isParent(),
          childId: widget.childId,
          isSubmitted: isAssignmentSubmitted(),
          classSubjectId: _currentlySelectedClassSubjectId,
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

  @override
  void dispose() {
    _scrollController.removeListener(_assignmentsScrollListener);
    _scrollController.dispose();
    super.dispose();
  }

  Widget _buildAppBarContainer() {
    return ScreenTopBackgroundContainer(
      child: LayoutBuilder(
        builder: (context, boxConstraints) {
          return Stack(
            children: [
              const CustomBackButton(),
              _assignmentStatusTabTitle == submittedKey
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
                    ),
              Align(
                alignment: Alignment.topCenter,
                child: Container(
                  alignment: Alignment.topCenter,
                  width: boxConstraints.maxWidth * (0.5),
                  child: Text(
                    Utils.getTranslatedLabel(assignmentsKey),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
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
                alignment: _assignmentStatusTabTitle == assignedKey
                    ? AlignmentDirectional.centerStart
                    : AlignmentDirectional.centerEnd,
                child:
                    TabBarBackgroundContainer(boxConstraints: boxConstraints),
              ),
              CustomTabBarContainer(
                boxConstraints: boxConstraints,
                alignment: AlignmentDirectional.centerStart,
                isSelected: _assignmentStatusTabTitle == assignedKey,
                onTap: () {
                  setState(() {
                    _assignmentStatusTabTitle = assignedKey;
                  });
                  fetchAssignments();
                },
                titleKey: assignedKey,
              ),
              CustomTabBarContainer(
                boxConstraints: boxConstraints,
                alignment: AlignmentDirectional.centerEnd,
                isSelected: _assignmentStatusTabTitle == submittedKey,
                onTap: () {
                  //
                  setState(() {
                    _assignmentStatusTabTitle = submittedKey;
                  });
                  fetchAssignments();
                },
                titleKey: submittedKey,
              )
            ],
          );
        },
      ),
    );
  }

  Widget _buildAssignments() {
    return CustomRefreshIndicator(
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
          ),
          child: Column(
            children: [
              //
              AssignmentsSubjectContainer(
                cubitAndState: "assignment",
                subjects: widget.subjects,
                onTapSubject: (int classSubjectId) {
                  setState(() {
                    _currentlySelectedClassSubjectId = classSubjectId;
                  });

                  fetchAssignments();
                },
                selectedClassSubjectId: _currentlySelectedClassSubjectId,
              ),
              SizedBox(
                height: MediaQuery.of(context).size.height * (0.035),
              ),
              AssignmentListContainer(
                assignmentTabTitle: _assignmentStatusTabTitle,
                currentSelectedSubjectId: _currentlySelectedClassSubjectId,
                selectedAssignmentFilter: selectedAssignmentFilter,
                isAssignmentSubmitted: isAssignmentSubmitted(),
              )
            ],
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          _buildAssignments(),
          _buildAppBarContainer(),
        ],
      ),
    );
  }
}
