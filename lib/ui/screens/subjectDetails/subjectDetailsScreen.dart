import 'package:yocut/cubits/authCubit.dart';
import 'package:yocut/cubits/subjectAnnouncementsCubit.dart';
import 'package:yocut/cubits/subjectLessonsCubit.dart';
import 'package:yocut/data/models/Student.dart';
import 'package:yocut/data/models/subject.dart';
import 'package:yocut/data/repositories/announcementRepository.dart';
import 'package:yocut/data/repositories/subjectRepository.dart';
import 'package:yocut/ui/screens/subjectDetails/widgets/announcementContainer.dart';
import 'package:yocut/ui/screens/subjectDetails/widgets/chaptersContainer.dart';
import 'package:yocut/ui/widgets/customBackButton.dart';
import 'package:yocut/ui/widgets/customRefreshIndicator.dart';
import 'package:yocut/ui/widgets/customTabBarContainer.dart';
import 'package:yocut/ui/widgets/screenTopBackgroundContainer.dart';
import 'package:yocut/ui/widgets/tabBarBackgroundContainer.dart';
import 'package:yocut/utils/labelKeys.dart';
import 'package:yocut/utils/systemModules.dart';
import 'package:yocut/utils/utils.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get/get.dart';

class SubjectDetailsScreen extends StatefulWidget {
  final Module subject;
  final int? childId;
  const SubjectDetailsScreen({super.key, required this.subject, this.childId});

  @override
  State<SubjectDetailsScreen> createState() => _SubjectDetailsScreenState();

  static Widget routeInstance() {
    final arguments = Get.arguments as Map<String, dynamic>;

    return MultiBlocProvider(
      providers: [
        BlocProvider<SubjectLessonsCubit>(
          create: (_) => SubjectLessonsCubit(SubjectRepository()),
        ),
        BlocProvider<SubjectAnnouncementCubit>(
          create: (_) => SubjectAnnouncementCubit(AnnouncementRepository()),
        ),
      ],
      child: SubjectDetailsScreen(
        childId: arguments['childId'],
        subject: arguments['subject'],
      ),
    );
  }
}

class _SubjectDetailsScreenState extends State<SubjectDetailsScreen> {
  late String _selectedTabTitle = chaptersKey;

  late final ScrollController _scrollController =
      ScrollController()..addListener(_subjectAnnouncementScrollListener);

  @override
  void initState() {
    super.initState();
    Future.delayed(Duration.zero, () {
      initializeTabBar();
    });
  }

  @override
  void dispose() {
    _scrollController.removeListener(_subjectAnnouncementScrollListener);
    _scrollController.dispose();
    super.dispose();
  }

  bool isLessonManagementModuleEnable() => Utils.isModuleEnabled(
    context: context,
    moduleId: lessonManagementModuleId.toString(),
  );

  bool isAnnouncementManagementModuleEnable() => Utils.isModuleEnabled(
    context: context,
    moduleId: announcementManagementModuleId.toString(),
  );

  void initializeTabBar() {
    // if (isLessonManagementModuleEnable() &&
    //     isAnnouncementManagementModuleEnable()) {
    //   context.read<SubjectLessonsCubit>().fetchSubjectLessons(
    //         classSubjectId: widget.subject.moduleId ?? 0,
    //         useParentApi: context.read<AuthCubit>().isParent(),
    //         childId: widget.childId,
    //       );
    //   context.read<SubjectAnnouncementCubit>().fetchSubjectAnnouncement(
    //         useParentApi: context.read<AuthCubit>().isParent(),
    //         classSubjectId: widget.subject.classSubjectId ?? 0,
    //         childId: widget.childId,
    //       );
    //   _selectedTabTitle = chaptersKey;
    // } else {
    //   if (isAnnouncementManagementModuleEnable()) {
    //     context.read<SubjectAnnouncementCubit>().fetchSubjectAnnouncement(
    //           useParentApi: context.read<AuthCubit>().isParent(),
    //           classSubjectId: widget.subject.classSubjectId ?? 0,
    //           childId: widget.childId,
    //         );
    //     _selectedTabTitle = announcementKey;
    //   }
    //   if (isLessonManagementModuleEnable()) {
    //     context.read<SubjectLessonsCubit>().fetchSubjectLessons(
    //           classSubjectId: widget.subject.classSubjectId ?? 0,
    //           useParentApi: context.read<AuthCubit>().isParent(),
    //           childId: widget.childId,
    //         );
    //     _selectedTabTitle = chaptersKey;
    //   }
    // }

    //
    setState(() {});
  }

  void _subjectAnnouncementScrollListener() {
    if (_scrollController.offset ==
        _scrollController.position.maxScrollExtent) {
      if (_selectedTabTitle == announcementKey) {
        if (context.read<SubjectAnnouncementCubit>().hasMore()) {
          // context.read<SubjectAnnouncementCubit>().fetchMoreAnnouncements(
          //       useParentApi: context.read<AuthCubit>().isParent(),
          //       classSubjectId: widget.subject.classSubjectId ?? 0,
          //       childId: widget.childId,
          //     );
        }
        //to scroll to last in order for users to see the progress
        Future.delayed(const Duration(milliseconds: 10), () {
          _scrollController.animateTo(
            _scrollController.position.maxScrollExtent,
            duration: const Duration(milliseconds: 500),
            curve: Curves.easeIn,
          );
        });
      }
    }
  }

