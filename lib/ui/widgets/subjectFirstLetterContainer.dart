import 'package:yocut/utils/utils.dart';
import 'package:flutter/material.dart';

class SubjectCodeContainer extends StatelessWidget {
  final String subjectCode;
  const SubjectCodeContainer({super.key, required this.subjectCode});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Text(
        subjectCode,
        style: TextStyle(
          fontSize: Utils.screenSubTitleFontSize,
          fontWeight: FontWeight.w600,
          color: Theme.of(context).scaffoldBackgroundColor,
        ),
      ),
    );
  }
}
