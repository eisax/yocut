import 'package:yocut/cubits/authCubit.dart';
import 'package:yocut/cubits/classElectiveSubjectsCubit.dart';
import 'package:yocut/cubits/selectElectiveSubjectsCubit.dart';
import 'package:yocut/cubits/studentSubjectAndSlidersCubit.dart';

import 'package:yocut/data/models/electiveSubject.dart';
import 'package:yocut/data/models/electiveSubjectGroup.dart';
import 'package:yocut/data/repositories/classRepository.dart';
import 'package:yocut/data/repositories/studentRepository.dart';
import 'package:yocut/ui/widgets/customAppbar.dart';
import 'package:yocut/ui/widgets/customCircularProgressIndicator.dart';
import 'package:yocut/ui/widgets/customRoundedButton.dart';
import 'package:yocut/ui/widgets/customShimmerContainer.dart';
import 'package:yocut/ui/widgets/errorContaineer.dart';
import 'package:yocut/ui/widgets/shimmerLoadingContainer.dart';
import 'package:yocut/ui/widgets/subjectImageContainer.dart';
import 'package:yocut/utils/labelKeys.dart';
import 'package:yocut/utils/utils.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get/route_manager.dart';

class SelectSubjectsScreen extends StatefulWidget {
  const SelectSubjectsScreen({super.key});

  @override
  State<SelectSubjectsScreen> createState() => _SelectSubjectsScreenState();

  static Widget routeInstance() {
    return MultiBlocProvider(
      providers: [
        BlocProvider<SelectElectiveSubjectsCubit>(
          create: (_) => SelectElectiveSubjectsCubit(StudentRepository()),
        ),
        BlocProvider<ClassElectiveSubjectsCubit>(
          create: (_) => ClassElectiveSubjectsCubit(ClassRepository()),
        )
      ],
      child: const SelectSubjectsScreen(),
    );
  }
}

class _SelectSubjectsScreenState extends State<SelectSubjectsScreen> {
  @override
  void initState() {
    super.initState();
    Future.delayed(
      Duration.zero,
      () => context.read<ClassElectiveSubjectsCubit>().fetchElectiveSubjects(),
    );
  }

  Map<int, List<int>> selectedElectiveSubjects = {};

  bool hasAllSubjectElected() {
    final electiveSubjectGroups =
        context.read<ClassElectiveSubjectsCubit>().getElectiveSubjectGroups();
    bool subjectElected = true;
    for (var key in selectedElectiveSubjects.keys) {
      ///[Subject to be selected for this group]
      final subjectToSelectForThisGroup = electiveSubjectGroups
          .where((element) => element.id == key)
          .first
          .totalSelectableSubjects;

      if (selectedElectiveSubjects[key]!.length !=
          subjectToSelectForThisGroup) {
        subjectElected = false;
        break;
      }
    }
    return subjectElected;
  }

  bool isSubjectElected({required int groupId, required int classSubjectId}) {
    final subjectGroup = context
        .read<ClassElectiveSubjectsCubit>()
        .getElectiveSubjectGroups()
        .where((element) => element.id == groupId)
        .first;
    final selectedElectiveSubjectsOfGroup =
        selectedElectiveSubjects[subjectGroup.id];

    return selectedElectiveSubjectsOfGroup!.contains(classSubjectId);
  }

  void removeElectedSubject(
      {required int groupId, required int classSubjectId}) {
    //get the subject group
    final subjectGroup = context
        .read<ClassElectiveSubjectsCubit>()
        .getElectiveSubjectGroups()
        .where((element) => element.id == groupId)
        .first;
    //get the selected subject list for that group
    final selectedElectiveSubjectsOfGroup =
        selectedElectiveSubjects[subjectGroup.id];

    //remove the subject
    selectedElectiveSubjectsOfGroup!.remove(classSubjectId);
    selectedElectiveSubjects[subjectGroup.id] = selectedElectiveSubjectsOfGroup;

    setState(() {});
  }

  void selectElectiveSubject(
      {required int groupId, required int classSubjectId}) {
    //get the subject group
    final subjectGroup = context
        .read<ClassElectiveSubjectsCubit>()
        .getElectiveSubjectGroups()
        .where((element) => element.id == groupId)
        .first;
    //get the selected subject list for that group
    final selectedElectiveSubjectsOfGroup =
        selectedElectiveSubjects[subjectGroup.id];

    if (selectedElectiveSubjectsOfGroup!.length ==
        subjectGroup.totalSelectableSubjects) {
      //Show can not select more subject
      Utils.showCustomSnackBar(
        context: context,
        errorMessage: Utils.getTranslatedLabel(canNotSelectMoreSubjectsKey),
        backgroundColor: Theme.of(context).colorScheme.error,
      );
    } else {
      //add subject
      selectedElectiveSubjectsOfGroup.add(classSubjectId);
      selectedElectiveSubjects[subjectGroup.id] =
          selectedElectiveSubjectsOfGroup;

      setState(() {});
    }
  }

