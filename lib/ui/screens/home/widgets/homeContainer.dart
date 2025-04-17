import 'package:yocut/app/routes.dart';
import 'package:yocut/cubits/authCubit.dart';
import 'package:yocut/cubits/noticeBoardCubit.dart';
import 'package:yocut/cubits/schoolConfigurationCubit.dart';
import 'package:yocut/cubits/studentSubjectAndSlidersCubit.dart';
import 'package:yocut/ui/screens/home/widgets/homeContainerTopProfileContainer.dart';
import 'package:yocut/ui/screens/home/widgets/homeScreenDataLoadingContainer.dart';
import 'package:yocut/ui/widgets/errorContaineer.dart';
import 'package:yocut/ui/widgets/latestNoticesContainer.dart';
import 'package:yocut/ui/widgets/noDataContainer.dart';
import 'package:yocut/ui/widgets/schoolGalleryContainer.dart';
import 'package:yocut/ui/widgets/slidersContainer.dart';
import 'package:yocut/ui/widgets/studentSubjectsContainer.dart';
import 'package:yocut/utils/labelKeys.dart';
import 'package:yocut/utils/systemModules.dart';
import 'package:yocut/utils/utils.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get/get.dart';

class HomeContainer extends StatefulWidget {
  //Need this flag in order to show the homeContainer
  //in background when bottom menu is open

  //If it is just for background showing purpose then it will not reactive or not making any api call
  final bool isForBottomMenuBackground;
  const HomeContainer({super.key, required this.isForBottomMenuBackground});

  @override
  State<HomeContainer> createState() => _HomeContainerState();
}

class _HomeContainerState extends State<HomeContainer> {
  @override
  void initState() {
    super.initState();
    // if (!widget.isForBottomMenuBackground) {
    //   Future.delayed(Duration.zero, () {
    //     // fetchSubjectSlidersAndNoticeBoardDetails();
    //   });
    // }
  }

  // void fetchSubjectSlidersAndNoticeBoardDetails() {
  //   context.read<StudentSubjectsAndSlidersCubit>().fetchSubjectsAndSliders(
  //       useParentApi: false,
  //       isSliderModuleEnable: Utils.isModuleEnabled(
  //           context: context, moduleId: sliderManagementModuleId.toString()));

  //   if (Utils.isModuleEnabled(
  //       context: context,
  //       moduleId: announcementManagementModuleId.toString())) {
  //     context
  //         .read<NoticeBoardCubit>()
  //         .fetchNoticeBoardDetails(useParentApi: false);
  //   }
  // }

  // Widget _buildAdvertisemntSliders() {
  //   final sliders = context.read<StudentSubjectsAndSlidersCubit>().getSliders();
  //   return SlidersContainer(sliders: sliders);
  // }

  Widget _buildSlidersSubjectsAndLatestNotcies() {
    return BlocConsumer<SchoolConfigurationCubit,
        SchoolConfigurationState>(
      listener: (context, state) {
        if (state is SchoolConfigurationFetchSuccess) {
          if (state.schoolConfiguration.body.registration.isRegistered &&
              state.electiveSubjects.isEmpty) {
            if (Get.currentRoute == Routes.selectSubjects) {
              return;
            }
            Get.toNamed(Routes.selectSubjects);
          }
        }
      },
      builder: (context, state) {
        if (state is StudentSubjectsAndSlidersFetchSuccess) {
          final subjects =
              context.read<StudentSubjectsAndSlidersCubit>().getSubjects();
          final hasData = subjects.isNotEmpty ||
              Utils.isModuleEnabled(
                  context: context,
                  moduleId: announcementManagementModuleId.toString()) ||
              Utils.isModuleEnabled(
                  context: context,
                  moduleId: galleryManagementModuleId.toString());

          if (!hasData) {
            return Align(
                alignment: Alignment.center,
                child: NoDataContainer(titleKey: nohomescreendatafoundKey));
          }

          return RefreshIndicator(
            displacement: Utils.getScrollViewTopPadding(
              context: context,
              appBarHeightPercentage: Utils.appBarBiggerHeightPercentage,
            ),
            color: Theme.of(context).colorScheme.primary,
            onRefresh: () async {
              context
                  .read<SchoolConfigurationCubit>()
                  .fetchSchoolConfiguration(useParentApi: false);
            },
            child: SingleChildScrollView(
              physics: AlwaysScrollableScrollPhysics(),
              padding: EdgeInsets.only(
                top: Utils.getScrollViewTopPadding(
                  context: context,
                  appBarHeightPercentage: Utils.appBarBiggerHeightPercentage,
                ),
                bottom: Utils.getScrollViewBottomPadding(context),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // _buildAdvertisemntSliders(),
                  SizedBox(
                    height: MediaQuery.of(context).size.height * (0.025),
                  ),
                  StudentSubjectsContainer(
                    subjects: subjects,
                    subjectsTitleKey: mySubjectsKey,
                    animate: !widget.isForBottomMenuBackground,
                  ),
                  Utils.isModuleEnabled(
                          context: context,
                          moduleId: announcementManagementModuleId.toString())
                      ? Column(
                          children: [
                            SizedBox(
                              height:
                                  MediaQuery.of(context).size.height * (0.025),
                            ),
                            LatestNoticiesContainer(
                              animate: !widget.isForBottomMenuBackground,
                            ),
                          ],
                        )
                      : const SizedBox(),
                  Utils.isModuleEnabled(
                          context: context,
                          moduleId: galleryManagementModuleId.toString())
                      ? SchoolGalleryContainer(
                          student:
                              context.read<AuthCubit>().getStudentDetails(),
                        )
                      : const SizedBox(),
                ],
              ),
            ),
          );
        }

        if (state is StudentSubjectsAndSlidersFetchFailure) {
          return Center(
            child: ErrorContainer(
              onTapRetry: () {
                context
                    .read<StudentSubjectsAndSlidersCubit>()
                    .fetchSubjectsAndSliders(
                        useParentApi: false,
                        isSliderModuleEnable: Utils.isModuleEnabled(
                            context: context,
                            moduleId: sliderManagementModuleId.toString()));
              },
              errorMessageCode: "",
            ),
          );
        }

        return HomeScreenDataLoadingContainer(
          addTopPadding: true,
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Align(
          alignment: Alignment.topCenter,
          child: _buildSlidersSubjectsAndLatestNotcies(),
        ),
        Align(
          alignment: Alignment.topCenter,
          child: HomeContainerTopProfileContainer(),
        ),
      ],
    );
  }
}
