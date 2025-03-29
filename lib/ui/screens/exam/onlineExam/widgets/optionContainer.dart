import 'package:yocut/data/models/answerOption.dart';
import 'package:yocut/data/models/question.dart';

import 'package:flutter/material.dart';
import 'package:flutter_tex/flutter_tex.dart';

// ignore: must_be_immutable
class OptionContainer extends StatefulWidget {
  final Function(Question, AnswerOption) submitAnswer;
  final Question question;
  final AnswerOption answerOption;
  final BoxConstraints constraints;
  final List<int> submittedAnswerIds;

  OptionContainer({
    Key? key,
    required this.constraints,
    required this.submitAnswer,
    required this.question,
    required this.answerOption,
    required this.submittedAnswerIds,
  }) : super(key: key);

  @override
  State<OptionContainer> createState() => _OptionContainerState();
}

class _OptionContainerState extends State<OptionContainer>
    with TickerProviderStateMixin {
  late AnimationController animationController = AnimationController(
    vsync: this,
    duration: const Duration(milliseconds: 90),
  );
  late Animation<double> animation =
      Tween<double>(begin: 0.0, end: 1.0).animate(
    CurvedAnimation(
      parent: animationController,
      curve: Curves.easeInToLinear,
    ),
  );

  bool isMultipleAnswers = false;
  late double heightPercentage = 0.105;

  late TextSpan textSpan = TextSpan(
    text: widget.answerOption.option,
    style: TextStyle(
      color: Theme.of(context).colorScheme.primary,
      height: 1.0,
      fontSize: 16.0,
    ),
  );

  @override
  void dispose() {
    animationController.dispose();
    super.dispose();
  }

  int calculateMaxLines() {
    final TextPainter textPainter =
        TextPainter(text: textSpan, textDirection: Directionality.of(context));

    textPainter.layout(
      maxWidth: widget.constraints.maxWidth * (0.85),
    );

    return textPainter.computeLineMetrics().length;
  }

  Color _buildOptionBackgroundColor() {
    if (widget.submittedAnswerIds.contains(widget.answerOption.id)) {
      return Theme.of(context).colorScheme.onPrimary;
    }
    return Theme.of(context).scaffoldBackgroundColor;
  }

  void _onTapOptionContainer() {
    widget.submitAnswer.call(widget.question, widget.answerOption);
  }

  Widget _buildOptionDetails(double optionWidth) {
    final int maxLines = calculateMaxLines();
    if (widget.submittedAnswerIds.isEmpty) {
      heightPercentage = maxLines > 2
          ? (heightPercentage + (0.03 * (maxLines - 2)))
          : heightPercentage;
    }

    return AnimatedBuilder(
      animation: animationController,
      builder: (context, child) {
        return Transform.scale(
          scale: animation.drive(Tween<double>(begin: 1.0, end: 0.9)).value,
          child: child,
        );
      },
      child: Container(
        margin: EdgeInsets.only(top: widget.constraints.maxHeight * (0.015)),
        height: widget.constraints.maxHeight * heightPercentage,
        width: optionWidth,
        child: ClipRRect(
          borderRadius: BorderRadius.circular(15.0),
          child: Stack(
            alignment: Alignment.center,
            children: [
              Container(
                padding: EdgeInsets.symmetric(
                  horizontal: 15.0,
                  vertical: calculateMaxLines() > 2 ? 7.50 : 0,
                ),
                decoration: BoxDecoration(
                  border: Border.all(
                    color: Theme.of(context).colorScheme.onSecondary,
                  ),
                  borderRadius: BorderRadius.circular(15),
                  color: _buildOptionBackgroundColor(),
                ),
                alignment: AlignmentDirectional.centerStart,
                child: TeXView(
                  child: TeXViewInkWell(
                    rippleEffect: false,
                    onTap: (_) {
                      _onTapOptionContainer();
                    },
                    child: TeXViewDocument(
                      widget.answerOption.option!,
                    ),
                    id: widget.answerOption.id!.toString(),
                  ),
                  style: TeXViewStyle(
                    contentColor: Theme.of(context).colorScheme.primary,
                    backgroundColor: _buildOptionBackgroundColor(),
                    sizeUnit: TeXViewSizeUnit.pixels,
                    textAlign: TeXViewTextAlign.left,
                    fontStyle: TeXViewFontStyle(fontSize: 16),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    textSpan = TextSpan(
      text: widget.answerOption.option,
      style: TextStyle(
        color: Theme.of(context).colorScheme.primary,
        height: 1.0,
        fontSize: 16.0,
      ),
    );
    return GestureDetector(
      onTapCancel: () {
        animationController.reverse();
      },
      onTap: () async {
        animationController.reverse();
        _onTapOptionContainer();
      },
      onTapDown: (_) {
        animationController.forward();
      },
      child: _buildOptionDetails(widget.constraints.maxWidth),
    );
  }
}
