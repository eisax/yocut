import 'package:yocut/app/routes.dart';
import 'package:yocut/cubits/appConfigurationCubit.dart';
import 'package:yocut/cubits/authCubit.dart';
import 'package:yocut/cubits/schoolConfigurationCubit.dart';
import 'package:yocut/cubits/slidersCubit.dart';
import 'package:yocut/cubits/socketSettingCubit.dart';
import 'package:yocut/data/models/student.dart';
import 'package:yocut/data/repositories/schoolRepository.dart';
import 'package:yocut/ui/screens/home/widgets/homeContainerTopProfileContainer.dart';
import 'package:yocut/ui/widgets/appUnderMaintenanceContainer.dart';
import 'package:yocut/ui/widgets/borderedProfilePictureContainer.dart';
import 'package:yocut/ui/widgets/customRoundedButton.dart';
import 'package:yocut/ui/widgets/errorContaineer.dart';
import 'package:yocut/ui/widgets/forceUpdateDialogContainer.dart';
import 'package:yocut/ui/widgets/screenTopBackgroundContainer.dart';
import 'package:yocut/ui/widgets/svgButton.dart';
import 'package:yocut/utils/animationConfiguration.dart';
import 'package:yocut/utils/labelKeys.dart';
import 'package:yocut/utils/systemModules.dart';
import 'package:yocut/utils/utils.dart';
import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get/get.dart';

class ParentHomeScreen extends StatefulWidget {
  const ParentHomeScreen({super.key});

  @override
  State<ParentHomeScreen> createState() => _ParentHomeScreenState();

  static Widget routeInstance() {
    return BlocProvider<SlidersCubit>(
      create: (context) => SlidersCubit(SchoolRepository()),
      child: const ParentHomeScreen(),
    );
  }
}

class _ParentHomeScreenState extends State<ParentHomeScreen> {
  var canPop = false;

  @override
  void initState() {
    Future.delayed(Duration.zero, () {
      _fetchSchoolConfiguration();
      // NotificationUtility.setUpNotificationService();
    });
    super.initState();
  }

  void _fetchSchoolConfiguration() {
    // var firstChildId = context
    //         .read<AuthCubit>()
    //         .getParentDetails()
    //         .children
    //         ?.firstOrNull
    //         ?.id ??
    //     0;
    // context
    //     .read<SchoolConfigurationCubit>()
    //     .fetchSchoolConfiguration(useParentApi: true, childId: firstChildId);
  }

  Widget _buildAppBar() {
    return Align(
      alignment: Alignment.topCenter,
      child: ScreenTopBackgroundContainer(
        padding: EdgeInsets.zero,
        heightPercentage: Utils.appBarMediumtHeightPercentage,
        child: LayoutBuilder(
          builder: (context, boxConstraints) {
            return Stack(
              children: [
                //Bordered circles
                PositionedDirectional(
                  top: MediaQuery.of(context).size.width * (-0.2),
                  start: MediaQuery.of(context).size.width * (-0.225),
                  child: Container(
                    padding: const EdgeInsetsDirectional.only(
                        end: 20.0, bottom: 20.0),
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

                Align(
                  alignment: Alignment.bottomCenter,
                  child: Container(
                    margin: EdgeInsetsDirectional.only(
                      end: boxConstraints.maxWidth * (0.02),
                      start: boxConstraints.maxWidth * (0.056),
                      bottom: boxConstraints.maxHeight * (0.21),
                    ),
                    child: Row(
                      children: [
                        BorderedProfilePictureContainer(
                          heightAndWidth: 65,
                          onTap: () {
                            Get.toNamed(Routes.parentProfile);
                          },
                          imageUrl: context
                                  .read<AuthCubit>()
                                  .getParentDetails()
                                  .image ??
                              "",
                        ),
                        SizedBox(
                          width: boxConstraints.maxWidth * (0.04),
                        ),
                        Row(
                          children: [
                            SizedBox(
                              width: boxConstraints.maxWidth * (0.5),
                              child: Column(
                                mainAxisSize: MainAxisSize.min,
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    context
                                        .read<AuthCubit>()
                                        .getParentDetails()
                                        .getFullName(),
                                    maxLines: 1,
                                    overflow: TextOverflow.ellipsis,
                                    style: TextStyle(
                                      fontSize: 18.0,
                                      fontWeight: FontWeight.w500,
                                      color: Theme.of(context)
                                          .scaffoldBackgroundColor,
                                    ),
                                  ),
                                  Text(
                                    context
                                            .read<AuthCubit>()
                                            .getParentDetails()
                                            .email ??
                                        "",
                                    maxLines: 1,
                                    overflow: TextOverflow.ellipsis,
                                    style: TextStyle(
                                      fontSize: 12.0,
                                      fontWeight: FontWeight.w400,
                                      color: Theme.of(context)
                                          .scaffoldBackgroundColor,
                                    ),
                                  )
                                ],
                              ),
                            )
                          ],
                        ),
                        const Spacer(),
                        BlocBuilder<AppConfigurationCubit,
                            AppConfigurationState>(
                          builder: (context, state) {
                            return Utils.isModuleEnabled(
                                    context: context,
                                    moduleId: chatModuleId.toString())
                                ? SvgButton(
                                    onTap: () {
                                      Get.toNamed(Routes.chatContacts);
                                    },
                                    svgIconUrl:
                                        Utils.getImagePath("chat_icon.svg"),
                                  )
                                : const SizedBox();
                          },
                        ),
                        IconButton(
                          iconSize: 24,
                          color: Theme.of(context).scaffoldBackgroundColor,
                          onPressed: () {
                            Get.toNamed(Routes.settings);
                          },
                          icon: const Icon(Icons.settings),
                        )
                      ],
                    ),
                  ),
                ),
              ],
            );
          },
        ),
      ),
    );
  }

