import 'package:yocut/cubits/authCubit.dart';
import 'package:yocut/cubits/downloadStudentResultCubit.dart';
import 'package:yocut/data/models/result.dart';
import 'package:yocut/data/models/student.dart';
import 'package:yocut/data/models/subjectMark.dart';
import 'package:yocut/data/repositories/resultRepository.dart';
import 'package:yocut/ui/styles/colors.dart';
import 'package:yocut/ui/widgets/customCircularProgressIndicator.dart';
import 'package:yocut/ui/widgets/screenTopBackgroundContainer.dart';
import 'package:yocut/ui/widgets/svgButton.dart';
import 'package:yocut/utils/labelKeys.dart';
import 'package:yocut/utils/utils.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get/get.dart';
// import 'package:open_filex/open_filex.dart';

class ResultScreen extends StatelessWidget {
  final Result result;
  final int? childId;

  const ResultScreen({super.key, required this.result, this.childId});

  static Widget routeInstance() {
    final arguments = Get.arguments as Map<String, dynamic>;
    return ResultScreen(
      result: arguments['result'],
      childId: arguments['childId'],
    );
  }

  Widget _buildAppBar(BuildContext context) {
    String studentName = "";
    if (context.read<AuthCubit>().isParent()) {
      // final Student student =
      //     (context.read<AuthCubit>().getParentDetails().children ?? [])
      //         .where((element) => element.id == childId)
      //         .first;

      // studentName = "${student.firstName} ${student.lastName}";
    }
    return ScreenTopBackgroundContainer(
      heightPercentage: Utils.appBarMediumtHeightPercentage,
      child: LayoutBuilder(
        builder: (context, boxConstraints) {
          return Stack(
            clipBehavior: Clip.none,
            children: [
              Align(
                alignment: AlignmentDirectional.topEnd,
                child: Padding(
                  padding: EdgeInsetsDirectional.only(
                    end: Utils.screenContentHorizontalPadding,
                  ),
                  child: SvgButton(
                    onTap: () {
                      int studentUserId = 0;

                      if (context.read<AuthCubit>().isParent()) {
                        // final student = context
                        //     .read<AuthCubit>()
                        //     .getParentDetails()
                        //     .children
                        //     ?.where((child) => child.id == childId)
                        //     .first;
                        // studentUserId = student?.userId ?? 0;
                      }
                      // Get.dialog(BlocProvider(
                      //   create: (context) =>
                      //       DownloadStudentResultCubit(ResultRepository()),
                      //   child: DownloadStudentResultDialog(
                      //     childId: context.read<AuthCubit>().isParent()
                      //         ? studentUserId
                      //         : context
                      //                 .read<AuthCubit>()
                      //                 .getStudentDetails()
                      //                 .id ??
                      //             0,
                      //     examId: result.examId,
                      //   ),
                      // ));
                    },
                    svgIconUrl: Utils.getImagePath("download_icon.svg"),
                  ),
                ),
              ),
              Align(
                alignment: AlignmentDirectional.topStart,
                child: Padding(
                  padding: EdgeInsetsDirectional.only(
                    start: Utils.screenContentHorizontalPadding,
                  ),
                  child: SvgButton(
                    onTap: () {
                      Get.back();
                    },
                    svgIconUrl: Utils.getBackButtonPath(context),
                  ),
                ),
              ),
              Align(
                alignment: Alignment.topCenter,
                child: Text(
                  Utils.getTranslatedLabel(resultKey),
                  style: TextStyle(
                    color: Theme.of(context).scaffoldBackgroundColor,
                    fontSize: Utils.screenTitleFontSize,
                  ),
                ),
              ),
              Align(
                alignment: Alignment.topCenter,
                child: Padding(
                  padding: EdgeInsets.only(
                    top: boxConstraints.maxHeight * (0.075) +
                        Utils.screenTitleFontSize,
                  ),
                  child: Text(
                    studentName,
                    maxLines: 1,
                    style: TextStyle(
                      fontSize: Utils.screenSubTitleFontSize,
                      color: Theme.of(context).scaffoldBackgroundColor,
                    ),
                  ),
                ),
              ),
              Positioned(
                bottom: -20,
                left: MediaQuery.of(context).size.width * (0.075),
                child: Container(
                  padding: const EdgeInsets.symmetric(
                      horizontal: 10.0, vertical: 12.5),
                  alignment: Alignment.center,
                  height: 50,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(10),
                    boxShadow: [
                      BoxShadow(
                        color: Theme.of(context)
                            .colorScheme
                            .secondary
                            .withValues(alpha: 0.075),
                        offset: const Offset(2.5, 2.5),
                        blurRadius: 5,
                      )
                    ],
                    color: Theme.of(context).scaffoldBackgroundColor,
                  ),
                  width: MediaQuery.of(context).size.width * (0.85),
                  child: Column(
                    children: [
                      Text(
                        result.examName,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: TextStyle(
                          color: Theme.of(context).colorScheme.secondary,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      const Spacer(),
                    ],
                  ),
                ),
              ),
            ],
          );
        },
      ),
    );
  }

  Widget _buildResultTitleContainer({
    required BuildContext context,
    required BoxConstraints boxConstraints,
    required String title,
  }) {
    return SizedBox(
      width: boxConstraints.maxWidth * (0.25),
      child: Text(
        title,
        maxLines: 1,
        overflow: TextOverflow.ellipsis,
        textAlign: TextAlign.center,
        style: TextStyle(
          color: Theme.of(context).colorScheme.onSurface,
          fontSize: 13.5,
        ),
      ),
    );
  }

  Widget _buildResultValueDetailsContainer({
    required String value,
    required BoxConstraints boxConstraints,
    required bool isSubject,
    required BuildContext buildContext,
  }) {
    return SizedBox(
      width: boxConstraints.maxWidth * (0.25),
      child: Text(
        value,
        maxLines: 2,
        overflow: TextOverflow.ellipsis,
        textAlign: TextAlign.center,
        style: TextStyle(
          color: isSubject
              ? Theme.of(buildContext).colorScheme.onPrimary
              : Theme.of(buildContext).colorScheme.secondary,
          fontWeight: FontWeight.w400,
          fontSize: 13.0,
        ),
      ),
    );
  }

  Widget _buildResultValueContainer({
    required BuildContext context,
    required BoxConstraints boxConstraints,
    required SubjectMark subjectMark,
  }) {
    final String subjectName =
        '${subjectMark.subjectName} ${subjectMark.subjectType == 'Practical' ? '(P)' : '(T)'}';
    return Padding(
      padding: const EdgeInsetsDirectional.only(
        bottom: 10,
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: [
          _buildResultValueDetailsContainer(
            value: subjectName,
            boxConstraints: boxConstraints,
            isSubject: true,
            buildContext: context,
          ),
          _buildResultValueDetailsContainer(
            value: subjectMark.obtainedMarks.toString(),
            boxConstraints: boxConstraints,
            isSubject: false,
            buildContext: context,
          ),
          _buildResultValueDetailsContainer(
            value: subjectMark.totalMarks.toString(),
            boxConstraints: boxConstraints,
            isSubject: false,
            buildContext: context,
          ),
          _buildResultValueDetailsContainer(
            value: subjectMark.grade,
            boxConstraints: boxConstraints,
            isSubject: false,
            buildContext: context,
          ),
        ],
      ),
    );
  }

  Widget _buildResultValues(BuildContext context) {
    return Container(
      alignment: Alignment.center,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(10),
        boxShadow: [
          BoxShadow(
            color: Theme.of(context).colorScheme.secondary.withValues(alpha: 0.075),
            offset: const Offset(2.5, 2.5),
            blurRadius: 5,
          ),
        ],
        color: Theme.of(context).scaffoldBackgroundColor,
      ),
      width: MediaQuery.of(context).size.width * (0.85),
      child: LayoutBuilder(
        builder: (context, boxConstraints) {
          return Column(
            children: [
              const SizedBox(
                height: 10.0,
              ),
              ...result.subjectMarks
                  .map(
                    (subjectMark) => _buildResultValueContainer(
                      context: context,
                      boxConstraints: boxConstraints,
                      subjectMark: subjectMark,
                    ),
                  )
                  ,
              const SizedBox(
                height: 10.0,
              ),
            ],
          );
        },
      ),
    );
  }

