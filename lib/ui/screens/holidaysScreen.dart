import 'package:yocut/cubits/holidaysCubit.dart';
import 'package:yocut/data/repositories/systemInfoRepository.dart';
import 'package:yocut/ui/widgets/holidaysContainer.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get/get.dart';

class HolidaysScreen extends StatelessWidget {
  final int? childId;
  const HolidaysScreen({Key? key, this.childId}) : super(key: key);

  static Widget routeInstance() {
    return BlocProvider<HolidaysCubit>(
      create: (context) => HolidaysCubit(SystemRepository()),
      child: HolidaysScreen(
        childId: Get.arguments as int?,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: HolidaysContainer(
        childId: childId,
      ),
    );
  }
}
