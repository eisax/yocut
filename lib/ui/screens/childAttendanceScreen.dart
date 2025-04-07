import 'package:yocut/cubits/attendanceCubit.dart';
import 'package:yocut/data/repositories/studentRepository.dart';
import 'package:yocut/ui/widgets/attendanceContainer.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get/get.dart';

class ChildAttendanceScreen extends StatelessWidget {
  final int childId;
  const ChildAttendanceScreen({super.key, required this.childId});

  static Widget routeInstance() {
    return BlocProvider<AttendanceCubit>(
      create: (context) => AttendanceCubit(StudentRepository()),
      child: ChildAttendanceScreen(
        childId: Get.arguments as int,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: AttendanceContainer(
        childId: childId,
      ),
    );
  }
}
