import 'package:yocut/data/models/question.dart';
import 'package:flutter/material.dart';
import 'package:flutter_tex/flutter_tex.dart';
import 'package:cached_network_image/cached_network_image.dart';

import 'package:yocut/ui/widgets/customCircularProgressIndicator.dart';

import 'package:yocut/utils/labelKeys.dart';
import 'package:yocut/utils/utils.dart';

class QuestionContainer extends StatelessWidget {
  final Question? question;
  final Color? questionColor;
  final int? questionNumber;

  const QuestionContainer({
    Key? key,
    this.question,
    this.questionColor,
    this.questionNumber,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Flexible(
              child: Container(
                alignment: Alignment.centerLeft,
                padding: EdgeInsets.symmetric(
                  horizontal: MediaQuery.of(context).size.width * (0.089),
                ),
                child: TeXView(
                  child: TeXViewDocument(
                    questionNumber == null
                        ? "${question!.question}"
                        : "$questionNumber. ${question!.question}",
                  ),
                  style: TeXViewStyle(
                    contentColor:
                        questionColor ?? Theme.of(context).primaryColor,
                    backgroundColor: Colors.transparent,
                    sizeUnit: TeXViewSizeUnit.pixels,
                    fontStyle: TeXViewFontStyle(fontSize: 20),
                  ),
                ),
              ),
            ),
            (question?.marks ?? 0) == 0
                ? const SizedBox.shrink()
                : Padding(
                    padding: const EdgeInsets.only(right: 20.0),
                    child: Text(
                      "[${question!.marks} ${Utils.getTranslatedLabel(marksKey)}]",
                      style: TextStyle(
                        fontSize: 16.0,
                        fontWeight: FontWeight.w400,
                        color: questionColor ?? Theme.of(context).primaryColor,
                      ),
                    ),
                  ),
          ],
        ),
        15.sizedBoxHeight,
        (question?.image ?? "").isEmpty
            ? const SizedBox.shrink()
            : Container(
                width: MediaQuery.of(context).size.width * (0.8),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(25.0),
                ),
                height: MediaQuery.of(context).size.height * (0.225),
                child: CachedNetworkImage(
                  errorWidget: (context, image, _) => Center(
                    child: Icon(
                      Icons.error,
                      color: Theme.of(context).primaryColor,
                    ),
                  ),
                  imageBuilder: (context, imageProvider) {
                    return Container(
                      decoration: BoxDecoration(
                        image: DecorationImage(
                          image: imageProvider,
                          fit: BoxFit.cover,
                        ),
                        borderRadius: BorderRadius.circular(25.0),
                      ),
                    );
                  },
                  imageUrl: question!.image!,
                  placeholder: (context, url) => Center(
                    child: CustomCircularProgressIndicator(
                      indicatorColor: Utils.getColorScheme(context).primary,
                    ),
                  ),
                ),
              ),
        (question?.note ?? "").isEmpty
            ? const SizedBox.shrink()
            : 8.sizedBoxHeight,
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20),
          child: Row(
            children: [
              Flexible(
                child: (question?.note ?? "").isEmpty
                    ? const SizedBox.shrink()
                    : Text(
                        "${question?.note}",
                        style: const TextStyle(
                          fontSize: 14.0,
                          fontWeight: FontWeight.normal,
                        ),
                      ),
              ),
            ],
          ),
        ),
        5.sizedBoxHeight,
      ],
    );
  }
}
