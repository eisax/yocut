import 'package:yocut/cubits/authCubit.dart';
import 'package:yocut/cubits/examTabSelectionCubit.dart';
import 'package:yocut/data/models/subject.dart';
import 'package:yocut/ui/widgets/customTabBarContainer.dart';
import 'package:yocut/ui/widgets/examOfflineListContainer.dart';
import 'package:yocut/ui/widgets/examOnlineListContainer.dart';
import 'package:yocut/ui/widgets/screenTopBackgroundContainer.dart';
import 'package:yocut/ui/widgets/tabBarBackgroundContainer.dart';
import 'package:yocut/utils/labelKeys.dart';
import 'package:yocut/utils/utils.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../widgets/customBackButton.dart';

class ExamContainer extends StatelessWidget {
  final int? childId;
  final List<Subject>? subjects;
  const ExamContainer({super.key, this.childId, this.subjects});

  Widget _buildAppBar(
    BuildContext context,
    ExamTabSelectionState currentState,
  ) {
    return ScreenTopBackgroundContainer(
      child: LayoutBuilder(
        builder: (context, boxConstraints) {
          return Stack(
            clipBehavior: Clip.none,
            children: [
              context.read<AuthCubit>().isParent()
                  ? const CustomBackButton()
                  : const SizedBox(),
              Align(
                alignment: Alignment.topCenter,
                child: Container(
                  alignment: Alignment.topCenter,
                  width: boxConstraints.maxWidth * (0.5),
                  child: Text(
                    Utils.getTranslatedLabel(examsKey),
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
                alignment: currentState.examFilterTabTitle == offlineKey
                    ? AlignmentDirectional.centerStart
                    : AlignmentDirectional.centerEnd,
                child:
                    TabBarBackgroundContainer(boxConstraints: boxConstraints),
              ),
              CustomTabBarContainer(
                boxConstraints: boxConstraints,
                alignment: AlignmentDirectional.centerStart,
                isSelected: currentState.examFilterTabTitle == offlineKey,
                onTap: () {
                  context
                      .read<ExamTabSelectionCubit>()
                      .changeExamFilterTabTitle(offlineKey);
                },
                titleKey: offlineKey,
              ),
              CustomTabBarContainer(
                boxConstraints: boxConstraints,
                alignment: AlignmentDirectional.centerEnd,
                isSelected: currentState.examFilterTabTitle == onlineKey,
                onTap: () {
                  context
                      .read<ExamTabSelectionCubit>()
                      .changeExamFilterTabTitle(onlineKey);
                },
                titleKey: onlineKey,
              ),
            ],
          );
        },
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<ExamTabSelectionCubit, ExamTabSelectionState>(
      builder: (context, state) {
        return Stack(
          children: [
            (context.read<ExamTabSelectionCubit>().isExamOnline())
                ? ExamOnlineListContainer(childId: childId, subjects: subjects)
                : ExamOfflineListContainer(
                    childId: childId,
                  ),
            Align(
              alignment: Alignment.topCenter,
              child: _buildAppBar(context, state),
            ),
          ],
        );
      },
    );
  }
}
