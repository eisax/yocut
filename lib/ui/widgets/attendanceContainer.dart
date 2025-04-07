import 'package:yocut/cubits/attendanceCubit.dart';
import 'package:yocut/cubits/authCubit.dart';
import 'package:yocut/data/models/attendanceDay.dart';
import 'package:yocut/ui/widgets/changeCalendarMonthButton.dart';
import 'package:yocut/ui/widgets/customBackButton.dart';
import 'package:yocut/ui/widgets/customShimmerContainer.dart';
import 'package:yocut/ui/widgets/errorContaineer.dart';
import 'package:yocut/ui/widgets/screenTopBackgroundContainer.dart';
import 'package:yocut/ui/widgets/shimmerLoadingContainer.dart';

import 'package:yocut/utils/labelKeys.dart';
import 'package:yocut/utils/utils.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:table_calendar/table_calendar.dart';

class AttendanceContainer extends StatefulWidget {
  final int? childId;
  const AttendanceContainer({super.key, this.childId});

  @override
  State<AttendanceContainer> createState() => _AttendanceContainerState();
}

class _AttendanceContainerState extends State<AttendanceContainer> {
  //last and first day of calendar
  late DateTime firstDay = DateTime.now();
  late DateTime lastDay = DateTime.now();

  //current day
  late DateTime focusedDay = DateTime.now();

  PageController? calendarPageController;

  @override
  void initState() {
    Future.delayed(Duration.zero, () {
      //fetch attendacne
      context.read<AttendanceCubit>().fetchAttendance(
            month: DateTime.now().month,
            year: DateTime.now().year,
            useParentApi: context.read<AuthCubit>().isParent(),
            childId: widget.childId,
          );
    });

    super.initState();
  }

  bool _disableChangeNextMonthButton() {
    return focusedDay.year == DateTime.now().year &&
        focusedDay.month == DateTime.now().month;
  }

  Widget _buildShimmerAttendanceCounterContainer(
    BoxConstraints boxConstraints,
  ) {
    return ShimmerLoadingContainer(
      child: CustomShimmerContainer(
        height: boxConstraints.maxWidth * (0.425),
        width: boxConstraints.maxWidth * (0.425),
      ),
    );
  }