  Widget _buildAppBar() {
    return ScreenTopBackgroundContainer(
      child: LayoutBuilder(
        builder: (context, boxConstraints) {
          return Stack(
            children: [
              const CustomBackButton(),
              Align(
                alignment: Alignment.topCenter,
                child: Container(
                  alignment: Alignment.topCenter,
                  width: boxConstraints.maxWidth * (0.5),
                  // child: Text(
                  //   widget.subject.getSubjectName(context: context),
                  //   maxLines: 1,
                  //   overflow: TextOverflow.ellipsis,
                  //   style: TextStyle(
                  //     color: Theme.of(context).scaffoldBackgroundColor,
                  //     fontSize: Utils.screenTitleFontSize,
                  //   ),
                  // ),
                ),
              ),
              (isAnnouncementManagementModuleEnable() &&
                      isLessonManagementModuleEnable())
                  ? AnimatedAlign(
                    curve: Utils.tabBackgroundContainerAnimationCurve,
                    duration: Utils.tabBackgroundContainerAnimationDuration,
                    alignment:
                        _selectedTabTitle == chaptersKey
                            ? AlignmentDirectional.centerStart
                            : AlignmentDirectional.centerEnd,
                    child: TabBarBackgroundContainer(
                      boxConstraints: boxConstraints,
                    ),
                  )
                  : Align(
                    alignment: AlignmentDirectional.center,
                    child: TabBarBackgroundContainer(
                      boxConstraints: boxConstraints,
                    ),
                  ),
              (isAnnouncementManagementModuleEnable() &&
                      isLessonManagementModuleEnable())
                  ? CustomTabBarContainer(
                    boxConstraints: boxConstraints,
                    alignment: AlignmentDirectional.centerStart,
                    isSelected: _selectedTabTitle == chaptersKey,
                    onTap: () {
                      setState(() {
                        _selectedTabTitle = chaptersKey;
                      });
                    },
                    titleKey: chaptersKey,
                  )
                  : CustomTabBarContainer(
                    boxConstraints: boxConstraints,
                    alignment: AlignmentDirectional.center,
                    isSelected: true,
                    onTap: () {},
                    titleKey:
                        isAnnouncementManagementModuleEnable()
                            ? announcementKey
                            : chaptersKey,
                  ),
              (isAnnouncementManagementModuleEnable() &&
                      isLessonManagementModuleEnable())
                  ? CustomTabBarContainer(
                    boxConstraints: boxConstraints,
                    alignment: AlignmentDirectional.centerEnd,
                    isSelected: _selectedTabTitle == announcementKey,
                    onTap: () {
                      setState(() {
                        _selectedTabTitle = announcementKey;
                      });
                    },
                    titleKey: announcementKey,
                  )
                  : const SizedBox(),
            ],
          );
        },
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          Align(
            alignment: Alignment.topCenter,
            child: CustomRefreshIndicator(
              onRefreshCallback: () {
                if (isAnnouncementManagementModuleEnable()) {
                  // context
                  //     .read<SubjectAnnouncementCubit>()
                  //     .fetchSubjectAnnouncement(
                  //       useParentApi: context.read<AuthCubit>().isParent(),
                  //       classSubjectId: widget.subject.classSubjectId ?? 0,
                  //       childId: widget.childId,
                  //     );
                }
                if (isLessonManagementModuleEnable()) {
                  // context.read<SubjectLessonsCubit>().fetchSubjectLessons(
                  //       classSubjectId: widget.subject.classSubjectId ?? 0,
                  //       useParentApi: context.read<AuthCubit>().isParent(),
                  //       childId: widget.childId,
                  //     );
                }
              },
              displacment: Utils.getScrollViewTopPadding(
                context: context,
                appBarHeightPercentage: Utils.appBarBiggerHeightPercentage,
              ),
              child: SizedBox(
                height: double.maxFinite,
                child: SingleChildScrollView(
                  controller: _scrollController,
                  physics: const AlwaysScrollableScrollPhysics(),
                  padding: EdgeInsets.only(
                    top: Utils.getScrollViewTopPadding(
                      context: context,
                      appBarHeightPercentage:
                          Utils.appBarBiggerHeightPercentage,
                    ),
                  ),
                  child: Column(
                    children: [
                      _selectedTabTitle == chaptersKey
                          ? ChaptersContainer(
                            childId: 0,
                            classSubjectId: widget.subject.moduleId,
                          )
                          : AnnouncementContainer(
                            classSubjectId: widget.subject.moduleId,
                            childId: widget.childId,
                          ),
                    ],
                  ),
                ),
              ),
            ),
          ),
          Align(alignment: Alignment.topCenter, child: _buildAppBar()),
        ],
      ),
    );
  }
}
