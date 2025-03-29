import 'package:yocut/cubits/assignmentReportCubit.dart';
import 'package:yocut/cubits/authCubit.dart';
import 'package:yocut/cubits/onlineExamReportCubit.dart';
import 'package:yocut/ui/widgets/customCircularProgressIndicator.dart';
import 'package:yocut/ui/widgets/noDataContainer.dart';
import 'package:yocut/utils/errorMessageKeysAndCodes.dart';
import 'package:yocut/utils/systemModules.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:yocut/cubits/reportTabSelectionCubit.dart';
import 'package:yocut/data/models/subject.dart';
import 'package:yocut/ui/widgets/customBackButton.dart';
import 'package:yocut/ui/widgets/customTabBarContainer.dart';
import 'package:yocut/ui/widgets/errorContaineer.dart';
import 'package:yocut/ui/widgets/screenTopBackgroundContainer.dart';
import 'package:yocut/ui/widgets/tabBarBackgroundContainer.dart';
import 'package:yocut/utils/labelKeys.dart';
import 'package:yocut/utils/utils.dart';
import 'package:get/get.dart';

class SubjectWiseDetailedReport extends StatefulWidget {
  final Subject subject;
  final int? childId;
  const SubjectWiseDetailedReport({
    Key? key,
    required this.subject,
    this.childId,
  }) : super(key: key);

  @override
  SubjectWiseDetailedReportState createState() =>
      SubjectWiseDetailedReportState();

  static Widget routeInstance() {
    final arguments = Get.arguments as Map<String, dynamic>;
    return SubjectWiseDetailedReport(
      subject: arguments['subject'],
      childId: arguments['childId'] ?? 0,
    );
  }
}

class SubjectWiseDetailedReportState extends State<SubjectWiseDetailedReport> {
  late final ScrollController _reportOnlineExamController = ScrollController()
    ..addListener(_reportOnlineExamScrollListener);
  late final ScrollController _reportAssignmentController = ScrollController()
    ..addListener(_reportAssignmentScrollListener);
  @override
  void initState() {
    fetchReportData();
    super.initState();
  }

  @override
  void dispose() {
    _reportOnlineExamController.removeListener(_reportOnlineExamScrollListener);
    _reportAssignmentController.removeListener(_reportAssignmentScrollListener);
    super.dispose();
  }

  void fetchReportData() {
    if (isAssignmentManagementModuleEnable() &&
        isExamManagementModuleEnable()) {
      //Both module enable
      if (context.read<ReportTabSelectionCubit>().isReportAssignment()) {
        getAssignmentReport();
      } else {
        getExamOnlineReport();
      }
    } else {
      //If one module is enable among the two
      if (isAssignmentManagementModuleEnable()) {
        getAssignmentReport();
      }
      if (isExamManagementModuleEnable()) {
        getExamOnlineReport();
      }
    }
  }

  bool isAssignmentManagementModuleEnable() => Utils.isModuleEnabled(
      context: context, moduleId: assignmentManagementModuleId.toString());

  bool isExamManagementModuleEnable() => Utils.isModuleEnabled(
      context: context, moduleId: examManagementModuleId.toString());

  void getAssignmentReport() {
    context.read<AssignmentReportCubit>().getAssignmentReport(
          classSubjectId: widget.subject.classSubjectId ?? 0,
          childId: widget.childId ?? 0,
          useParentApi: context.read<AuthCubit>().isParent(),
        );
  }

  void getExamOnlineReport() {
    context.read<OnlineExamReportCubit>().getExamOnlineReport(
          classSubjectId: widget.subject.classSubjectId ?? 0,
          childId: widget.childId ?? 0,
          useParentApi: context.read<AuthCubit>().isParent(),
        );
  }

  void _reportAssignmentScrollListener() {
    if (_reportAssignmentController.offset ==
        _reportAssignmentController.position.maxScrollExtent) {
      if (context.read<AssignmentReportCubit>().hasMore()) {
        context.read<AssignmentReportCubit>().getMoreAssignmentReport(
              childId: widget.childId ?? 0,
              useParentApi: context.read<AuthCubit>().isParent(),
            );
      }
    }
  }

