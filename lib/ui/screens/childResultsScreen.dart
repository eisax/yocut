import 'package:yocut/cubits/resultsCubit.dart';
import 'package:yocut/data/models/subject.dart';
import 'package:yocut/data/repositories/studentRepository.dart';
import 'package:yocut/ui/widgets/resultsContainer.dart';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get/get.dart';

class ChildResultsScreen extends StatelessWidget {
  final int childId;
  final List<Subject>? subjects;
  const ChildResultsScreen({
    Key? key,
    required this.childId,
    required this.subjects,
  }) : super(key: key);

  static Widget routeInstance() {
    final arguments = Get.arguments as Map<String, dynamic>;
    return BlocProvider<ResultsCubit>(
      create: (context) => ResultsCubit(StudentRepository()),
      child: ChildResultsScreen(
        childId: arguments['childId'],
        subjects: arguments['subjects'],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: ResultsContainer(
        childId: childId,
        subjects: subjects,
      ),
    );
  }
}
