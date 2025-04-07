import 'package:yocut/data/models/subject.dart';
import 'package:yocut/ui/screens/home/widgets/examContainer.dart';

import 'package:flutter/material.dart';
import 'package:get/get.dart';

class ExamScreen extends StatelessWidget {
  final int? childId;
  final List<Subject>? subjects;
  const ExamScreen({super.key, this.childId, this.subjects});

  static Widget routeInstance() {
    final arguments = Get.arguments as Map<String, dynamic>;
    return ExamScreen(
      childId: arguments['childId'],
      subjects: arguments['subjects'],
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: ExamContainer(
        childId: childId,
        subjects: subjects,
      ),
    );
  }
}