  void _reportOnlineExamScrollListener() {
    if (_reportOnlineExamController.offset ==
        _reportOnlineExamController.position.maxScrollExtent) {
      if (context.read<OnlineExamReportCubit>().hasMore()) {
        context.read<OnlineExamReportCubit>().getMoreExamOnlineReport(
              childId: widget.childId ?? 0,
              useParentApi: context.read<AuthCubit>().isParent(),
            );
      }
    }
  }

  Widget buildReportAppBar(ReportTabSelectionState currentState) {
    return ScreenTopBackgroundContainer(
      child: LayoutBuilder(
        builder: (context, boxConstraints) {
          return Stack(
            children: [
              const CustomBackButton(),
              Align(
                alignment: Alignment.topCenter,
                child: Container(
                  alignment: Alignment.topCenter,
                  width: boxConstraints.maxWidth * (0.5),
                  child: Text(
                    widget.subject.getSubjectName(context: context),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: TextStyle(
                      color: Theme.of(context).scaffoldBackgroundColor,
                      fontSize: Utils.screenTitleFontSize,
                    ),
                  ),
                ),
              ),
              (isAssignmentManagementModuleEnable() &&
                      isExamManagementModuleEnable())
                  ? AnimatedAlign(
                      curve: Utils.tabBackgroundContainerAnimationCurve,
                      duration: Utils.tabBackgroundContainerAnimationDuration,
                      alignment:
                          currentState.reportFilterTabTitle == assignmentKey
                              ? AlignmentDirectional.centerStart
                              : AlignmentDirectional.centerEnd,
                      child: TabBarBackgroundContainer(
                          boxConstraints: boxConstraints),
                    )
                  : Align(
                      alignment: Alignment.center,
                      child: TabBarBackgroundContainer(
                          boxConstraints: boxConstraints),
                    ),

              (isAssignmentManagementModuleEnable() &&
                      isExamManagementModuleEnable())
                  ? CustomTabBarContainer(
                      boxConstraints: boxConstraints,
                      alignment: AlignmentDirectional.centerStart,
                      isSelected:
                          currentState.reportFilterTabTitle == assignmentKey,
                      onTap: () {
                        context
                            .read<ReportTabSelectionCubit>()
                            .changeReportFilterTabTitle(assignmentKey);
                        getAssignmentReport();
                      },
                      titleKey: assignmentKey,
                    )
                  : CustomTabBarContainer(
                      boxConstraints: boxConstraints,
                      alignment: Alignment.center,
                      isSelected: true,
                      onTap: () {},
                      titleKey: isAssignmentManagementModuleEnable()
                          ? assignmentKey
                          : onlineExamKey),

              //
              (isAssignmentManagementModuleEnable() &&
                      isExamManagementModuleEnable())
                  ? CustomTabBarContainer(
                      boxConstraints: boxConstraints,
                      alignment: AlignmentDirectional.centerEnd,
                      isSelected:
                          currentState.reportFilterTabTitle == onlineExamKey,
                      onTap: () {
                        context
                            .read<ReportTabSelectionCubit>()
                            .changeReportFilterTabTitle(onlineExamKey);
                        getExamOnlineReport();
                      },
                      titleKey: onlineExamKey,
                    )
                  : const SizedBox(),
            ],
          );
        },
      ),
    );
  }