  Widget _buildChildDetailsContainer({
    required double width,
    required Student student,
  }) {
    return Animate(
      effects: customItemZoomAppearanceEffects(),
      child: InkWell(
        borderRadius: BorderRadius.circular(20),
        onTap: () {
          Get.toNamed(Routes.parentChildDetails, arguments: student);
        },
        child: Container(
          decoration: BoxDecoration(
            color: Theme.of(context).colorScheme.primary,
            borderRadius: BorderRadius.circular(20),
          ),
          width: width,
          height: 150, //200
          child: LayoutBuilder(
            builder: (context, boxConstraints) {
              return Stack(
                clipBehavior: Clip.none,
                children: [
                  Align(
                    alignment: Alignment.topCenter,
                    child: Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 5.0),
                      child: Column(
                        children: [
                          SizedBox(
                            height: boxConstraints.maxHeight * (0.125),
                          ),
                          // BorderedProfilePictureContainer(
                          //   onTap: () {
                          //     Get.toNamed(
                          //       Routes.parentChildDetails,
                          //       arguments: student,
                          //     );
                          //   },
                          //   heightAndWidth: 50,
                          //   imageUrl: student.childUserDetails?.image ?? "",
                          // ),
                          SizedBox(
                            height: boxConstraints.maxHeight * (0.075),
                          ),
                          // Padding(
                          //   padding:
                          //       const EdgeInsets.symmetric(horizontal: 7.5),
                          //   child: Text(
                          //     student.getFullName(),
                          //     maxLines: 1,
                          //     overflow: TextOverflow.ellipsis,
                          //     style: TextStyle(
                          //       color:
                          //           Theme.of(context).scaffoldBackgroundColor,
                          //       fontWeight: FontWeight.w500,
                          //       fontSize: 14.0,
                          //     ),
                          //   ),
                          // ),
                          SizedBox(
                            height: boxConstraints.maxHeight * (0.025),
                          ),
                          // Padding(
                          //   padding:
                          //       const EdgeInsets.symmetric(horizontal: 7.5),
                          //   child: Text(
                          //     "${Utils.getTranslatedLabel(classKey)} - ${student.classSection?.fullName}",
                          //     style: TextStyle(
                          //       color:
                          //           Theme.of(context).scaffoldBackgroundColor,
                          //       fontWeight: FontWeight.w500,
                          //       fontSize: 10,
                          //     ),
                          //     maxLines: 2,
                          //     textAlign: TextAlign.center,
                          //   ),
                          // ),
                        ],
                      ),
                    ),
                  ),
                  PositionedDirectional(
                    bottom: -15,
                    start: (boxConstraints.maxWidth * 0.5) - 15,
                    child: Container(
                      alignment: Alignment.center,
                      width: 30,
                      height: 30,
                      decoration: BoxDecoration(
                        boxShadow: [
                          BoxShadow(
                            color: Theme.of(context)
                                .colorScheme
                                .secondary
                                .withValues(alpha: 0.3),
                            offset: const Offset(0, 5),
                            blurRadius: 20,
                          )
                        ],
                        shape: BoxShape.circle,
                        color: Theme.of(context).scaffoldBackgroundColor,
                      ),
                      child: Icon(
                        Icons.arrow_forward_ios,
                        color: Theme.of(context).colorScheme.primary,
                        size: 18,
                      ),
                    ),
                  )
                ],
              );
            },
          ),
        ),
      ),
    );
  }

  Widget _buildChildrenContainer() {
    return Padding(
      padding: EdgeInsets.only(
        left: MediaQuery.of(context).size.width * (0.075),
        right: MediaQuery.of(context).size.width * (0.075),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Align(
            alignment: AlignmentDirectional.centerStart,
            child: Text(
              Utils.getTranslatedLabel(myChildrenKey),
              style: TextStyle(
                fontWeight: FontWeight.w600,
                color: Theme.of(context).colorScheme.secondary,
                fontSize: 16,
              ),
            ),
          ),
          const SizedBox(
            height: 20,
          ),
          LayoutBuilder(
            builder: (context, boxConstraints) {
              return Wrap(
                spacing: boxConstraints.maxWidth * (0.05),
                runSpacing: 32.5,
                children:
                    (context.read<AuthCubit>().getParentDetails().children ??
                            [])
                        .map(
                          (student) => _buildChildDetailsContainer(
                            width: boxConstraints.maxWidth * (0.45),
                            student: student,
                          ),
                        )
                        .toList(),
              );
            },
          )
        ],
      ),
    );
  }

  void _onWillPop() {
    setState(() {
      canPop = true;
    });
    Utils.showCustomSnackBar(
      context: context,
      errorMessage: Utils.getTranslatedLabel(pressbackagaintoexitKey),
      backgroundColor: Theme.of(context).colorScheme.error,
    ); // Do not exit the app
    Future.delayed(Duration(seconds: 2), () {
      setState(() {
        canPop = false;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return PopScope(
        canPop: canPop,
      onPopInvokedWithResult: (didPop, _) {
        if (didPop) return;

        _onWillPop();
      },
      child: Scaffold(
        body: context.read<AppConfigurationCubit>().appUnderMaintenance()
            ? const AppUnderMaintenanceContainer()
            : BlocConsumer<SchoolConfigurationCubit, SchoolConfigurationState>(
                listener: (context, state) {
                  if (state is SchoolConfigurationFetchSuccess) {
                    if (Utils.isModuleEnabled(
                        context: context, moduleId: chatModuleId.toString())) {
                      context.read<SocketSettingCubit>().init(
                          userId:
                              context.read<AuthCubit>().getParentDetails().id ??
                                  0);
                    }
                  }
                },
                builder: (context, state) {
                  if (state is SchoolConfigurationFetchSuccess) {
                    return Stack(
                      children: [
                        Align(
                          alignment: Alignment.topCenter,
                          child: SingleChildScrollView(
                            padding: EdgeInsets.only(
                              bottom: 50,
                              top: Utils.getScrollViewTopPadding(
                                context: context,
                                appBarHeightPercentage:
                                    Utils.appBarMediumtHeightPercentage,
                              ),
                            ),
                            child: Column(
                              children: [
                                _buildChildrenContainer(),
                              ],
                            ),
                          ),
                        ),
                        _buildAppBar(),
                        //Check forece update here
                        context.read<AppConfigurationCubit>().forceUpdate()
                            ? FutureBuilder<bool>(
                                future: Utils.forceUpdate(
                                  context
                                      .read<AppConfigurationCubit>()
                                      .getAppVersion(),
                                ),
                                builder: (context, snaphsot) {
                                  if (snaphsot.hasData) {
                                    return (snaphsot.data ?? false)
                                        ? const ForceUpdateDialogContainer()
                                        : const SizedBox();
                                  }

                                  return const SizedBox();
                                },
                              )
                            : const SizedBox(),
                      ],
                    );
                  }
                  if (state is SchoolConfigurationFetchFailure) {
                    return Center(
                      child: Column(
                        children: [
                          HomeContainerTopProfileContainer(),
                          const SizedBox(height: 15),
                          ErrorContainer(
                            errorMessageCode: state.errorMessage,
                            onTapRetry: _fetchSchoolConfiguration,
                          ),
                          const SizedBox(height: 20),
                          CustomRoundedButton(
                            height: 40,
                            widthPercentage: 0.3,
                            backgroundColor:
                                Theme.of(context).colorScheme.primary,
                            onTap: () {
                              Get.toNamed(Routes.settings);
                            },
                            titleColor:
                                Theme.of(context).scaffoldBackgroundColor,
                            buttonTitle: Utils.getTranslatedLabel(settingsKey),
                            showBorder: false,
                          )
                        ],
                      ),
                    );
                  }

                  return const SizedBox();
                  // return Column(
                  //   children: [
                  //     HomeContainerTopProfileContainer(),
                  //     Expanded(
                  //         child: HomeScreenDataLoadingContainer(
                  //       addTopPadding: false,
                  //     )),
                  //   ],
                  // );
                },
              ),
      ),
    );
  }
}
