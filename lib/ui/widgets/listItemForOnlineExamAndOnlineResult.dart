import 'package:yocut/utils/labelKeys.dart';
import 'package:yocut/utils/utils.dart';
import 'package:flutter/material.dart';

///[marks is '' then it is for online exam]
class ListItemForOnlineExamAndOnlineResult extends StatelessWidget {
  final String examStartingDate;
  final String? examEndingDate;
  final String examName;
  final String subjectName;
  final String totalMarks;
  final String marks;
  final VoidCallback onItemTap;
  final bool isSubjectSelected;
  final bool isExamStarted;

  const ListItemForOnlineExamAndOnlineResult({
    super.key,
    required this.examStartingDate,
    this.examEndingDate,
    required this.examName,
    required this.totalMarks,
    required this.marks,
    required this.onItemTap,
    required this.isExamStarted,
    required this.subjectName,
    this.isSubjectSelected = false,
  });

  bool get isForResult => marks.isNotEmpty;

  Widget _buildDetailsBackgroundContainer({
    required Widget child,
    required BuildContext context,
  }) {
    return Center(
      child: Container(
        margin: const EdgeInsets.only(bottom: 30),
        width: MediaQuery.of(context).size.width * (0.90),
        padding: const EdgeInsets.symmetric(horizontal: 10.0, vertical: 15.0),
        decoration: BoxDecoration(
          color: Utils.getColorScheme(context).surface,
          borderRadius: BorderRadius.circular(10.0),
        ),
        child: child,
      ),
    );
  }

  TextStyle _getLabelsTextStyle({required BuildContext context}) {
    return TextStyle(
      color: Utils.getColorScheme(context).onSurface,
      fontSize: 12,
      fontWeight: FontWeight.w400,
    );
  }

  Widget _buildDateContainer({
    required BuildContext context,
    required String examDate,
    required String examEndDate,
  }) {
    return Row(
      children: [
        !isForResult
            ? Icon(
                Icons.access_time_rounded,
                color: Utils.getColorScheme(context).onSurface,
                size: 15,
              )
            : const SizedBox.shrink(),
        2.sizedBoxWidth,
        isForResult
            ? const SizedBox()
            : Text(
                Utils.getTranslatedLabel(
                    isExamStarted ? examEndsKey : examStartsKey),
                style: _getLabelsTextStyle(context: context),
              ),
        5.sizedBoxWidth,
        Text(
          isForResult
              ? Utils.dateConverter(
                  DateTime.parse(examEndDate),
                  context,
                  true,
                )
              : isExamStarted
                  ? Utils.dateConverter(
                      DateTime.parse(examEndDate),
                      context,
                      false,
                    )
                  : Utils.dateConverter(
                      DateTime.parse(examStartingDate), context, false),
          style: _getLabelsTextStyle(context: context),
        ),
      ],
    );
  }

  Widget _buildSubjectName({
    required BuildContext context,
    required String subjName,
    required bool isSubjectSelected,
  }) {
    return isSubjectSelected
        ? const SizedBox()
        : Text(
            subjName,
            style:
                _getLabelsTextStyle(context: context).copyWith(fontSize: 15.0),
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
          );
  }

  TextStyle _getExamNameAndMarksTextStyle({required BuildContext context}) {
    return TextStyle(
      color: Utils.getColorScheme(context).secondary,
      fontSize: 14,
      fontWeight: FontWeight.w600,
    );
  }

  Widget _buildExamNameAndMarksContainer({
    required BuildContext context,
    required String examName,
    required String totalMarks,
    required String marks,
  }) {
    return Row(
      children: [
        Expanded(
          child: Text(
            examName,
            style: _getExamNameAndMarksTextStyle(context: context),
            overflow: TextOverflow.ellipsis,
            maxLines: 1,
          ),
        ),
        (marks != '')
            ? Text(
                "${Utils.getTranslatedLabel(marksKey)} : $marks / $totalMarks",
                style: _getExamNameAndMarksTextStyle(context: context),
                overflow: TextOverflow.ellipsis,
                maxLines: 1,
              )
            : Text(
                "${Utils.getTranslatedLabel(totalMarksKey)} : $totalMarks",
                style: _getExamNameAndMarksTextStyle(context: context),
                overflow: TextOverflow.ellipsis,
                maxLines: 1,
              ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onItemTap,
      child: _buildDetailsBackgroundContainer(
        context: context,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisSize: MainAxisSize.min,
          children: [
            _buildSubjectName(
              context: context,
              subjName: subjectName,
              isSubjectSelected: isSubjectSelected,
            ),
            const SizedBox(
              height: 5,
            ),
            _buildDateContainer(
                context: context,
                examDate: examStartingDate,
                examEndDate: examEndingDate ?? ""),
            const SizedBox(
              height: 5.0,
            ),
            _buildExamNameAndMarksContainer(
              context: context,
              examName: examName,
              marks: marks,
              totalMarks: totalMarks,
            ),
          ],
        ),
      ),
    );
  }
}
