import 'package:yocut/app/routes.dart';
import 'package:yocut/data/models/subject.dart';
import 'package:yocut/ui/widgets/subjectImageContainer.dart';
import 'package:yocut/utils/systemModules.dart';
import 'package:yocut/utils/utils.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../data/models/Student.dart';

class StudentSubjectsContainer extends StatelessWidget {
  final String subjectsTitleKey;
  final List<Module> subjects;
  final int? childId;
  final bool showReport;
  final bool animate;
  const StudentSubjectsContainer({
    super.key,
    this.childId,
    required this.subjects,
    required this.subjectsTitleKey,
    this.showReport = false,
    this.animate = true,
  });

  Widget _buildSubjectContainer({
    required BoxConstraints boxConstraints,
    required Module subject,
    required BuildContext context,
  }) {
    return GestureDetector(
      onTap: () {
        if (showReport) {
          Get.toNamed(
            Routes.subjectWiseDetailedReport,
            arguments: {
              "subject": subject,
              "childId": childId ?? 0,
            },
          );
        } else {
          //If lessonModule or announcement moudle is enable then navigate to subejct details
          //If module is not enable then do not navigate to subject details screen
          bool sholdNavigateToSubjectDetailsScreen = Utils.isModuleEnabled(
                  context: context,
                  moduleId: announcementManagementModuleId.toString()) ||
              Utils.isModuleEnabled(
                  context: context,
                  moduleId: lessonManagementModuleId.toString());

          if (sholdNavigateToSubjectDetailsScreen) {
            Get.toNamed(
              Routes.subjectDetails,
              arguments: {
                "childId": childId,
                "subject": subject,
              },
            );
          }
        }
      },
      child: Container(
        width: boxConstraints.maxWidth * (0.26),
        margin: const EdgeInsets.only(
          bottom: 15.0,
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisSize: MainAxisSize.min,
          children: [
            // SubjectImageContainer(
            //   showShadow: false,
            //   animate: animate,
            //   width: boxConstraints.maxWidth * (0.26),
            //   height: boxConstraints.maxWidth * (0.26),
            //   radius: 20,
            //   subject: subject,
            // ),
            5.sizedBoxHeight,
            Text(
              subject.moduleName,
              textAlign: TextAlign.center,
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
              style: TextStyle(
                color: Utils.getColorScheme(context).secondary,
                fontWeight: FontWeight.w400,
                fontSize: 14,
              ),
            )
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return subjects.isEmpty
        ? const SizedBox()
        : Container(
            width: MediaQuery.of(context).size.width,
            margin: EdgeInsets.symmetric(
              horizontal: MediaQuery.of(context).size.width *
                  Utils.screenContentHorizontalPaddingInPercentage,
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Align(
                  alignment: AlignmentDirectional.centerStart,
                  child: Text(
                    Utils.getTranslatedLabel(subjectsTitleKey),
                    style: TextStyle(
                      color: Utils.getColorScheme(context).secondary,
                      fontWeight: FontWeight.w600,
                      fontSize: 16.0,
                    ),
                    textAlign: TextAlign.start,
                  ),
                ),
                SizedBox(
                  height: MediaQuery.of(context).size.height * (0.025),
                ),
                LayoutBuilder(
                  builder: (context, boxConstraints) {
                    return Wrap(
                      spacing: boxConstraints.maxWidth * (0.1),
                      children: List.generate(subjects.length, (index) => index)
                          .map(
                            (index) => _buildSubjectContainer(
                              boxConstraints: boxConstraints,
                              context: context,
                              subject: subjects[index],
                            ),
                          )
                          .toList(),
                    );
                  },
                )
              ],
            ),
          );
  }
}