  Widget setSectionTitle({required String titleTxt, required int totalVal}) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 6.0),
      child: Text(
        (totalVal != 0) ? "$titleTxt -> $totalVal" : titleTxt,
        style: TextStyle(
          fontWeight: FontWeight.bold,
          fontSize: 18,
          color: Utils.getColorScheme(context).secondary,
        ),
      ),
    );
  }

  Widget setProgressbar({
    required double val,
    required Color bgColor,
    required Color valueColor,
  }) {
    return SizedBox(
      height: MediaQuery.of(context).size.width * (0.25),
      width: MediaQuery.of(context).size.width * (0.25),
      child: CircularProgressIndicator(
        strokeWidth: 8,
        value: val.isNaN ? 0 : val,
        backgroundColor: bgColor,
        valueColor: AlwaysStoppedAnimation<Color>(valueColor),
      ),
    );
  }

  Widget setStatsChart({
    required Color baseColor,
    required Color progressColor,
    required double progressValue,
  }) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 15, horizontal: 15),
      child: setProgressbar(
        val: progressValue,
        bgColor: baseColor,
        valueColor: progressColor,
      ),
    );
  }

  Widget setStatsText({
    Color? indicatorColor,
    required String titleTxt,
    required String value,
  }) {
    return Container(
      margin: const EdgeInsets.symmetric(vertical: 10, horizontal: 10),
      child: Row(
        children: [
          if (indicatorColor != null)
            Container(
              width: 15,
              height: 15,
              decoration: BoxDecoration(
                color: indicatorColor,
                borderRadius: BorderRadius.circular(10),
              ),
            ),
          10.sizedBoxWidth,
          RichText(
            text: TextSpan(
              children: [
                TextSpan(
                  style: TextStyle(
                    fontSize: 16.0,
                    color: Utils.getColorScheme(context)
                        .secondary
                        .withValues(alpha: 0.75),
                  ),
                  text: "$titleTxt : ",
                ),
                TextSpan(
                  style: TextStyle(
                    fontWeight: FontWeight.w600,
                    fontSize: 16.0,
                    color: Utils.getColorScheme(context).secondary,
                  ),
                  text: value,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget totalAssignmentAndPointsSection({
    required String titleTxt,
    required int titleValue,
    required String statsTitle1,
    required String statsTitle2,
    required String statsValue1,
    required String statsValue2,
    Color? baseColor,
    required Color progressColor,
    required double progressValue,
  }) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 15.0, vertical: 5.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          setSectionTitle(titleTxt: titleTxt, totalVal: titleValue),
          Container(
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(20),
              border: Border.all(
                width: 2,
                color: Utils.getColorScheme(context).surface,
              ),
            ),
            child: Row(
              children: [
                if (baseColor != null)
                  setStatsChart(
                    progressValue: progressValue,
                    progressColor: progressColor,
                    baseColor: baseColor,
                  ),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    (baseColor != null)
                        ? setStatsText(
                            indicatorColor: progressColor,
                            titleTxt: statsTitle1,
                            value: statsValue1,
                          )
                        : setStatsText(
                            titleTxt: statsTitle1,
                            value: statsValue1,
                          ),
                    setStatsText(
                      indicatorColor: baseColor,
                      titleTxt: statsTitle2,
                      value: statsValue2,
                    ),
                  ],
                )
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget assignmentPointsDetails(AssignmentReportFetchSuccess state) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisSize: MainAxisSize.min,
      children: [
        setSectionTitle(
          titleTxt:
              "${Utils.getTranslatedLabel(assignmentKey)} ${Utils.getTranslatedLabel(pointsKey)}",
          totalVal: 0,
        ),
        distinctPointValue(state),
      ],
    );
  }

  Widget pointsBackgroundContainer(Widget child) {
    return Container(
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.surface,
        borderRadius: BorderRadius.circular(10.0),
      ),
      width: MediaQuery.of(context).size.width * (0.90),
      margin: const EdgeInsets.only(bottom: 25),
      padding: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 15.0),
      child: child,
    );
  }

  Widget distinctPointValue(AssignmentReportFetchSuccess state) {
    return Column(
      children: List.generate(
        state.submittedAssignmentWithPointsData.data!.length,
        (index) => pointsBackgroundContainer(
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                "${Utils.getTranslatedLabel(pointsKey)} : ${state.submittedAssignmentWithPointsData.data![index].obtainedPoints ?? 0} / ${state.submittedAssignmentWithPointsData.data![index].totalPoints ?? 0}",
                style: TextStyle(
                  color: Utils.getColorScheme(context).onSurface,
                  fontWeight: FontWeight.w600,
                  fontSize: Utils.screenTitleFontSize,
                ),
              ),
              Text(
                state.submittedAssignmentWithPointsData.data![index]
                    .assignmentName!,
              )
            ],
          ),
        ),
      ),
    );
  }

  Widget onlineExamPointsDetails(OnlineExamReportFetchSuccess state) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisSize: MainAxisSize.min,
      children: [
        setSectionTitle(
          titleTxt:
              "${Utils.getTranslatedLabel(onlineExamKey)} ${Utils.getTranslatedLabel(pointsKey)}",
          totalVal: 0,
        ),
        distinctOnlineExamPointValue(state),
      ],
    );
  }

  Widget distinctOnlineExamPointValue(OnlineExamReportFetchSuccess state) {
    return Column(
      children: List.generate(
        state.examList.total!,
        (index) => pointsBackgroundContainer(
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                "${Utils.getTranslatedLabel(pointsKey)} : ${state.examList.data![index].obtainedMarks} / ${state.examList.data![index].totalMarks}",
                style: TextStyle(
                  color: Utils.getColorScheme(context).onSurface,
                  fontWeight: FontWeight.w600,
                  fontSize: Utils.screenTitleFontSize,
                ),
              ),
              Text(state.examList.data![index].title!)
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildAssignmentReport() {
    return BlocBuilder<AssignmentReportCubit, AssignmentReportState>(
      builder: (context, state) {
        if (state is AssignmentReportFetchSuccess) {
          return SingleChildScrollView(
            controller: _reportAssignmentController,
            padding: EdgeInsets.only(
              top: Utils.getScrollViewTopPadding(
                context: context,
                appBarHeightPercentage: Utils.appBarBiggerHeightPercentage,
              ),
            ),
            child: Column(
              children: [
                totalAssignmentAndPointsSection(
                  progressValue:
                      state.submittedAssignments! / state.assignments!,
                  progressColor: Utils.getColorScheme(context).error,
                  baseColor: Utils.getColorScheme(context).onPrimary,
                  statsTitle1: Utils.getTranslatedLabel(submittedKey),
                  statsValue1: state.submittedAssignments.toString(),
                  statsTitle2: Utils.getTranslatedLabel(pendingKey),
                  statsValue2: state.unsubmittedAssignments.toString(),
                  titleTxt:
                      "${Utils.getTranslatedLabel(totalKey)} ${Utils.getTranslatedLabel(assignmentsKey)}",
                  titleValue: state.assignments!,
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(vertical: 10),
                  child: Text(
                    "* ${Utils.getTranslatedLabel(reportNoteKey)}",
                  ),
                ),
                totalAssignmentAndPointsSection(
                  statsTitle1: Utils.getTranslatedLabel(obtainedKey),
                  statsValue1: state.totalObtainedPoints!,
                  statsTitle2: Utils.getTranslatedLabel(percentageKey),
                  statsValue2: '${state.percentage} %',
                  titleTxt:
                      "${Utils.getTranslatedLabel(totalKey)} ${Utils.getTranslatedLabel(pointsKey)}",
                  titleValue: int.parse(state.totalPoints!),
                  progressValue: int.parse(state.totalObtainedPoints!) /
                      int.parse(state.totalPoints!),
                  progressColor: Utils.getColorScheme(context).primary,
                ),
                ((state.submittedAssignmentWithPointsData.data ?? []).isEmpty)
                    ? const SizedBox()
                    : assignmentPointsDetails(state)
              ],
            ),
          );
        }
        if (state is AssignmentReportFetchFailure) {
          return Padding(
            padding: EdgeInsets.only(
              top: Utils.getScrollViewTopPadding(
                context: context,
                appBarHeightPercentage: Utils.appBarBiggerHeightPercentage,
              ),
            ),
            child: Align(
              alignment: Alignment.topCenter,
              child: ErrorContainer(
                errorMessageCode: state.errorMessage,
                onTapRetry: getAssignmentReport,
              ),
            ),
          );
        }
        return Center(
          child: CustomCircularProgressIndicator(
            indicatorColor: Utils.getColorScheme(context).primary,
          ),
        );
      },
    );
  }

  Widget _buildOnlineExamReport() {
    return BlocBuilder<OnlineExamReportCubit, OnlineExamReportState>(
      builder: (context, state) {
        if (state is OnlineExamReportFetchSuccess) {
          return SingleChildScrollView(
            controller: _reportOnlineExamController,
            padding: EdgeInsets.only(
              top: Utils.getScrollViewTopPadding(
                context: context,
                appBarHeightPercentage: Utils.appBarBiggerHeightPercentage,
              ),
            ),
            child: Column(
              children: [
                totalAssignmentAndPointsSection(
                  progressValue: state.attempted! / state.totalExams!,
                  progressColor: Utils.getColorScheme(context).error,
                  baseColor: Utils.getColorScheme(context).onPrimary,
                  statsTitle1: Utils.getTranslatedLabel(attemptedKey),
                  statsValue1: state.attempted.toString(),
                  statsTitle2: Utils.getTranslatedLabel(missedKey),
                  statsValue2: state.missedExams.toString(),
                  titleTxt:
                      "${Utils.getTranslatedLabel(totalKey)} ${Utils.getTranslatedLabel(onlineExamKey)}",
                  titleValue: state.totalExams!,
                ),
                totalAssignmentAndPointsSection(
                  progressValue: int.parse(state.totalObtainedMarks!) /
                      int.parse(state.totalMarks!),
                  progressColor: Utils.getColorScheme(context).primary,
                  statsTitle1: Utils.getTranslatedLabel(obtainedKey),
                  statsValue1: state.totalObtainedMarks!,
                  statsTitle2: Utils.getTranslatedLabel(
                    percentageKey,
                  ),
                  statsValue2: "${state.percentage!} %",
                  titleTxt:
                      "${Utils.getTranslatedLabel(totalKey)} ${Utils.getTranslatedLabel(pointsKey)}",
                  titleValue: int.parse(state.totalMarks!),
                ),
                onlineExamPointsDetails(state)
              ],
            ),
          );
        }
        if (state is OnlineExamReportFetchFailure) {
          return Padding(
            padding: EdgeInsets.only(
              top: Utils.getScrollViewTopPadding(
                context: context,
                appBarHeightPercentage: Utils.appBarBiggerHeightPercentage,
              ),
            ),
            child: Align(
              alignment: Alignment.topCenter,
              child: state.errorMessage ==
                      ErrorMessageKeysAndCode.noOnlineExamReportFoundCode
                  ? NoDataContainer(
                      titleKey:
                          ErrorMessageKeysAndCode.getErrorMessageKeyFromCode(
                              state.errorMessage),
                    )
                  : ErrorContainer(
                      errorMessageCode: state.errorMessage,
                      onTapRetry: getExamOnlineReport,
                    ),
            ),
          );
        }
        return Center(
          child: CustomCircularProgressIndicator(
            indicatorColor: Utils.getColorScheme(context).primary,
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: BlocBuilder<ReportTabSelectionCubit, ReportTabSelectionState>(
        builder: (context, state) {
          return Stack(
            children: [
              (isExamManagementModuleEnable() &&
                      isAssignmentManagementModuleEnable())
                  ? BlocBuilder<ReportTabSelectionCubit,
                      ReportTabSelectionState>(
                      builder: (context, state) {
                        if (state.reportFilterTabTitle == assignmentKey) {
                          //Assignment
                          return _buildAssignmentReport();
                        } else {
                          //Online exam
                          return _buildOnlineExamReport();
                        }
                      },
                    )
                  : isAssignmentManagementModuleEnable()
                      ? _buildAssignmentReport()
                      : _buildOnlineExamReport(),
              buildReportAppBar(state),
            ],
          );
        },
      ),
    );
  }
}
