import 'package:yocut/app/routes.dart';
import 'package:yocut/cubits/noticeBoardCubit.dart';
import 'package:yocut/cubits/schoolConfigurationCubit.dart';
import 'package:yocut/cubits/schoolGalleryCubit.dart';
import 'package:yocut/cubits/studentSubjectAndSlidersCubit.dart';
import 'package:yocut/data/models/student.dart';
import 'package:yocut/data/repositories/schoolRepository.dart';
import 'package:yocut/ui/widgets/borderedProfilePictureContainer.dart';
import 'package:yocut/ui/widgets/customBackButton.dart';
import 'package:yocut/ui/widgets/customShimmerContainer.dart';
import 'package:yocut/ui/widgets/errorContaineer.dart';
import 'package:yocut/ui/widgets/latestNoticesContainer.dart';
import 'package:yocut/ui/widgets/noDataContainer.dart';
import 'package:yocut/ui/widgets/schoolGalleryContainer.dart';
import 'package:yocut/ui/widgets/screenTopBackgroundContainer.dart';
import 'package:yocut/ui/widgets/shimmerLoaders/announcementShimmerLoadingContainer.dart';
import 'package:yocut/ui/widgets/shimmerLoaders/subjectsShimmerLoadingContainer.dart';
import 'package:yocut/ui/widgets/shimmerLoadingContainer.dart';
import 'package:yocut/ui/widgets/slidersContainer.dart';
import 'package:yocut/ui/widgets/studentSubjectsContainer.dart';
import 'package:yocut/utils/labelKeys.dart';
import 'package:yocut/utils/systemModules.dart';
import 'package:yocut/utils/utils.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get/get.dart';

class ChildDetailsScreen extends StatefulWidget {
  final Student student;
  const ChildDetailsScreen({Key? key, required this.student}) : super(key: key);

  @override
  State<ChildDetailsScreen> createState() => _ChildDetailsScreenState();

  static Widget routeInstance() {
    return BlocProvider(
      create: (context) => SchoolGalleryCubit(SchoolRepository()),
      child: ChildDetailsScreen(
        student: Get.arguments as Student,
      ),
    );
  }
}

class _ChildDetailsScreenState extends State<ChildDetailsScreen> {
  @override
  void initState() {
    Future.delayed(Duration.zero, () {
      fetchChildSchoolDetails();
    });
    super.initState();
  }

  void fetchChildSchoolDetails() {
    context.read<SchoolConfigurationCubit>().fetchSchoolConfiguration(
        useParentApi: true, childId: widget.student.id ?? 0);
  }

  void fetchChildSubjectAndSliders() {
    context.read<StudentSubjectsAndSlidersCubit>().fetchSubjectsAndSliders(
        isSliderModuleEnable: Utils.isModuleEnabled(
            context: context, moduleId: sliderManagementModuleId.toString()),
        useParentApi: true,
        childId: widget.student.id ?? 0);
  }

  void fetchNoticeBoardDetails() {
    if (Utils.isModuleEnabled(
        context: context,
        moduleId: announcementManagementModuleId.toString())) {
      context.read<NoticeBoardCubit>().fetchNoticeBoardDetails(
          useParentApi: true, childId: widget.student.id);
    }
  }

  void fetchGalleryDetails() {
    if (Utils.isModuleEnabled(
        context: context, moduleId: galleryManagementModuleId.toString())) {
      context.read<SchoolGalleryCubit>().fetchSchoolGallery(
          useParentApi: true,
          childId: widget.student.id,
          sessionYearId: context
                  .read<SchoolConfigurationCubit>()
                  .getSchoolConfiguration()
                  .sessionYear
                  .id ??
              0);
    }
  }

  void schoolConfigurationCubitListener(
      BuildContext context, SchoolConfigurationState state) {
    if (state is SchoolConfigurationFetchSuccess) {
      fetchChildSubjectAndSliders();
      fetchNoticeBoardDetails();
      fetchGalleryDetails();
    }
  }

