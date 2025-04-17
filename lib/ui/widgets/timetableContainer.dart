import 'package:yocut/cubits/authCubit.dart';
import 'package:yocut/cubits/timeTableCubit.dart';
import 'package:yocut/data/models/Student.dart';
import 'package:yocut/data/models/timeTableSlot.dart';
import 'package:yocut/ui/widgets/customBackButton.dart';
import 'package:yocut/ui/widgets/customShimmerContainer.dart';
import 'package:yocut/ui/widgets/errorContaineer.dart';
import 'package:yocut/ui/widgets/noDataContainer.dart';
import 'package:yocut/ui/widgets/screenTopBackgroundContainer.dart';
import 'package:yocut/ui/widgets/shimmerLoadingContainer.dart';
import 'package:yocut/ui/widgets/subjectImageContainer.dart';
import 'package:yocut/utils/animationConfiguration.dart';
import 'package:yocut/utils/constants.dart';
import 'package:yocut/utils/labelKeys.dart';
import 'package:yocut/utils/utils.dart';
import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/svg.dart';

class TimeTableContainer extends StatefulWidget {
  final int? childId;
  const TimeTableContainer({super.key, this.childId});

  @override
  State<TimeTableContainer> createState() => _TimeTableContainerState();
}

class _TimeTableContainerState extends State<TimeTableContainer>
    with SingleTickerProviderStateMixin {
  late int _currentSelectedDayIndex = DateTime.now().weekday - 1;

  @override
  void initState() {
    super.initState();
    Future.delayed(Duration.zero, () {
      context.read<TimeTableCubit>().fetchStudentTimeTable(
            useParentApi: context.read<AuthCubit>().isParent(),
            childId: widget.childId,
          );
    });
  }

  List<TimeTableSlot> _buildTimeTableSlots(List<TimeTableSlot> timeTableSlot) {
    final dayWiseTimeTableSlots = timeTableSlot
        .where((element) =>
            element.day == Utils.weekDaysFullForm[_currentSelectedDayIndex])
        .toList();
    return dayWiseTimeTableSlots;
  }

  Widget _buildTimeTableShimmerLoadingContainer() {
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
            return Row(
              children: [
                CustomShimmerContainer(
                  height: 60,
                  width: boxConstraints.maxWidth * (0.25),
                ),
                SizedBox(
                  width: boxConstraints.maxWidth * (0.05),
                ),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    CustomShimmerContainer(
                      height: 9,
                      width: boxConstraints.maxWidth * (0.6),
                    ),
                    const SizedBox(
                      height: 10,
                    ),
                    CustomShimmerContainer(
                      height: 8,
                      width: boxConstraints.maxWidth * (0.5),
                    ),
                  ],
                )
              ],
            );
          },
        ),
      ),
    );
  }

  Widget _buildTimeTableLoading() {
    return ShimmerLoadingContainer(
      child: Column(
        children: List.generate(5, (index) => index)
            .map((e) => _buildTimeTableShimmerLoadingContainer())
            .toList(),
      ),
    );
  }

  Widget _buildAppBar() {
    String getStudentClassDetails = "";
    if (context.read<AuthCubit>().isParent()) {
      // final studentDetails =
      //     (context.read<AuthCubit>().getParentDetails().children ?? [])
      //         .where((element) => element.id == widget.childId)
      //         .first;

      // getStudentClassDetails = studentDetails.classSection?.fullName ?? "";
    } else {
      // getStudentClassDetails = context
      //         .read<AuthCubit>()
      //         .getStudentDetails()
      //         .classSection
      //         ?.fullName ??
      //     "";
    }
    return ScreenTopBackgroundContainer(
      heightPercentage: Utils.appBarMediumtHeightPercentage,
      child: Stack(
        clipBehavior: Clip.none,
        children: [
          widget.childId == null ? const SizedBox() : const CustomBackButton(),
          Align(
            alignment: Alignment.topCenter,
            child: Text(
              Utils.getTranslatedLabel(timeTableKey),
              style: TextStyle(
                color: Theme.of(context).scaffoldBackgroundColor,
                fontSize: Utils.screenTitleFontSize,
              ),
            ),
          ),
          Positioned(
            bottom: -20,
            left: MediaQuery.of(context).size.width * (0.075),
            child: Container(
              alignment: Alignment.center,
              height: 50,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(10),
                boxShadow: [
                  BoxShadow(
                    color: Theme.of(context)
                        .colorScheme
                        .secondary
                        .withValues(alpha: 0.075),
                    offset: const Offset(2.5, 2.5),
                    blurRadius: 5,
                  )
                ],
                color: Theme.of(context).scaffoldBackgroundColor,
              ),
              width: MediaQuery.of(context).size.width * (0.85),
              child: Text(
                "${Utils.getTranslatedLabel(classKey)} - $getStudentClassDetails",
                style: TextStyle(
                  color: Theme.of(context).colorScheme.secondary,
                  fontWeight: FontWeight.w600,
                ),
                textAlign: TextAlign.center,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildDayContainer(int index) {
    return InkWell(
      onTap: () {
        setState(() {
          _currentSelectedDayIndex = index;
        });
      },
      borderRadius: BorderRadius.circular(5.0),
      child: Container(
        alignment: Alignment.center,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(5.0),
          color: index == _currentSelectedDayIndex
              ? Theme.of(context).colorScheme.primary
              : Colors.transparent,
        ),
        margin: EdgeInsetsDirectional.only(end: 12.5),
        padding: const EdgeInsets.all(7.5),
        child: Text(
          Utils.getTranslatedLabel(Utils.weekDays[index]),
          style: TextStyle(
            fontSize: 13.0,
            fontWeight: FontWeight.w600,
            color: index == _currentSelectedDayIndex
                ? Theme.of(context).scaffoldBackgroundColor
                : Theme.of(context).colorScheme.primary,
          ),
        ),
      ),
    );
  }

  Widget _buildDays() {
    final List<Widget> children = [];

    for (var i = 0; i < Utils.weekDays.length; i++) {
      children.add(_buildDayContainer(i));
    }

    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      padding: EdgeInsetsDirectional.symmetric(
          horizontal: MediaQuery.of(context).size.width * (0.075)),
      child: Row(
        children: children,
      ),
    );
  }

  Widget _buildTimeTableSlotDetailsContainer({
    required TimeTableSlot timeTableSlot,
  }) {
    ///[If the subject name is empty then it will consider as break]
    final isBreak =
        timeTableSlot.subject.getSubjectName(context: context).isEmpty;
    final double imageWidth = MediaQuery.of(context).size.width * (0.175);
    final double imageHeight = 60;

    return Container(
      margin: const EdgeInsets.only(bottom: 20),
      decoration: BoxDecoration(
        boxShadow: [
          BoxShadow(
            color: Theme.of(context).colorScheme.secondary.withValues(alpha: 0.075),
            offset: const Offset(4, 4),
            blurRadius: 10,
          )
        ],
        color: Theme.of(context).scaffoldBackgroundColor,
        borderRadius: BorderRadius.circular(10),
      ),
      width: MediaQuery.of(context).size.width * (0.85),
      padding: const EdgeInsets.symmetric(horizontal: 12.5, vertical: 10.0),
      child: Row(
        children: [
          isBreak
              ? Container(
                  height: 60,
                  width: MediaQuery.of(context).size.width * (0.175),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(7.5),
                    color: Theme.of(context).colorScheme.primary,
                  ),
                  padding: EdgeInsets.symmetric(
                    horizontal: imageWidth * (0.15),
                    vertical: imageHeight * 0.15,
                  ),
                  child: SvgPicture.asset(
                    Utils.getImagePath("lunch-time.svg"),
                    colorFilter: ColorFilter.mode(
                        Theme.of(context).scaffoldBackgroundColor,
                        BlendMode.srcIn),
                  ),
                )
              : SubjectImageContainer(
                  showShadow: false,
                  height: imageHeight,
                  width: imageWidth,
                  radius: 7.5,
                  subject: Module(moduleName:"", moduleId: "", moduleCode: "", moduleUnitCode: "", periodId: periodId, isEvaluable: isEvaluable, pastExamPapers: pastExamPapers, vleStatus: vleStatus),
                ),
          const SizedBox(
            width: 20,
          ),
          Flexible(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  "${Utils.formatTime(timeTableSlot.startTime)} - ${Utils.formatTime(timeTableSlot.endTime)}",
                  style: TextStyle(
                    color: Theme.of(context).colorScheme.secondary,
                    fontWeight: FontWeight.w600,
                    fontSize: 14.0,
                  ),
                ),
                Text(
                  timeTableSlot.subject.getSubjectName(context: context).isEmpty
                      ? timeTableSlot.note
                      : timeTableSlot.subject.getSubjectName(context: context),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: TextStyle(
                    color: Theme.of(context).colorScheme.onSurface,
                    fontWeight: FontWeight.w400,
                    fontSize: 12.0,
                  ),
                ),
                Text(
                  "${timeTableSlot.teacherFirstName} ${timeTableSlot.teacherLastName}",
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: TextStyle(
                    color: Theme.of(context).colorScheme.onSurface,
                    fontWeight: FontWeight.w400,
                    fontSize: 12.0,
                  ),
                )
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildTimeTable() {
    return BlocBuilder<TimeTableCubit, TimeTableState>(
      builder: (context, state) {
        if (state is TimeTableFetchSuccess) {
          final timetableSlots = _buildTimeTableSlots(state.timeTable);
          return SizedBox(
            width: MediaQuery.of(context).size.width,
            child: timetableSlots.isEmpty
                ? NoDataContainer(
                    key: isApplicationItemAnimationOn ? UniqueKey() : null,
                    titleKey: noLecturesKey,
                  )
                : Column(
                    children: List.generate(
                      timetableSlots.length,
                      (index) => Animate(
                        key: isApplicationItemAnimationOn ? UniqueKey() : null,
                        effects: listItemAppearanceEffects(
                          itemIndex: index,
                          totalLoadedItems: timetableSlots.length,
                        ),
                        child: _buildTimeTableSlotDetailsContainer(
                          timeTableSlot: timetableSlots[index],
                        ),
                      ),
                    ),
                  ),
          );
        }
        if (state is TimeTableFetchFailure) {
          return ErrorContainer(
            key: isApplicationItemAnimationOn ? UniqueKey() : null,
            errorMessageCode: state.errorMessage,
            onTapRetry: () {
              context.read<TimeTableCubit>().fetchStudentTimeTable(
                    useParentApi: context.read<AuthCubit>().isParent(),
                    childId: widget.childId,
                  );
            },
          );
        }

        return _buildTimeTableLoading();
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Align(
          alignment: Alignment.topCenter,
          child: SingleChildScrollView(
            padding: EdgeInsets.only(
              bottom: Utils.getScrollViewBottomPadding(context),
              top: Utils.getScrollViewTopPadding(
                context: context,
                appBarHeightPercentage: Utils.appBarMediumtHeightPercentage,
              ),
            ),
            child: Column(
              children: [
                SizedBox(
                  height: MediaQuery.of(context).size.height * (0.025),
                ),
                _buildDays(),
                SizedBox(
                  height: MediaQuery.of(context).size.height * (0.025),
                ),
                _buildTimeTable(),
              ],
            ),
          ),
        ),
        Align(
          alignment: Alignment.topCenter,
          child: _buildAppBar(),
        ),
      ],
    );
  }
}
