import 'package:yocut/utils/animationConfiguration.dart';
import 'package:yocut/utils/labelKeys.dart';
import 'package:yocut/utils/utils.dart';
import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';

class ListItemForExamAndResult extends StatelessWidget {
  final String examStartingDate;
  final String examName;
  final int index;
  final String resultGrade;
  final double resultPercentage;
  final VoidCallback onItemTap;

  const ListItemForExamAndResult({
    Key? key,
    required this.examStartingDate,
    required this.examName,
    required this.resultGrade,
    required this.resultPercentage,
    required this.onItemTap,
    required this.index,
  }) : super(key: key);

  Widget _buildDetailsBackgroundContainer({
    required Widget child,
    required BuildContext context,
  }) {
    return Center(
      child: Container(
        margin: const EdgeInsets.only(bottom: 30),
        width: MediaQuery.of(context).size.width * (0.85),
        padding: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 15.0),
        decoration: BoxDecoration(
          color: Utils.getColorScheme(context).surface,
          borderRadius: BorderRadius.circular(10.0),
        ),
        child: child,
      ),
    );
  }

  TextStyle _getExamDetailsLabelTextStyle({required BuildContext context}) {
    return TextStyle(
      color: Utils.getColorScheme(context).onSurface,
      fontSize: 12,
      fontWeight: FontWeight.w400,
    );
  }

  Widget _buildExamNameLabelAndDateContainer({
    required BuildContext context,
    String? examDate,
  }) {
    return Row(
      children: [
        Text(
          Utils.getTranslatedLabel(examNameKey),
          style: _getExamDetailsLabelTextStyle(context: context),
        ),
        const Spacer(),
        Text(
          '${Utils.getTranslatedLabel(dateKey)}: ',
          style: _getExamDetailsLabelTextStyle(context: context),
        ),
        Text(
          examDate == '' ? '--' : Utils.formatDate(DateTime.parse(examDate!)),
          style: _getExamDetailsLabelTextStyle(context: context),
        ),
      ],
    );
  }

  TextStyle _getExamNameValueTextStyle({required BuildContext context}) {
    return TextStyle(
      color: Utils.getColorScheme(context).secondary,
      fontSize: 14,
      fontWeight: FontWeight.w600,
    );
  }

  Widget _buildExamNameContainer({
    required String examName,
    required BuildContext context,
  }) {
    return Text(
      examName,
      style: _getExamNameValueTextStyle(context: context),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Animate(
      effects: listItemAppearanceEffects(itemIndex: index),
      child: GestureDetector(
        onTap: onItemTap,
        child: _buildDetailsBackgroundContainer(
          context: context,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              _buildExamNameLabelAndDateContainer(
                context: context,
                examDate: examStartingDate,
              ),
              const SizedBox(
                height: 5.0,
              ),
              _buildExamNameContainer(examName: examName, context: context),
              resultGrade != '' && resultPercentage != 0
                  ? _buildResultGradeAndPercentageContainer(context: context)
                  : Container()
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildResultGradeAndPercentageContainer({
    required BuildContext context,
  }) {
    return Column(
      children: [
        const Divider(),
        Row(
          children: [
            Row(
              children: [
                Text(
                  "${Utils.getTranslatedLabel(gradeKey)} - ",
                  style: _getExamNameValueTextStyle(context: context),
                ),
                Text(resultGrade),
              ],
            ),
            const Spacer(),
            Row(
              children: [
                Text(
                  "${Utils.getTranslatedLabel(percentageKey)} : ",
                  style: _getExamNameValueTextStyle(context: context),
                ),
                Text('${resultPercentage.toStringAsFixed(2)}%'),
              ],
            ),
          ],
        ),
      ],
    );
  }
}
