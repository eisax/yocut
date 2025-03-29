import 'package:yocut/cubits/schoolConfigurationCubit.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'package:yocut/data/models/examOnline.dart';

import 'package:yocut/cubits/onlineExamQuestionsCubit.dart';
import 'package:yocut/ui/widgets/customRoundedButton.dart';

import 'package:yocut/utils/labelKeys.dart';
import 'package:yocut/utils/utils.dart';
import 'package:flutter_widget_from_html/flutter_widget_from_html.dart';
import 'package:get/get.dart';

class ExamOnlineKeyBottomsheetContainer extends StatefulWidget {
  final ExamOnline exam;
  final Function navigateToExamScreen;
  const ExamOnlineKeyBottomsheetContainer({
    Key? key,
    required this.exam,
    required this.navigateToExamScreen,
  }) : super(key: key);

  @override
  ExamOnlineKeyBottomsheetContainerState createState() =>
      ExamOnlineKeyBottomsheetContainerState();
}

class ExamOnlineKeyBottomsheetContainerState
    extends State<ExamOnlineKeyBottomsheetContainer> {
  late TextEditingController textEditingController = TextEditingController();

  late String errorMessage = "";

  late bool rulesAccepted = false;

  final double horizontalPaddingPercentage = 0.125;

  Widget _buildAcceptRulesContainer() {
    return Container(
      margin: EdgeInsets.symmetric(
        horizontal:
            MediaQuery.of(context).size.width * horizontalPaddingPercentage,
        vertical: 10.0,
      ),
      alignment: Alignment.center,
      child: Row(
        children: [
          2.sizedBoxWidth,
          InkWell(
            onTap: () {
              setState(() {
                rulesAccepted = !rulesAccepted;
              });
            },
            child: AnimatedContainer(
              duration: const Duration(milliseconds: 300),
              width: 20,
              height: 20,
              alignment: Alignment.center,
              decoration: BoxDecoration(
                color: rulesAccepted
                    ? Utils.getColorScheme(context).primary
                    : Colors.transparent,
                border: Border.all(
                  width: 1.5,
                  color: rulesAccepted
                      ? Utils.getColorScheme(context).primary
                      : Utils.getColorScheme(context).secondary,
                ),
              ),
              child: rulesAccepted
                  ? Icon(
                      Icons.check,
                      color: Theme.of(context).colorScheme.surface,
                      size: 15.0,
                    )
                  : const SizedBox(),
            ),
          ),
          10.sizedBoxWidth,
          Text(
            Utils.getTranslatedLabel(iAgreeWithExamRulesKey),
            style: TextStyle(
              color: Utils.getColorScheme(context).secondary,
            ),
          )
        ],
      ),
    );
  }

  Widget _buildDivider() {
    return Container(
      margin: EdgeInsets.symmetric(
        horizontal: MediaQuery.of(context).size.width * (0.127),
      ),
      child: Divider(
        color: Utils.getColorScheme(context).secondary,
      ),
    );
  }

  Widget _buildExamRules() {
    return Padding(
      padding: EdgeInsets.symmetric(
        horizontal: MediaQuery.of(context).size.width * (0.1),
      ),
      child: HtmlWidget(
        context.read<SchoolConfigurationCubit>().fetchExamRules(),
      ),
    );
  }

  Widget _buildExamKeyTextFieldContainer() {
    return Container(
      alignment: Alignment.center,
      margin: EdgeInsets.symmetric(
        horizontal:
            MediaQuery.of(context).size.width * horizontalPaddingPercentage,
      ),
      padding: const EdgeInsetsDirectional.only(start: 20.0),
      height: 55.0,
      decoration: BoxDecoration(
        border: Border.all(
          color: Utils.getColorScheme(context).surface,
        ),
        borderRadius: BorderRadius.circular(10.0),
        color: Utils.getColorScheme(context).surface,
      ),
      child: TextField(
        controller: textEditingController,
        style: TextStyle(
          fontWeight: FontWeight.w600,
          color: Utils.getColorScheme(context).onSecondary,
        ),
        keyboardType: TextInputType.number,
        decoration: InputDecoration(
          hintText: Utils.getTranslatedLabel(enterExamKey),
          hintStyle: TextStyle(color: Theme.of(context).hintColor),
          contentPadding: EdgeInsets.zero,
          border: InputBorder.none,
        ),
      ),
    );
  }

  Widget _buildSelectedExamDetails() {
    return Container(
      alignment: Alignment.center,
      padding: const EdgeInsets.only(top: 20),
      margin: EdgeInsets.symmetric(
        horizontal:
            MediaQuery.of(context).size.width * horizontalPaddingPercentage,
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(
            widget.exam.subject?.getSubjectName(context: context) ?? "",
            style: TextStyle(
              color: Utils.getColorScheme(context).secondary,
              fontSize: 14,
              fontWeight: FontWeight.w600,
            ),
          ),
          const SizedBox(
            height: 5.0,
          ),
          Text(
            widget.exam.title ?? "",
            style: TextStyle(
              color: Utils.getColorScheme(context).onSecondary,
              fontSize: 12,
              fontWeight: FontWeight.w600,
            ),
          )
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return BlocListener<OnlineExamQuestionsCubit, OnlineExamQuestionsState>(
      bloc: context.read<OnlineExamQuestionsCubit>(),
      listener: (context, state) {
        if (state is OnlineExamQuestionsFetchFailure) {
          setState(() {
            errorMessage =
                Utils.getErrorMessageFromErrorCode(context, state.errorMessage);
          });
        } else if (state is OnlineExamQuestionsFetchSuccess) {
          widget.navigateToExamScreen();
        }
      },
      child: Container(
        constraints: BoxConstraints(
          maxHeight: MediaQuery.of(context).size.height * (0.95),
        ),
        decoration: BoxDecoration(
          borderRadius: const BorderRadius.only(
            topLeft: Radius.circular(20.0),
            topRight: Radius.circular(20.0),
          ),
          color: Theme.of(context).scaffoldBackgroundColor,
        ),
        child: Padding(
          padding: MediaQuery.of(context).viewInsets,
          child: SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Stack(
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                        Container(
                          margin: const EdgeInsets.all(10.0),
                          alignment: Alignment.centerRight,
                          child: IconButton(
                            onPressed: () {
                              if (context.read<OnlineExamQuestionsCubit>().state
                                  is! OnlineExamQuestionsFetchInProgress) {
                                Get.back();
                              }
                            },
                            icon: Icon(
                              Icons.close,
                              size: 28.0,
                              color: Utils.getColorScheme(context).secondary,
                            ),
                          ),
                        ),
                      ],
                    ),
                    _buildSelectedExamDetails(),
                  ],
                ),
                _buildDivider(),
                Align(
                  alignment: AlignmentDirectional.centerStart,
                  child: Container(
                    margin: EdgeInsets.symmetric(
                      horizontal: MediaQuery.of(context).size.width * (0.127),
                    ),
                    child: Text(
                      Utils.getTranslatedLabel(examRulesKey),
                      style: TextStyle(
                        color: Utils.getColorScheme(context).secondary,
                        fontSize: 16.0,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ),
                Align(
                    alignment: AlignmentDirectional.centerStart,
                    child: _buildExamRules()),
                _buildDivider(),
                _buildAcceptRulesContainer(),
                SizedBox(
                  height: MediaQuery.of(context).size.height * (0.0125),
                ),
                _buildExamKeyTextFieldContainer(),
                SizedBox(
                  height: MediaQuery.of(context).size.height * (0.0125),
                ),
                AnimatedSwitcher(
                  duration: const Duration(milliseconds: 250),
                  child: errorMessage.isEmpty
                      ? 20.sizedBoxHeight
                      : SizedBox(
                          height: 20.0,
                          child: Text(
                            errorMessage,
                            style: TextStyle(
                              color: Utils.getColorScheme(context).error,
                            ),
                          ),
                        ),
                ),
                SizedBox(
                  height: MediaQuery.of(context).size.height *
                      (errorMessage.isEmpty ? 0 : 0.02),
                ),
                //show submit button
                BlocBuilder<OnlineExamQuestionsCubit, OnlineExamQuestionsState>(
                  bloc: context.read<OnlineExamQuestionsCubit>(),
                  builder: (context, state) {
                    return PopScope(
                      canPop: context.read<OnlineExamQuestionsCubit>().state
                          is! OnlineExamQuestionsFetchInProgress,
                      child: CustomRoundedButton(
                        onTap: state is OnlineExamQuestionsFetchInProgress
                            ? () {}
                            : () {
                                FocusScope.of(context).unfocus();
                                if (!rulesAccepted) {
                                  setState(() {
                                    errorMessage = Utils.getTranslatedLabel(
                                      pleaseAcceptExamRulesKey,
                                    );
                                  });
                                } else if (textEditingController.text.trim() ==
                                    widget.exam.examKey.toString()) {
                                  errorMessage = "";
                                  //start exam
                                  context
                                      .read<OnlineExamQuestionsCubit>()
                                      .startExam(exam: widget.exam);
                                } else {
                                  setState(() {
                                    errorMessage = Utils.getTranslatedLabel(
                                      enterValidExamKey,
                                    );
                                  });
                                }
                              },
                        textSize: 18.0,
                        widthPercentage: 0.75,
                        titleColor: Theme.of(context).scaffoldBackgroundColor,
                        backgroundColor: Utils.getColorScheme(context).primary,
                        buttonTitle: Utils.getTranslatedLabel(
                          state is OnlineExamQuestionsFetchInProgress
                              ? submittingKey
                              : submitKey,
                        ),
                        showBorder: false,
                      ),
                    );
                  },
                ),
                SizedBox(
                  height: MediaQuery.of(context).size.height * (0.02),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
