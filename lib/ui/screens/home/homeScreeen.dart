import 'package:yocut/app/routes.dart';
import 'package:yocut/cubits/appConfigurationCubit.dart';
import 'package:yocut/cubits/attendanceCubit.dart';
import 'package:yocut/cubits/authCubit.dart';
import 'package:yocut/cubits/holidaysCubit.dart';
import 'package:yocut/cubits/resultsCubit.dart';
import 'package:yocut/cubits/schoolConfigurationCubit.dart';
import 'package:yocut/cubits/schoolGalleryCubit.dart';
import 'package:yocut/cubits/schoolSessionYearsCubit.dart';
import 'package:yocut/cubits/socketSettingCubit.dart';
import 'package:yocut/cubits/studentGuardianDetailsCubit.dart';
import 'package:yocut/cubits/timeTableCubit.dart';
import 'package:yocut/data/models/notificationDetails.dart';
import 'package:yocut/data/repositories/notificationRepository.dart';
import 'package:yocut/data/repositories/schoolRepository.dart';
import 'package:yocut/data/repositories/studentRepository.dart';
import 'package:yocut/data/repositories/systemInfoRepository.dart';
import 'package:yocut/ui/screens/home/cubits/assignmentsTabSelectionCubit.dart';
import 'package:yocut/ui/screens/home/widgets/bottomNavigationItemContainer.dart';
import 'package:yocut/ui/screens/home/widgets/examContainer.dart';
import 'package:yocut/ui/screens/home/widgets/homeContainer.dart';
import 'package:yocut/ui/screens/home/widgets/homeContainerTopProfileContainer.dart';
import 'package:yocut/ui/screens/home/widgets/homeScreenDataLoadingContainer.dart';
import 'package:yocut/ui/screens/home/widgets/moreMenuBottomsheetContainer.dart';
import 'package:yocut/ui/screens/home/widgets/parentProfileContainer.dart';
import 'package:yocut/ui/screens/reports/reportSubjectsContainer.dart';
import 'package:yocut/ui/widgets/appUnderMaintenanceContainer.dart';
import 'package:yocut/ui/widgets/assignmentsContainer.dart';
import 'package:yocut/ui/widgets/attendanceContainer.dart';
import 'package:yocut/ui/widgets/customRoundedButton.dart';
import 'package:yocut/ui/widgets/errorContaineer.dart';
import 'package:yocut/ui/widgets/forceUpdateDialogContainer.dart';
import 'package:yocut/ui/widgets/holidaysContainer.dart';
import 'package:yocut/ui/widgets/noticeBoardContainer.dart';
import 'package:yocut/ui/widgets/schoolGalleryWithSessionYearFilterContainer.dart';
import 'package:yocut/ui/widgets/settingsContainer.dart';
import 'package:yocut/ui/widgets/timetableContainer.dart';
import 'package:yocut/utils/constants.dart';
import 'package:yocut/utils/homeBottomsheetMenu.dart';
import 'package:yocut/utils/labelKeys.dart';
import 'package:yocut/utils/systemModules.dart';
import 'package:yocut/utils/utils.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get/get.dart';

import '../../widgets/resultsContainer.dart';

class HomeScreen extends StatefulWidget {
  static GlobalKey<HomeScreenState> homeScreenKey =
      GlobalKey<HomeScreenState>();
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => HomeScreenState();

  static Widget routeInstance() {
    return MultiBlocProvider(
      providers: [
        BlocProvider<TimeTableCubit>(
          create: (_) => TimeTableCubit(StudentRepository()),
        ),
        BlocProvider<StudentGuardianDetailsCubit>(
          create: (_) => StudentGuardianDetailsCubit(StudentRepository()),
        ),
        BlocProvider<AttendanceCubit>(
          create: (context) => AttendanceCubit(StudentRepository()),
        ),
        BlocProvider<HolidaysCubit>(
          create: (context) => HolidaysCubit(SystemRepository()),
        ),
        BlocProvider<AssignmentsTabSelectionCubit>(
          create: (_) => AssignmentsTabSelectionCubit(),
        ),
        BlocProvider<ResultsCubit>(
          create: (_) => ResultsCubit(StudentRepository()),
        ),
        BlocProvider<SchoolGalleryCubit>(
          create: (_) => SchoolGalleryCubit(SchoolRepository()),
        ),
      ],
      child: HomeScreen(
        key: homeScreenKey,
      ),
    );
  }
}

