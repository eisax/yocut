import 'package:yocut/cubits/submitOnlineExamAnswersCubit.dart';
import 'package:yocut/data/models/question.dart';
import 'package:yocut/ui/widgets/customCircularProgressIndicator.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'package:yocut/cubits/onlineExamQuestionsCubit.dart';
import 'package:yocut/ui/widgets/customRoundedButton.dart';

import 'package:yocut/utils/labelKeys.dart';
import 'package:yocut/utils/utils.dart';
import 'package:get/get.dart';

class ExamQuestionStatusBottomSheetContainer extends StatelessWidget {
  final PageController pageController;
  final Function navigateToResultScreen;
  final SubmitOnlineExamAnswersCubit submitOnlineExamAnswersCubit;

  final Map<int, List<int>> submittedAnswers;
  final int onlineExamId;

  ExamQuestionStatusBottomSheetContainer({
    Key? key,
    required this.pageController,
    required this.navigateToResultScreen,
    required this.submitOnlineExamAnswersCubit,
    required this.submittedAnswers,
    required this.onlineExamId,
  }) : super(key: key);

  Widget buildQuestionAttemptedByMarksContainer({
    required BuildContext context,
    required String questionMark,
    required List<Question> questions,
  }) {
    return Column(
      children: [
        const Divider(),
        Container(
          margin: const EdgeInsets.symmetric(horizontal: 10.0),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                "$questionMark ${Utils.getTranslatedLabel(marksKey)} ${Utils.getTranslatedLabel(questionsKey)}",
                style: TextStyle(
                  color: Utils.getColorScheme(context).onSurface,
                  fontSize: 14.0,
                ),
              ),
              Text(
                "[${questions.length}]",
                style: TextStyle(
                  color: Utils.getColorScheme(context).onSurface,
                  fontSize: 14.0,
                ),
              ),
            ],
          ),
        ),
        Wrap(
          children: List.generate(questions.length, (index) => index)
              .map(
                (index) => hasQuestionAttemptedContainer(
                  attempted: submittedAnswers.containsKey(questions[index].id),
                  context: context,
                  questionIndex: context
                      .read<OnlineExamQuestionsCubit>()
                      .getQuetionIndexById(questions[index].id!),
                ),
              )
              .toList(),
        ),
      ],
    );
  }

  Widget hasQuestionAttemptedContainer({
    required int questionIndex,
    required bool attempted,
    required BuildContext context,
  }) {
    return GestureDetector(
      onTap: () {
        pageController.animateToPage(
          questionIndex,
          duration: const Duration(milliseconds: 250),
          curve: Curves.easeInOut,
        );
        Get.back();
      },
      child: Container(
        alignment: Alignment.center,
        margin: const EdgeInsets.symmetric(horizontal: 5.0, vertical: 5.0),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(10),
          color: attempted
              ? Utils.getColorScheme(context).onSecondary
              : Utils.getColorScheme(context).error,
        ),
        height: 35.0,
        width: 35.0,
        child: Text(
          "${questionIndex + 1}",
          style: TextStyle(color: Theme.of(context).scaffoldBackgroundColor),
        ),
      ),
    );
  }

  Widget setAnsweredAndNotAnsweredCount({
    required BuildContext context,
    required String titleText,
    required int answerCount,
    required Color bgColor,
  }) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 15),
      height: 50,
      width: MediaQuery.of(context).size.width * 0.90,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(10),
        color: bgColor,
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            Utils.getTranslatedLabel(titleText),
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.bold,
              color: Utils.getColorScheme(context).surface,
            ),
          ),
          Text(
            answerCount.toString(),
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.bold,
              color: Utils.getColorScheme(context).surface,
            ),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 15.0),
      constraints: BoxConstraints(
        maxHeight: MediaQuery.of(context).size.height * (0.95),
      ),
      decoration: const BoxDecoration(
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(20.0),
          topRight: Radius.circular(20.0),
        ),
      ),
      child: SingleChildScrollView(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Stack(
              children: [
                Align(
                  alignment: AlignmentDirectional.centerStart,
                  child: Padding(
                    padding: const EdgeInsets.only(top: 20.0),
                    child: Text(
                      "${Utils.getTranslatedLabel(totalQuestionsKey)} : ${context.read<OnlineExamQuestionsCubit>().getQuestions().length} ",
                      style: TextStyle(
                        color: Utils.getColorScheme(context).onSurface,
                        fontSize: 15.0,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                ),
                Align(
                  alignment: AlignmentDirectional.centerEnd,
                  child: Padding(
                    padding: const EdgeInsets.only(top: 20.0),
                    child: Text(
                      "${Utils.getTranslatedLabel(totalMarksKey)} : ${context.read<OnlineExamQuestionsCubit>().getTotalMarks()} ",
                      style: TextStyle(
                        color: Utils.getColorScheme(context).onSurface,
                        fontSize: 15.0,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                ),
              ],
            ),
            ...context
                .read<OnlineExamQuestionsCubit>()
                .getUniqueQuestionMark()
                .map((questionMark) {
              return buildQuestionAttemptedByMarksContainer(
                context: context,
                questionMark: questionMark,
                questions: context
                    .read<OnlineExamQuestionsCubit>()
                    .getQuestionsByMark(questionMark),
              );
            }).toList(),
            const Divider(),
            const SizedBox(
              height: 5.0,
            ),
            setAnsweredAndNotAnsweredCount(
              context: context,
              titleText: unAnsweredKey,
              answerCount: context
                      .read<OnlineExamQuestionsCubit>()
                      .getTotalQuestions()! -
                  submittedAnswers.length,
              bgColor: Utils.getColorScheme(context).error,
            ),
            const SizedBox(
              height: 5.0,
            ),
            setAnsweredAndNotAnsweredCount(
              context: context,
              titleText: answeredKey,
              answerCount: submittedAnswers.length,
              bgColor: Utils.getColorScheme(context).onSecondary,
            ),
            const SizedBox(
              height: 20.0,
            ),
            BlocBuilder<SubmitOnlineExamAnswersCubit,
                SubmitOnlineExamAnswersState>(
              bloc: submitOnlineExamAnswersCubit,
              builder: (context, state) {
                return CustomRoundedButton(
                  onTap: () {
                    if (state is SubmitOnlineExamAnswersInProgress) {
                      return;
                    }
                    navigateToResultScreen();
                  },
                  widthPercentage: 0.9,
                  backgroundColor: Utils.getColorScheme(context).primary,
                  buttonTitle: Utils.getTranslatedLabel(submitKey),
                  radius: 10,
                  showBorder: false,
                  titleColor: Utils.getColorScheme(context).surface,
                  height: 50.0,
                  child: (state is SubmitOnlineExamAnswersInProgress)
                      ? CustomCircularProgressIndicator(
                          indicatorColor:
                              Theme.of(context).scaffoldBackgroundColor,
                        )
                      : null,
                );
              },
            ),
            SizedBox(
              height: MediaQuery.of(context).size.height * (0.025),
            ),
          ],
        ),
      ),
    );
  }
}
