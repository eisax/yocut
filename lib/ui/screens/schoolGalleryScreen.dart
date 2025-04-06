import 'package:yocut/cubits/schoolGalleryCubit.dart';
import 'package:yocut/cubits/schoolSessionYearsCubit.dart';

import 'package:yocut/data/models/student.dart';
import 'package:yocut/data/repositories/schoolRepository.dart';

import 'package:yocut/ui/widgets/schoolGalleryWithSessionYearFilterContainer.dart';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get/get.dart';

class SchoolGalleryScreen extends StatelessWidget {
  final Student student;
  const SchoolGalleryScreen({super.key, required this.student});

  static Widget routeInstance() {
    return MultiBlocProvider(
      providers: [
        BlocProvider(
          create: (context) => SchoolGalleryCubit(SchoolRepository()),
        ),
        BlocProvider(
          create: (context) => SchoolSessionYearsCubit(SchoolRepository()),
        ),
      ],
      child: SchoolGalleryScreen(
        student: Get.arguments as Student,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SchoolGalleryWithSessionYearFilterContainer(
          showBackButton: true, student: student),
    );
  }
}