class HomeScreenState extends State<HomeScreen>
    with TickerProviderStateMixin, WidgetsBindingObserver {
  late final AnimationController _animationController = AnimationController(
    vsync: this,
    duration: const Duration(milliseconds: 500),
  );

  late final Animation<double> _bottomNavAndTopProfileAnimation =
      Tween<double>(begin: 0.0, end: 1.0).animate(
    CurvedAnimation(
      parent: _animationController,
      curve: Curves.easeInOut,
    ),
  );

  var canPop = false;

  late final List<AnimationController> _bottomNavItemTitlesAnimationController =
      [];

  late final AnimationController _moreMenuBottomsheetAnimationController =
      AnimationController(
    vsync: this,
    duration: homeMenuBottomSheetAnimationDuration,
  );

  late final Animation<Offset> _moreMenuBottomsheetAnimation =
      Tween<Offset>(begin: const Offset(0.0, 1.0), end: Offset.zero).animate(
    CurvedAnimation(
      parent: _moreMenuBottomsheetAnimationController,
      curve: Curves.easeInOut,
    ),
  );

  late final Animation<double> _moreMenuBackgroundContainerColorAnimation =
      Tween<double>(begin: 0.0, end: 1.0).animate(
    CurvedAnimation(
      parent: _moreMenuBottomsheetAnimationController,
      curve: Curves.easeInOut,
    ),
  );

  late int _currentSelectedBottomNavIndex = 0;
  late int _previousSelectedBottmNavIndex = -1;

  //index of opened homeBottomsheet menu
  late int _currentlyOpenMenuIndex = -1;

  late bool _isMoreMenuOpen = false;

  late List<BottomNavItem> _bottomNavItems = [];

  @override
  void initState() {
    super.initState();

    WidgetsBinding.instance.addObserver(this);
    _animationController.forward();

    Future.delayed(Duration.zero, () {
    //  loadTemporarilyStoredNotifications();
      context
          .read<SchoolConfigurationCubit>()
          .fetchSchoolConfiguration(useParentApi: false);
      //setup notification callback here
      // NotificationUtility.setUpNotificationService();
    });
  }

  void loadTemporarilyStoredNotifications() {
    NotificationRepository.getTemporarilyStoredNotifications()
        .then((notifications) {
      //
      for (var notificationData in notifications) {
        NotificationRepository.addNotification(
            notificationDetails:
                NotificationDetails.fromJson(Map.from(notificationData)));
      }
      //
      if (notifications.isNotEmpty) {
        NotificationRepository.clearTemporarilyNotification();
      }

      //
    });
  }

  void updateBottomNavItems() {
    _bottomNavItems = context
            .read<SchoolConfigurationCubit>()
            .getSchoolConfiguration()
            .body.registration.isRegistered
        ? [
            BottomNavItem(
              activeImageUrl: Utils.getImagePath("home_active_icon.svg"),
              disableImageUrl: Utils.getImagePath("home_icon.svg"),
              title: homeKey,
            ),
            BottomNavItem(
              activeImageUrl: Utils.getImagePath("assignment_active_icon.svg"),
              disableImageUrl: Utils.getImagePath("assignment_icon.svg"),
              title: assignmentsKey,
            ),
            BottomNavItem(
              activeImageUrl: Utils.getImagePath("menu_active_icon.svg"),
              disableImageUrl: Utils.getImagePath("menu_icon.svg"),
              title: menuKey,
            ),
          ]
        : [
            BottomNavItem(
              activeImageUrl: Utils.getImagePath("home_active_icon.svg"),
              disableImageUrl: Utils.getImagePath("home_icon.svg"),
              title: homeKey,
            ),
            BottomNavItem(
              activeImageUrl: Utils.getImagePath("menu_active_icon.svg"),
              disableImageUrl: Utils.getImagePath("menu_icon.svg"),
              title: menuKey,
            ),
          ];

    //Update the animaitons controller based on assignment module enable
    initAnimations();

    setState(() {});
  }

  void navigateToAssignmentContainer() {
    Get.until((route) => route.isFirst);
    changeBottomNavItem(1);
  }

  void initAnimations() {
    for (var i = 0; i < _bottomNavItems.length; i++) {
      _bottomNavItemTitlesAnimationController.add(
        AnimationController(
          value: i == _currentSelectedBottomNavIndex ? 0.0 : 1.0,
          vsync: this,
          duration: const Duration(milliseconds: 400),
        ),
      );
    }
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    _animationController.dispose();
    for (var animationController in _bottomNavItemTitlesAnimationController) {
      animationController.dispose();
    }
    _moreMenuBottomsheetAnimationController.dispose();
    super.dispose();
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    super.didChangeAppLifecycleState(state);

    if (state == AppLifecycleState.resumed) {
      loadTemporarilyStoredNotifications();
    }
  }

  bool canPopScreen() {
    if (_isMoreMenuOpen) {
      return false;
    }
    if (_currentSelectedBottomNavIndex != 0) {
      return false;
    }
    return true;
  }

  Future<void> changeBottomNavItem(int index) async {
    if (_moreMenuBottomsheetAnimationController.isAnimating) {
      return;
    }
    _bottomNavItemTitlesAnimationController[_currentSelectedBottomNavIndex]
        .forward();

    //need to assign previous selected bottom index only if menu is close
    if (!_isMoreMenuOpen && _currentlyOpenMenuIndex == -1) {
      _previousSelectedBottmNavIndex = _currentSelectedBottomNavIndex;
    }

    //change current selected bottom index
    setState(() {
      _currentSelectedBottomNavIndex = index;

      //if user taps on non-last bottom nav item then change _currentlyOpenMenuIndex
      if (_currentSelectedBottomNavIndex != _bottomNavItems.length - 1) {
        _currentlyOpenMenuIndex = -1;
      }
    });

    _bottomNavItemTitlesAnimationController[_currentSelectedBottomNavIndex]
        .reverse();

    //if bottom index is last means open/close the bottom sheet
    if (index == _bottomNavItems.length - 1) {
      if (_moreMenuBottomsheetAnimationController.isCompleted) {
        //close the menu
        await _moreMenuBottomsheetAnimationController.reverse();

        setState(() {
          _isMoreMenuOpen = !_isMoreMenuOpen;
        });

        //change bottom nav to previous selected index
        //only if there is not any opened menu item container
        if (_currentlyOpenMenuIndex == -1) {
          changeBottomNavItem(_previousSelectedBottmNavIndex);
        }
      } else {
        //open menu
        await _moreMenuBottomsheetAnimationController.forward();
        setState(() {
          _isMoreMenuOpen = !_isMoreMenuOpen;
        });
      }
    } else {
      //if current selected index is not last index(bottom nav item)
      //and menu is open then close the menu
      if (_moreMenuBottomsheetAnimationController.isCompleted) {
        await _moreMenuBottomsheetAnimationController.reverse();
        setState(() {
          _isMoreMenuOpen = !_isMoreMenuOpen;
        });
      }
    }
  }

  Future<void> _closeBottomMenu() async {
    if (_currentlyOpenMenuIndex == -1) {
      //close the menu and change bottom sheet
      changeBottomNavItem(_previousSelectedBottmNavIndex);
    } else {
      await _moreMenuBottomsheetAnimationController.reverse();
      setState(() {
        _isMoreMenuOpen = !_isMoreMenuOpen;
      });
    }
  }

  Future<void> _onTapMoreMenuItemContainer(int index) async {
    await _moreMenuBottomsheetAnimationController.reverse();
    _currentlyOpenMenuIndex = index;
    _isMoreMenuOpen = !_isMoreMenuOpen;
    setState(() {});
  }

  Widget _buildBottomNavigationContainer() {
    return FadeTransition(
      opacity: _bottomNavAndTopProfileAnimation,
      child: SlideTransition(
        position: _bottomNavAndTopProfileAnimation.drive(
          Tween<Offset>(begin: const Offset(0.0, 1.0), end: Offset.zero),
        ),
        child: Container(
          alignment: Alignment.center,
          margin: EdgeInsets.only(
            bottom: Utils.bottomNavigationBottomMargin,
          ),
          decoration: BoxDecoration(
            boxShadow: [
              BoxShadow(
                color: Utils.getColorScheme(context)
                    .secondary
                    .withValues(alpha: 0.15),
                offset: const Offset(2.5, 2.5),
                blurRadius: 20,
              )
            ],
            color: Theme.of(context).scaffoldBackgroundColor,
            borderRadius: BorderRadius.circular(10.0),
          ),
          width: MediaQuery.of(context).size.width * (0.85),
          height: MediaQuery.of(context).size.height *
              Utils.bottomNavigationHeightPercentage,
          child: LayoutBuilder(
            builder: (context, boxConstraints) {
              return Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: _bottomNavItems.isEmpty
                    ? [const SizedBox()]
                    : _bottomNavItems.map((bottomNavItem) {
                        final int index = _bottomNavItems
                            .indexWhere((e) => e.title == bottomNavItem.title);
                        return BottomNavItemContainer(
                          showCaseDescription: bottomNavItem.title,
                          onTap: changeBottomNavItem,
                          boxConstraints: boxConstraints,
                          currentIndex: _currentSelectedBottomNavIndex,
                          bottomNavItem: _bottomNavItems[index],
                          animationController:
                              _bottomNavItemTitlesAnimationController[index],
                          index: index,
                        );
                      }).toList(),
              );
            },
          ),
        ),
      ),
    );
  }

  Widget _buildMoreMenuBackgroundContainer() {
    return GestureDetector(
      onTap: () async {
        _closeBottomMenu();
      },
      child: Container(
        width: MediaQuery.of(context).size.width,
        height: MediaQuery.of(context).size.height,
        color: Theme.of(context).colorScheme.secondary.withValues(alpha: 0.75),
      ),
    );
  }

  //To load the selected menu item
  //it _currentlyOpenMenuIndex is 0 then load the container based on homeBottomSheetMenu[_currentlyOpenMenuIndex]
  Widget _buildMenuItemContainer() {
    if (homeBottomSheetMenu[_currentlyOpenMenuIndex].title == attendanceKey) {
      return const AttendanceContainer();
    }
    if (homeBottomSheetMenu[_currentlyOpenMenuIndex].title == timeTableKey) {
      return const TimeTableContainer();
    }
    if (homeBottomSheetMenu[_currentlyOpenMenuIndex].title == settingsKey) {
      return const SettingsContainer();
    }
    if (homeBottomSheetMenu[_currentlyOpenMenuIndex].title == noticeBoardKey) {
      return const NoticeBoardContainer(
        showBackButton: false,
      );
    }
    if (homeBottomSheetMenu[_currentlyOpenMenuIndex].title ==
        guardianDetailsKey) {
      return const GuardianProfileContainer();
    }

    if (homeBottomSheetMenu[_currentlyOpenMenuIndex].title == holidaysKey) {
      return const HolidaysContainer();
    }
    if (homeBottomSheetMenu[_currentlyOpenMenuIndex].title == examsKey) {
      return const ExamContainer();
    }
    if (homeBottomSheetMenu[_currentlyOpenMenuIndex].title == resultKey) {
      return const ResultsContainer();
    }

    if (homeBottomSheetMenu[_currentlyOpenMenuIndex].title == reportsKey) {
      return const ReportSubjectsContainer();
    }

    if (homeBottomSheetMenu[_currentlyOpenMenuIndex].title == galleryKey) {
      return MultiBlocProvider(
        providers: [
          BlocProvider(
            create: (context) => SchoolGalleryCubit(SchoolRepository()),
          ),
          BlocProvider(
            create: (context) => SchoolSessionYearsCubit(SchoolRepository()),
          ),
        ],
        child: SchoolGalleryWithSessionYearFilterContainer(
            showBackButton: false,
            student: context.read<AuthCubit>().getStudentDetails()),
      );
    }
    return const SizedBox();
  }

  Widget _buildBottomSheetBackgroundContent() {
    //
    //Based on previous selected index show backgorund content
    if (_currentlyOpenMenuIndex != -1) {
      return _buildMenuItemContainer();
    } else {
      //If it is not enable
      if (!(context
          .read<SchoolConfigurationCubit>()
          .getSchoolConfiguration()
          .body.registration.isRegistered)) {
        return const HomeContainer(
          isForBottomMenuBackground: true,
        );
      }

      if (_previousSelectedBottmNavIndex == 0) {
        return const HomeContainer(
          isForBottomMenuBackground: true,
        );
      }

      //Previous selected index is 1
      if (_previousSelectedBottmNavIndex == 1) {
        return const AssignmentsContainer(
          isForBottomMenuBackground: true,
        );
      }

      return const SizedBox();
    }
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
      canPop: _currentSelectedBottomNavIndex == 0 ? canPop : canPopScreen(),
      onPopInvokedWithResult: (didPop, _) {
        if (_currentSelectedBottomNavIndex == 0) {
          _onWillPop();
          return;
        }
        if (_isMoreMenuOpen) {
          _closeBottomMenu();
          return;
        }
        if (_currentSelectedBottomNavIndex != 0) {
          changeBottomNavItem(0);
          return;
        }
      },
      child: Scaffold(
        body: context.read<AppConfigurationCubit>().appUnderMaintenance()
            ? const AppUnderMaintenanceContainer()
            : BlocConsumer<SchoolConfigurationCubit, SchoolConfigurationState>(
                listener: (context, state) {
                  if (state is SchoolConfigurationFetchSuccess ||
                      state is SchoolConfigurationFetchFailure) {
                    updateBottomNavItems();
                    if (state is SchoolConfigurationFetchSuccess) {
                      if (Utils.isModuleEnabled(
                          context: context,
                          moduleId: galleryManagementModuleId.toString())) {
                        context.read<SchoolGalleryCubit>().fetchSchoolGallery(
                            useParentApi: false,
                            sessionYearId:
                                2025 ?? 0);
                      }

                      ///[Setting up the socket connection]

                      // if (Utils.isModuleEnabled(
                      //     context: context,
                      //     moduleId: chatModuleId.toString())) {
                      //   context.read<SocketSettingCubit>().init(
                      //       userId: context
                      //               .read<AuthCubit>()
                      //               .getStudentDetails()
                      //               .id ??
                      //           0);
                      // }
                    }
                  }
                },
                builder: (context, state) {
                  if (state is SchoolConfigurationFetchSuccess) {
                    return Stack(
                      children: [
                       
                        IgnorePointer(
                          ignoring: !_isMoreMenuOpen,
                          child: FadeTransition(
                            opacity: _moreMenuBackgroundContainerColorAnimation,
                            child: _buildMoreMenuBackgroundContainer(),
                          ),
                        ),

                        //More menu bottom sheet
                        Align(
                          alignment: Alignment.bottomCenter,
                          child: SlideTransition(
                            position: _moreMenuBottomsheetAnimation,
                            child: MoreMenuBottomsheetContainer(
                              closeBottomMenu: _closeBottomMenu,
                              onTapMoreMenuItemContainer:
                                  _onTapMoreMenuItemContainer,
                            ),
                          ),
                        ),
                        Align(
                          alignment: Alignment.bottomCenter,
                          child: _buildBottomNavigationContainer(),
                        ),

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
                          const SizedBox(
                            height: 15,
                          ),
                          ErrorContainer(
                            errorMessageCode: state.errorMessage,
                            onTapRetry: () {
                              context
                                  .read<SchoolConfigurationCubit>()
                                  .fetchSchoolConfiguration(
                                      useParentApi: false);
                            },
                          ),
                          const SizedBox(
                            height: 20,
                          ),
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

                  return Column(
                    children: [
                      HomeContainerTopProfileContainer(),
                      Expanded(
                          child: HomeScreenDataLoadingContainer(
                        addTopPadding: false,
                      )),
                    ],
                  );
                },
              ),
      ),
    );
  }
}