  Widget _buildAppBar() {
    final currentClass =
        context.read<AuthCubit>().getStudentDetails().classSection?.fullName ??
            "";
    return Align(
      alignment: Alignment.topCenter,
      child: CustomAppBar(
        showBackButton: false,
        subTitle: "${Utils.getTranslatedLabel(classKey)} $currentClass",
        title: Utils.getTranslatedLabel(selectSubjectsKey),
      ),
    );
  }

  Widget _buildElectiveSubjectContainer({
    required ElectiveSubject subject,
    required int groupId,
  }) {
    return Container(
      margin: const EdgeInsets.only(bottom: 25),
      decoration: BoxDecoration(
        boxShadow: [
          BoxShadow(
            color: Theme.of(context).colorScheme.secondary.withValues(alpha: 0.05),
            offset: const Offset(3.5, 3.5),
            blurRadius: 10,
          )
        ],
        color: Theme.of(context).scaffoldBackgroundColor,
        borderRadius: BorderRadius.circular(10),
      ),
      width: MediaQuery.of(context).size.width,
      padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 10.0),
      child: LayoutBuilder(
        builder: (context, boxConstraints) {
          return Row(
            children: [
              SubjectImageContainer(
                showShadow: false,
                height: 60,
                radius: 7.5,
                subject: subject,
                width: boxConstraints.maxWidth * (0.2),
              ),
              SizedBox(
                width: boxConstraints.maxWidth * (0.05),
              ),
              SizedBox(
                width: boxConstraints.maxWidth * (0.6),
                child: Text(
                  subject.getSubjectName(context: context),
                  style: TextStyle(
                    color: Theme.of(context).colorScheme.secondary,
                    fontWeight: FontWeight.w600,
                    fontSize: 14.0,
                  ),
                ),
              ),
              SizedBox(
                width: boxConstraints.maxWidth * (0.075),
              ),
              InkWell(
                onTap: () {
                  if (isSubjectElected(
                    groupId: groupId,
                    classSubjectId: subject.classSubjectId ?? 0,
                  )) {
                    removeElectedSubject(
                      groupId: groupId,
                      classSubjectId: subject.classSubjectId ?? 0,
                    );
                  } else {
                    selectElectiveSubject(
                      groupId: groupId,
                      classSubjectId: subject.classSubjectId ?? 0,
                    );
                  }
                },
                child: Container(
                  width: boxConstraints.maxWidth * (0.075),
                  height: boxConstraints.maxWidth * (0.075),
                  color: Theme.of(context).colorScheme.primary,
                  child: isSubjectElected(
                    groupId: groupId,
                    classSubjectId: subject.classSubjectId ?? 0,
                  )
                      ? Icon(
                          Icons.check,
                          size: 17,
                          color: Theme.of(context).scaffoldBackgroundColor,
                        )
                      : const SizedBox(),
                ),
              ),
            ],
          );
        },
      ),
    );
  }

  Widget _buildElectiveSubjectGroup({
    required ElectiveSubjectGroup electiveSubjectGroup,
  }) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            "${Utils.getTranslatedLabel(selectAnyKey)} ${electiveSubjectGroup.totalSelectableSubjects}",
            style: TextStyle(
              color: Theme.of(context).colorScheme.secondary,
              fontSize: 13,
            ),
          ),
          const SizedBox(
            height: 10.0,
          ),
          ...electiveSubjectGroup.subjects
              .map(
                (subject) => _buildElectiveSubjectContainer(
                  subject: subject,
                  groupId: electiveSubjectGroup.id,
                ),
              )
              
        ],
      ),
    );
  }

  Widget _buildElectiveSubjectsContainer() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          Utils.getTranslatedLabel(electiveSubjectsKey),
          style: TextStyle(
            color: Theme.of(context).colorScheme.secondary,
            fontSize: 16.0,
            fontWeight: FontWeight.w600,
          ),
        ),
        const SizedBox(
          height: 15,
        ),
        ...context
            .read<ClassElectiveSubjectsCubit>()
            .getElectiveSubjectGroups()
            .map((e) => _buildElectiveSubjectGroup(electiveSubjectGroup: e))
            ,
      ],
    );
  }

  Widget _buildSubmitButton() {
    return Transform.translate(
      offset: const Offset(0.0, -15),
      child: BlocConsumer<SelectElectiveSubjectsCubit,
          SelectElectiveSubjectsState>(
        listener: (context, state) {
          if (state is SelectElectiveSubjectsFailure) {
            Utils.showCustomSnackBar(
              context: context,
              errorMessage: Utils.getErrorMessageFromErrorCode(
                  context, state.errorMessage),
              backgroundColor: Theme.of(context).colorScheme.error,
            );
          } else if (state is SelectElectiveSubjectsSuccess) {
            //Need to update the elective subjects in studentSubjects cubit
            List<ElectiveSubject> electiveSubjects = [];
            final electiveSubjectGroups = context
                .read<ClassElectiveSubjectsCubit>()
                .getElectiveSubjectGroups();

            //Filtering out all the selected elective subject
            for (var electiveSubjectGroup in electiveSubjectGroups) {
              final subjects = electiveSubjectGroup.subjects.where(
                (element) => state.electedClassSubjectIds
                    .contains(element.classSubjectId),
              );
              electiveSubjects.addAll(subjects);
            }

            //update elective subjects in student subject cubit
            context
                .read<StudentSubjectsAndSlidersCubit>()
                .updateElectiveSubjects(electiveSubjects);
            Get.back();
          }
        },
        builder: (context, state) {
          return CustomRoundedButton(
            onTap: () {
              if (state is SelectElectiveSubjectsInProgress) {
                return;
              }

              if (hasAllSubjectElected()) {
                context
                    .read<SelectElectiveSubjectsCubit>()
                    .selectElectiveSubjects(
                      electedSubjectGroups: selectedElectiveSubjects,
                    );
              } else {
                Utils.showCustomSnackBar(
                  context: context,
                  errorMessage: Utils.getTranslatedLabel(
                    pleaseSelectAllElectiveSubjectsKey,
                  ),
                  backgroundColor: Theme.of(context).colorScheme.error,
                );
              }
            },
            widthPercentage: 0.4,
            height: 40,
            backgroundColor: Theme.of(context).colorScheme.primary,
            buttonTitle: Utils.getTranslatedLabel(submitKey),
            showBorder: false,
            child: state is SelectElectiveSubjectsInProgress
                ? CustomCircularProgressIndicator(
                    indicatorColor: Theme.of(context).scaffoldBackgroundColor,
                    strokeWidth: 2,
                    widthAndHeight: 18,
                  )
                : null,
          );
        },
      ),
    );
  }

  Widget _buildSelectSubjectsShimmerLoadingContainer() {
    return SingleChildScrollView(
      padding: EdgeInsets.only(
        left: MediaQuery.of(context).size.width * (0.075),
        right: MediaQuery.of(context).size.width * (0.075),
        top: Utils.getScrollViewTopPadding(
          context: context,
          appBarHeightPercentage: Utils.appBarSmallerHeightPercentage,
        ),
      ),
      child: LayoutBuilder(
        builder: (context, boxConstraints) {
          return Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(
                height: 10,
              ),
              ShimmerLoadingContainer(
                child: CustomShimmerContainer(
                  width: boxConstraints.maxWidth * (0.25),
                ),
              ),
              const SizedBox(
                height: 10,
              ),
              ShimmerLoadingContainer(
                child: CustomShimmerContainer(
                  width: boxConstraints.maxWidth * (0.35),
                ),
              ),
              const SizedBox(
                height: 20,
              ),
              const ShimmerLoadingContainer(
                child: CustomShimmerContainer(
                  height: 80,
                ),
              ),
              const SizedBox(
                height: 20,
              ),
              const ShimmerLoadingContainer(
                child: CustomShimmerContainer(
                  height: 80,
                ),
              ),
              const SizedBox(
                height: 20,
              ),
            ],
          );
        },
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return PopScope(
      canPop: false,
      child: Scaffold(
        body: Stack(
          children: [
            BlocConsumer<ClassElectiveSubjectsCubit,
                ClassElectiveSubjectsState>(
              listener: (context, state) {
                if (state is ClassElectiveSubjectsFetchSuccess) {
                  //
                  for (var electiveSubjectGroup
                      in state.electiveSubjectGroups) {
                    selectedElectiveSubjects
                        .addAll({electiveSubjectGroup.id: []});
                  }
                  setState(() {});
                }
              },
              builder: (context, state) {
                if (state is ClassElectiveSubjectsFetchSuccess) {
                  return Align(
                    alignment: Alignment.topCenter,
                    child: SingleChildScrollView(
                      padding: EdgeInsets.only(
                        left: MediaQuery.of(context).size.width * (0.075),
                        right: MediaQuery.of(context).size.width * (0.075),
                        top: Utils.getScrollViewTopPadding(
                          context: context,
                          appBarHeightPercentage:
                              Utils.appBarSmallerHeightPercentage,
                        ),
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const SizedBox(
                            height: 10,
                          ),
                          _buildElectiveSubjectsContainer(),
                          Center(child: _buildSubmitButton()),
                          const SizedBox(
                            height: 20,
                          ),
                        ],
                      ),
                    ),
                  );
                }

                if (state is ClassElectiveSubjectsFetchFailure) {
                  return Center(
                    child: ErrorContainer(
                      errorMessageCode: state.errorMessage,
                      onTapRetry: () {
                        context
                            .read<ClassElectiveSubjectsCubit>()
                            .fetchElectiveSubjects();
                      },
                    ),
                  );
                }

                return _buildSelectSubjectsShimmerLoadingContainer();
              },
            ),
            _buildAppBar(),
          ],
        ),
      ),
    );
  }
}