  Widget _buildAppBar() {
    return Align(
      alignment: Alignment.topCenter,
      child: ScreenTopBackgroundContainer(
        padding: EdgeInsets.zero,
        heightPercentage: Utils.appBarBiggerHeightPercentage,
        child: LayoutBuilder(
          builder: (context, boxConstraints) {
            return Stack(
              children: [
                //Bordered circles
                PositionedDirectional(
                  top: MediaQuery.of(context).size.width * (-0.15),
                  start: MediaQuery.of(context).size.width * (-0.225),
                  child: Container(
                    padding: const EdgeInsetsDirectional.only(
                      end: 20.0,
                      bottom: 20.0,
                    ),
                    decoration: BoxDecoration(
                      border: Border.all(
                        color: Theme.of(context)
                            .scaffoldBackgroundColor
                            .withValues(alpha: 0.1),
                      ),
                      shape: BoxShape.circle,
                    ),
                    width: MediaQuery.of(context).size.width * (0.6),
                    height: MediaQuery.of(context).size.width * (0.6),
                    child: Container(
                      decoration: BoxDecoration(
                        border: Border.all(
                          color: Theme.of(context)
                              .scaffoldBackgroundColor
                              .withValues(alpha: 0.1),
                        ),
                        shape: BoxShape.circle,
                      ),
                    ),
                  ),
                ),

                //bottom fill circle
                PositionedDirectional(
                  bottom: MediaQuery.of(context).size.width * (-0.15),
                  end: MediaQuery.of(context).size.width * (-0.15),
                  child: Container(
                    decoration: BoxDecoration(
                      color: Theme.of(context)
                          .scaffoldBackgroundColor
                          .withValues(alpha: 0.1),
                      shape: BoxShape.circle,
                    ),
                    width: MediaQuery.of(context).size.width * (0.4),
                    height: MediaQuery.of(context).size.width * (0.4),
                  ),
                ),
                CustomBackButton(
                  topPadding: MediaQuery.of(context).padding.top +
                      Utils.appBarContentTopPadding,
                ),
                Align(
                  alignment: AlignmentDirectional.topCenter,
                  child: Padding(
                    padding: EdgeInsets.only(
                      top: MediaQuery.of(context).padding.top +
                          Utils.appBarContentTopPadding,
                      left: 10,
                      right: 10.0,
                    ),
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        BorderedProfilePictureContainer(
                          onTap: () {
                            Get.toNamed(
                              Routes.studentProfile,
                              arguments: widget.student.id,
                            );
                          },
                          heightAndWidth: boxConstraints.maxWidth * (0.16),
                          imageUrl:
                              widget.student.childUserDetails?.image ?? "",
                        ),
                        SizedBox(
                          height: boxConstraints.maxHeight * (0.045),
                        ),
                        Text(
                          widget.student.getFullName(),
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          style: TextStyle(
                            color: Theme.of(context).scaffoldBackgroundColor,
                            fontWeight: FontWeight.w500,
                            fontSize: 15.0,
                          ),
                          textAlign: TextAlign.center,
                        ),
                        SizedBox(
                          height: boxConstraints.maxHeight * (0.0125),
                        ),
                        Text(
                          "${Utils.getTranslatedLabel(classKey)} - ${widget.student.classSection?.fullName}",
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          style: TextStyle(
                            color: Theme.of(context).scaffoldBackgroundColor,
                            fontWeight: FontWeight.w500,
                            fontSize: 11.0,
                          ),
                          textAlign: TextAlign.center,
                        ),
                      ],
                    ),
                  ),
                ),

                BlocBuilder<StudentSubjectsAndSlidersCubit,
                    StudentSubjectsAndSlidersState>(
                  builder: (context, state) {
                    if (state is StudentSubjectsAndSlidersFetchSuccess) {
                      return Align(
                        alignment: AlignmentDirectional.topEnd,
                        child: IconButton(
                          color: Theme.of(context).colorScheme.surface,
                          padding: EdgeInsets.only(
                            top: MediaQuery.of(context).padding.top +
                                Utils.appBarContentTopPadding,
                          ),
                          onPressed: () {
                            Get.toNamed(
                              Routes.parentMenu,
                              arguments: {
                                "student": widget.student,
                                "subjectsForFilter": context
                                    .read<StudentSubjectsAndSlidersCubit>()
                                    .getSubjectsForAssignmentContainer()
                              },
                            );
                          },
                          icon: const Icon(Icons.more_vert),
                        ),
                      );
                    }
                    return const SizedBox();
                  },
                ),
              ],
            );
          },
        ),
      ),
    );
  }

  Widget _buildDataLoadingContainer() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        ShimmerLoadingContainer(
          child: CustomShimmerContainer(
            margin: EdgeInsets.symmetric(
              horizontal: MediaQuery.of(context).size.width * (0.075),
            ),
            width: MediaQuery.of(context).size.width,
            borderRadius: 25,
            height: MediaQuery.of(context).size.height *
                Utils.appBarBiggerHeightPercentage,
          ),
        ),
        SizedBox(
          height: MediaQuery.of(context).size.height * (0.025),
        ),
        const SubjectsShimmerLoadingContainer(),
        SizedBox(
          height: MediaQuery.of(context).size.height * (0.025),
        ),
        Padding(
          padding: EdgeInsets.symmetric(
            horizontal: MediaQuery.of(context).size.width * (0.075),
          ),
          child: Column(
            children: List.generate(2, (index) => index)
                .map(
                  (e) => const AnnouncementShimmerLoadingContainer(),
                )
                .toList(),
          ),
        )
      ],
    );
  }

  Widget _buildSubjectsAndInformationsContainer() {
    return SingleChildScrollView(
      padding: EdgeInsets.only(
        top: Utils.getScrollViewTopPadding(
          context: context,
          appBarHeightPercentage: Utils.appBarBiggerHeightPercentage,
        ),
      ),
      child: BlocBuilder<StudentSubjectsAndSlidersCubit,
          StudentSubjectsAndSlidersState>(
        builder: (context, state) {
          if (state is StudentSubjectsAndSlidersFetchSuccess) {
            final hasSliderData = state.sliders.isNotEmpty;
            final subjects =
                context.read<StudentSubjectsAndSlidersCubit>().getSubjects();
            final hasSubjectData = subjects.isNotEmpty;
            final hasNoticesData = Utils.isModuleEnabled(
                context: context,
                moduleId: announcementManagementModuleId.toString());
            final hasGalleryData = Utils.isModuleEnabled(
                context: context,
                moduleId: galleryManagementModuleId.toString());

            // Check if no data is available
            if (!hasSliderData && !hasSubjectData) {
              return Center(
                child: NoDataContainer(titleKey: nohomescreendatafoundKey),
              );
            }

            // Render the data if available
            return Column(
              children: [
                if (hasSliderData) SlidersContainer(sliders: state.sliders),
                if (hasSubjectData)
                  StudentSubjectsContainer(
                    subjects: subjects,
                    subjectsTitleKey: subjectsKey,
                    childId: widget.student.id,
                  ),
                if (hasNoticesData)
                  SizedBox(
                    height: MediaQuery.of(context).size.height * 0.025,
                  ),
                if (hasNoticesData)
                  LatestNoticiesContainer(
                    childId: widget.student.id,
                  ),
                if (hasGalleryData)
                  SchoolGalleryContainer(
                    student: widget.student,
                  ),
              ],
            );
          }

          if (state is StudentSubjectsAndSlidersFetchFailure) {
            return Center(
              child: ErrorContainer(
                errorMessageCode: state.errorMessage,
                onTapRetry: fetchChildSubjectAndSliders,
              ),
            );
          }

          return _buildDataLoadingContainer();
        },
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          BlocConsumer<SchoolConfigurationCubit, SchoolConfigurationState>(
              listener: schoolConfigurationCubitListener,
              builder: (context, state) {
                if (state is SchoolConfigurationFetchSuccess) {
                  return _buildSubjectsAndInformationsContainer();
                }
                if (state is SchoolConfigurationFetchFailure) {
                  return Center(
                    child: ErrorContainer(
                      errorMessageCode: state.errorMessage,
                      onTapRetry: () {
                        fetchChildSchoolDetails();
                      },
                    ),
                  );
                }

                return _buildDataLoadingContainer();
              }),
          _buildAppBar(),
        ],
      ),
    );
  }
}