  Widget _buildResultTitles(BuildContext context) {
    return Container(
      alignment: Alignment.center,
      height: 50,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(10),
        boxShadow: [
          BoxShadow(
            color: Theme.of(context).colorScheme.secondary.withValues(alpha: 0.075),
            offset: const Offset(2.5, 2.5),
            blurRadius: 5,
          )
        ],
        color: Theme.of(context).scaffoldBackgroundColor,
      ),
      width: MediaQuery.of(context).size.width * (0.85),
      child: LayoutBuilder(
        builder: (context, boxConstraints) {
          return Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              _buildResultTitleContainer(
                context: context,
                boxConstraints: boxConstraints,
                title: Utils.getTranslatedLabel(subKey),
              ),
              _buildResultTitleContainer(
                context: context,
                boxConstraints: boxConstraints,
                title: Utils.getTranslatedLabel(marksKey),
              ),
              _buildResultTitleContainer(
                context: context,
                boxConstraints: boxConstraints,
                title: Utils.getTranslatedLabel(totalKey),
              ),
              _buildResultTitleContainer(
                context: context,
                boxConstraints: boxConstraints,
                title: Utils.getTranslatedLabel(gradeKey),
              ),
            ],
          );
        },
      ),
    );
  }

  Widget _buildObtainedMarksContainer(BuildContext context) {
    return Container(
      alignment: Alignment.center,
      padding: const EdgeInsets.symmetric(horizontal: 15.0),
      height: 60,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(10),
        boxShadow: [
          BoxShadow(
            color: Theme.of(context).colorScheme.secondary.withValues(alpha: 0.075),
            offset: const Offset(2.5, 2.5),
            blurRadius: 5,
          )
        ],
        color: Theme.of(context).scaffoldBackgroundColor,
      ),
      width: MediaQuery.of(context).size.width * (0.85),
      child: Text(
        "${Utils.getTranslatedLabel(obtainedMarksKey)}  :  ${result.obtainedMark}/${result.totalMark}",
        style: TextStyle(
          color: Theme.of(context).colorScheme.secondary,
          fontSize: 15,
        ),
      ),
    );
  }

  Widget _buildPercentageAndGradeTitleAndValueContainer({
    required BuildContext context,
    required String title,
    required String value,
  }) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Text(
          title,
          style: TextStyle(
            color: Theme.of(context).colorScheme.onSurface.withValues(alpha: 0.75),
            fontWeight: FontWeight.w400,
            fontSize: 13.0,
          ),
          textAlign: TextAlign.start,
        ),
        const SizedBox(
          height: 5.0,
        ),
        Text(
          value,
          style: TextStyle(
            color: Theme.of(context).colorScheme.secondary,
            fontWeight: FontWeight.w500,
            fontSize: 15.0,
          ),
        )
      ],
    );
  }

  Widget _buildPercentageAndGradeContainer(BuildContext context) {
    return Stack(
      alignment: Alignment.topCenter,
      children: [
        Container(
          height: 80,
          padding: const EdgeInsets.symmetric(horizontal: 15.0, vertical: 15.0),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(10),
            color: Theme.of(context).colorScheme.surface,
          ),
          width: MediaQuery.of(context).size.width * (0.85),
          child: Row(
            children: [
              Expanded(
                child: _buildPercentageAndGradeTitleAndValueContainer(
                  context: context,
                  title: Utils.getTranslatedLabel(gradeKey),
                  value: result.grade,
                ),
              ),
              Expanded(
                child: _buildPercentageAndGradeTitleAndValueContainer(
                  context: context,
                  title: Utils.getTranslatedLabel(percentageKey),
                  value: "${result.percentage.toStringAsFixed(2)}%",
                ),
              ),
            ],
          ),
        ),
        Align(
          alignment: Alignment.bottomCenter,
          child: Padding(
            padding: const EdgeInsets.only(top: 50),
            child: Container(
              height: 60,
              width: 60,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: result.isPassed ? greenColor : redColor,
                border: Border.all(
                  color: Theme.of(context).colorScheme.surface,
                  width: 8,
                  strokeAlign: BorderSide.strokeAlignOutside,
                ),
              ),
              alignment: Alignment.center,
              child: Text(
                Utils.getTranslatedLabel(
                  result.isPassed ? passedKey : failedKey,
                ),
                maxLines: 1,
                overflow: TextOverflow.clip,
                style: const TextStyle(
                  fontSize: 12,
                  fontWeight: FontWeight.w500,
                  color: Colors.white,
                ),
              ),
            ),
          ),
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
                top: Utils.getScrollViewTopPadding(
                  context: context,
                  appBarHeightPercentage: Utils.appBarMediumtHeightPercentage,
                ),
              ),
              child: Column(
                children: [
                  const SizedBox(
                    height: 30,
                  ),
                  _buildResultTitles(context),
                  const SizedBox(
                    height: 35,
                  ),
                  _buildResultValues(context),
                  const SizedBox(
                    height: 35,
                  ),
                  _buildObtainedMarksContainer(context),
                  const SizedBox(
                    height: 35,
                  ),
                  _buildPercentageAndGradeContainer(context),
                  const SizedBox(
                    height: 35,
                  ),
                ],
              ),
            ),
          ),
          Align(
            alignment: Alignment.topCenter,
            child: _buildAppBar(context),
          ),
        ],
      ),
    );
  }
}

