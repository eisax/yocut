import 'package:yocut/app/routes.dart';
import 'package:yocut/cubits/authCubit.dart';
import 'package:yocut/cubits/examDetailsCubit.dart';
import 'package:yocut/data/models/exam.dart';
import 'package:yocut/ui/widgets/customRefreshIndicator.dart';
import 'package:yocut/ui/widgets/customShimmerContainer.dart';
import 'package:yocut/ui/widgets/errorContaineer.dart';
import 'package:yocut/ui/widgets/examsFilterContainer.dart';
import 'package:yocut/ui/widgets/listItemForExamAndResult.dart';
import 'package:yocut/ui/widgets/noDataContainer.dart';
import 'package:yocut/ui/widgets/shimmerLoadingContainer.dart';
import 'package:yocut/utils/constants.dart';
import 'package:yocut/utils/labelKeys.dart';
import 'package:yocut/utils/utils.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get/get.dart';

class ExamOfflineListContainer extends StatefulWidget {
  final int? childId;

  const ExamOfflineListContainer({Key? key, this.childId}) : super(key: key);

  @override
  State<ExamOfflineListContainer> createState() =>
      _ExamOfflineListContainerState();
}

class _ExamOfflineListContainerState extends State<ExamOfflineListContainer> {
  String _currentlySelectedExamFilter = allExamsKey;

  @override
  void initState() {
    super.initState();
    fetchExamsList();
  }

  void fetchExamsList() {
    Future.delayed(Duration.zero, () {
      //

      context.read<ExamDetailsCubit>().fetchStudentExamsList(
            useParentApi: context.read<AuthCubit>().isParent(),
            childId: widget.childId,
            examStatus: getExamStatusBasedOnFilterKey(
                examFilter: _currentlySelectedExamFilter),
          );
    });
  }

  Widget _buildExamList(List<Exam> examList) {
    return SingleChildScrollView(
      child: Align(
        alignment: Alignment.topCenter,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: List.generate(
            examList.length,
            (index) => ListItemForExamAndResult(
              index: index,
              examStartingDate: examList[index].examStartingDate!,
              examName: examList[index].examName!,
              resultPercentage: 0,
              resultGrade: '',
              onItemTap: () {
                //if examStartingDate is empty then there is no exam timetable
                if (examList[index].examStartingDate! == '') {
                  Utils.showCustomSnackBar(
                    context: context,
                    errorMessage: Utils.getTranslatedLabel(
                      noExamTimeTableFoundKey,
                    ),
                    backgroundColor: Utils.getColorScheme(context).error,
                  );
                  return;
                }
                Get.toNamed(
                  Routes.examTimeTable,
                  arguments: {
                    'examID': examList[index].examID,
                    'examName': examList[index].examName.toString(),
                    'childID': widget.childId
                  },
                );
              },
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildExamShimmerLoadingContainer() {
    return Container(
      margin: const EdgeInsets.only(bottom: 20),
      width: MediaQuery.of(context).size.width,
      padding: EdgeInsets.symmetric(
        horizontal: Utils.screenContentHorizontalPaddingInPercentage *
            MediaQuery.of(context).size.width,
      ),
      child: ShimmerLoadingContainer(
        child: LayoutBuilder(
          builder: (context, boxConstraints) {
            return Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                SizedBox(
                  height: MediaQuery.of(context).size.height * (0.035),
                ),
                ShimmerLoadingContainer(
                  child: CustomShimmerContainer(
                    height: 9,
                    width: boxConstraints.maxWidth * (0.3),
                  ),
                ),
                SizedBox(
                  height: boxConstraints.maxWidth * (0.02),
                ),
                ShimmerLoadingContainer(
                  child: CustomShimmerContainer(
                    height: 10,
                    width: boxConstraints.maxWidth * (0.8),
                  ),
                ),
                SizedBox(
                  height: boxConstraints.maxWidth * (0.1),
                ),
              ],
            );
          },
        ),
      ),
    );
  }

  Widget _buildExamLoading() {
    return Align(
      alignment: Alignment.topCenter,
      child: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20.0),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: List.generate(
              Utils.defaultShimmerLoadingContentCount,
              (index) => _buildExamShimmerLoadingContainer(),
            ),
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return CustomRefreshIndicator(
      displacment: Utils.getScrollViewTopPadding(
        context: context,
        appBarHeightPercentage: Utils.appBarBiggerHeightPercentage,
      ),
      onRefreshCallback: () {
        context.read<ExamDetailsCubit>().fetchStudentExamsList(
              examStatus: getExamStatusBasedOnFilterKey(
                  examFilter: _currentlySelectedExamFilter),
              useParentApi: context.read<AuthCubit>().isParent(),
              childId: widget.childId,
            );
      },
      child: SingleChildScrollView(
        physics: const AlwaysScrollableScrollPhysics(),
        padding: EdgeInsets.only(
          bottom: Utils.getScrollViewBottomPadding(context),
          top: Utils.getScrollViewTopPadding(
            context: context,
            appBarHeightPercentage: Utils.appBarBiggerHeightPercentage,
          ),
        ),
        child: Column(
          children: [
            //Filter
            ExamFiltersContainer(
              onTapSubject: (examFilterIndex) {
                //Update the selected exam filter
                _currentlySelectedExamFilter = examFilters[examFilterIndex];
                context.read<ExamDetailsCubit>().fetchStudentExamsList(
                      useParentApi: context.read<AuthCubit>().isParent(),
                      childId: widget.childId,
                      examStatus: getExamStatusBasedOnFilterKey(
                          examFilter: _currentlySelectedExamFilter),
                    );

                setState(() {});
              },
              selectedExamFilterIndex:
                  examFilters.indexOf(_currentlySelectedExamFilter),
            ),

            BlocBuilder<ExamDetailsCubit, ExamDetailsState>(
              builder: (context, state) {
                if (state is ExamDetailsFetchSuccess) {
                  return Align(
                    alignment: Alignment.topCenter,
                    child: state.examList.isEmpty
                        ? const NoDataContainer(titleKey: noExamsFoundKey)
                        : Column(
                            children: [
                              SizedBox(
                                height: MediaQuery.of(context).size.height *
                                    (0.035),
                              ),
                              _buildExamList(state.examList),
                            ],
                          ),
                  );
                }
                if (state is ExamDetailsFetchFailure) {
                  return ErrorContainer(
                    errorMessageCode: state.errorMessage,
                    onTapRetry: () {
                      context.read<ExamDetailsCubit>().fetchStudentExamsList(
                            useParentApi: context.read<AuthCubit>().isParent(),
                            childId: widget.childId,
                            examStatus: examFilters
                                .indexOf(_currentlySelectedExamFilter),
                          );
                    },
                  );
                }

                return _buildExamLoading();
              },
            ),
          ],
        ),
      ),
    );
  }
}