  Widget _buildAttendanceCounterContainer({
    required String title,
    required BoxConstraints boxConstraints,
    required String value,
    required Color backgroundColor,
  }) {
    return Container(
      height: boxConstraints.maxWidth * (0.425),
      width: boxConstraints.maxWidth * (0.425),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(10),
        color: backgroundColor,
        boxShadow: [
          BoxShadow(
            color: backgroundColor.withValues(alpha: 0.25),
            offset: const Offset(5, 5),
            blurRadius: 10,
          )
        ],
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(
            title,
            style: TextStyle(
              color: Theme.of(context).scaffoldBackgroundColor,
              fontWeight: FontWeight.w600,
            ),
          ),
          SizedBox(
            height: boxConstraints.maxWidth * (0.45) * (0.125),
          ),
          CircleAvatar(
            radius: 25,
            backgroundColor: Theme.of(context).scaffoldBackgroundColor,
            child: Center(
              child: Text(
                value,
                style: TextStyle(
                  color: backgroundColor,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildAppBar() {
    return ScreenTopBackgroundContainer(
      heightPercentage: Utils.appBarMediumtHeightPercentage,
      child: Stack(
        clipBehavior: Clip.none,
        children: [
          context.read<AuthCubit>().isParent()
              ? const CustomBackButton()
              : const SizedBox(),
          Align(
            alignment: Alignment.topCenter,
            child: Text(
              Utils.getTranslatedLabel(attendanceKey),
              style: TextStyle(
                color: Theme.of(context).scaffoldBackgroundColor,
                fontSize: Utils.screenTitleFontSize,
              ),
            ),
          ),
          PositionedDirectional(
            bottom: -20,
            start: MediaQuery.of(context).size.width * (0.075),
            child: Container(
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
              child: Stack(
                children: [
                  Align(
                    child: Text(
                      "${Utils.getTranslatedLabel(Utils.getMonthName(focusedDay.month))} ${focusedDay.year}",
                      style: TextStyle(
                        color: Theme.of(context).colorScheme.secondary,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                  Align(
                    alignment: AlignmentDirectional.centerStart,
                    child: ChangeCalendarMonthButton(
                      isDisable: false,
                      isNextButton: false,
                      onTap: () {
                        if (context.read<AttendanceCubit>().state
                            is AttendanceFetchInProgress) {
                          return;
                        }

                        calendarPageController?.previousPage(
                          duration: const Duration(milliseconds: 400),
                          curve: Curves.easeInOut,
                        );
                      },
                    ),
                  ),
                  Align(
                    alignment: AlignmentDirectional.centerEnd,
                    child: ChangeCalendarMonthButton(
                      onTap: () {
                        if (context.read<AttendanceCubit>().state
                            is AttendanceFetchInProgress) {
                          return;
                        }
                        if (_disableChangeNextMonthButton()) {
                          return;
                        }
                        calendarPageController?.nextPage(
                          duration: const Duration(milliseconds: 400),
                          curve: Curves.easeInOut,
                        );
                      },
                      isDisable: _disableChangeNextMonthButton(),
                      isNextButton: true,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildCalendarContainer({
    required List<AttendanceDay> presentDays,
    required List<AttendanceDay> absentDays,
  }) {
    return Container(
      padding: const EdgeInsets.all(5),
      decoration: BoxDecoration(
        color: Theme.of(context).scaffoldBackgroundColor,
        boxShadow: [
          BoxShadow(
            color: Theme.of(context).colorScheme.secondary.withValues(alpha: 0.075),
            offset: const Offset(5.0, 5),
            blurRadius: 10,
          )
        ],
        borderRadius: BorderRadius.circular(15.0),
      ),
      margin: const EdgeInsets.only(top: 20),
      child: TableCalendar(
        headerVisible: false,
        daysOfWeekHeight: 40,

        onPageChanged: (DateTime dateTime) {
          setState(() {
            focusedDay = dateTime;
          });

          //fetch attendance by year and month
          context.read<AttendanceCubit>().fetchAttendance(
                month: dateTime.month,
                year: dateTime.year,
                useParentApi: context.read<AuthCubit>().isParent(),
                childId: widget.childId,
              );
        },

        onCalendarCreated: (contoller) {
          calendarPageController = contoller;
        },

        //holiday date will be in use to make present dates
        holidayPredicate: (dateTime) {
          return presentDays.indexWhere(
                (element) {
                  return Utils.formatDate(dateTime) ==
                      Utils.formatDate(element.date);
                },
              ) !=
              -1;
        },

        //selected date will be in use to mark absent dates
        selectedDayPredicate: (dateTime) {
          return absentDays.indexWhere(
                (element) =>
                    Utils.formatDate(dateTime) ==
                    Utils.formatDate(element.date),
              ) !=
              -1;
        },
        availableGestures: AvailableGestures.none,

        calendarStyle: CalendarStyle(
          isTodayHighlighted: false,
          holidayTextStyle:
              TextStyle(color: Theme.of(context).scaffoldBackgroundColor),
          holidayDecoration: BoxDecoration(
            shape: BoxShape.circle,
            color: Theme.of(context).colorScheme.onPrimary,
          ),
          selectedDecoration: BoxDecoration(
            shape: BoxShape.circle,
            color: Theme.of(context).colorScheme.error,
          ),
        ),
        daysOfWeekStyle: DaysOfWeekStyle(
          weekendStyle: TextStyle(
            color: Theme.of(context).colorScheme.primary,
            fontWeight: FontWeight.bold,
          ),
          weekdayStyle: TextStyle(
            color: Theme.of(context).colorScheme.primary,
            fontWeight: FontWeight.bold,
          ),
        ),
        headerStyle:
            const HeaderStyle(titleCentered: true, formatButtonVisible: false),
        firstDay: firstDay, //start education year
        lastDay: lastDay, //end education year
        focusedDay: focusedDay,
      ),
    );
  }

  Widget _buildAttendaceCalendar() {
    return SingleChildScrollView(
      padding: EdgeInsets.only(
        bottom: Utils.getScrollViewBottomPadding(context),
        top: Utils.getScrollViewTopPadding(
          context: context,
          appBarHeightPercentage: Utils.appBarMediumtHeightPercentage,
        ),
      ),
      child: Column(
        children: [
          BlocConsumer<AttendanceCubit, AttendanceState>(
            listener: (context, state) {
              if (state is AttendanceFetchSuccess) {
                //if current day falls into session year calendar then change the
                //start and end date
                if (Utils.isTodayInSessionYear(
                  state.sessionYear.getStartDateInDateTime(),
                  state.sessionYear.getEndDateInDateTime(),
                )) {
                  lastDay = state.sessionYear.getEndDateInDateTime();
                  firstDay = state.sessionYear.getStartDateInDateTime();
                  setState(() {});
                }
              }
            },
            builder: (context, state) {
              if (state is AttendanceFetchSuccess) {
                //filter out the present and absent days
                List<AttendanceDay> presentDays = state.attendanceDays
                    .where((element) => element.type == 1)
                    .toList();
                List<AttendanceDay> absentDays = state.attendanceDays
                    .where((element) => element.type == 0)
                    .toList();

                return Padding(
                  padding: EdgeInsets.symmetric(
                    horizontal: MediaQuery.of(context).size.width * (0.075),
                  ),
                  child: Column(
                    children: [
                      _buildCalendarContainer(
                        presentDays: presentDays,
                        absentDays: absentDays,
                      ),
                      SizedBox(
                        height: MediaQuery.of(context).size.height * (0.05),
                      ),
                      LayoutBuilder(
                        builder: (context, boxConstraints) {
                          return Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              _buildAttendanceCounterContainer(
                                boxConstraints: boxConstraints,
                                title: Utils.getTranslatedLabel(
                                  totalPresentKey,
                                ),
                                value: presentDays.length.toString(),
                                backgroundColor:
                                    Theme.of(context).colorScheme.onPrimary,
                              ),
                              const Spacer(),
                              _buildAttendanceCounterContainer(
                                boxConstraints: boxConstraints,
                                title: Utils.getTranslatedLabel(
                                  totalAbsentKey,
                                ),
                                value: absentDays.length.toString(),
                                backgroundColor:
                                    Theme.of(context).colorScheme.error,
                              ),
                            ],
                          );
                        },
                      )
                    ],
                  ),
                );
              }
              if (state is AttendanceFetchFailure) {
                return ErrorContainer(
                  errorMessageCode: state.errorMessage,
                  showErrorImage: false,
                  onTapRetry: () {
                    context.read<AttendanceCubit>().fetchAttendance(
                          month: focusedDay.month,
                          year: focusedDay.year,
                          useParentApi: context.read<AuthCubit>().isParent(),
                          childId: widget.childId,
                        );
                  },
                );
              }

              return Padding(
                padding: EdgeInsets.symmetric(
                  horizontal: MediaQuery.of(context).size.width * (0.075),
                ),
                child: LayoutBuilder(
                  builder: (context, boxConstraints) {
                    return Column(
                      children: [
                        const SizedBox(
                          height: 20,
                        ),
                        ShimmerLoadingContainer(
                          child: CustomShimmerContainer(
                            width: boxConstraints.maxWidth,
                            height:
                                MediaQuery.of(context).size.height * (0.425),
                          ),
                        ),
                        SizedBox(
                          height: MediaQuery.of(context).size.height * (0.05),
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            _buildShimmerAttendanceCounterContainer(
                              boxConstraints,
                            ),
                            const Spacer(),
                            _buildShimmerAttendanceCounterContainer(
                              boxConstraints,
                            )
                          ],
                        ),
                      ],
                    );
                  },
                ),
              );
            },
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        _buildAttendaceCalendar(),
        _buildAppBar(),
      ],
    );
  }
}