class DownloadStudentResultDialog extends StatefulWidget {
  final int examId;
  final int childId;
  const DownloadStudentResultDialog(
      {super.key, required this.childId, required this.examId});

  @override
  State<DownloadStudentResultDialog> createState() =>
      _DownloadStudentResultDialogState();
}

class _DownloadStudentResultDialogState
    extends State<DownloadStudentResultDialog> {
  @override
  void initState() {
    super.initState();
    Future.delayed(Duration.zero, () {
      context.read<DownloadStudentResultCubit>().downloadStudentResult(
          childId: widget.childId, examId: widget.examId);
    });
  }

  @override
  Widget build(BuildContext context) {
    return BlocListener<DownloadStudentResultCubit, DownloadStudentResultState>(
      listener: (context, state) {
        if (state is DownloadStudentResultSuccess) {
          Get.back();
          // OpenFilex.open(state.downloadedFilePath);
        } else if (state is DownloadStudentResultFailure) {
          Utils.showCustomSnackBar(
              context: context,
              errorMessage: Utils.getTranslatedLabel(state.errorMessage),
              backgroundColor: Theme.of(context).colorScheme.error);
          Get.back();
        }
      },
      child: AlertDialog(
        title: Row(
          children: [
            CustomCircularProgressIndicator(
              widthAndHeight: 15.0,
              strokeWidth: 2.0,
              indicatorColor: Theme.of(context).colorScheme.primary,
            ),
            const SizedBox(width: 10.0),
            Flexible(
                child: Text(
              Utils.getTranslatedLabel(downloadingResultKey),
              style: TextStyle(fontSize: 15.0),
            )),
          ],
        ),
      ),
    );
  }
}
