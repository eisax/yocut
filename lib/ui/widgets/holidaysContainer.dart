import 'package:yocut/cubits/authCubit.dart';
import 'package:yocut/cubits/holidaysCubit.dart';
import 'package:yocut/cubits/schoolConfigurationCubit.dart';
import 'package:yocut/data/models/holiday.dart';
import 'package:yocut/ui/widgets/changeCalendarMonthButton.dart';
import 'package:yocut/ui/widgets/customBackButton.dart';
import 'package:yocut/ui/widgets/customShimmerContainer.dart';
import 'package:yocut/ui/widgets/errorContaineer.dart';
import 'package:yocut/ui/widgets/screenTopBackgroundContainer.dart';
import 'package:yocut/ui/widgets/shimmerLoadingContainer.dart';
import 'package:yocut/utils/animationConfiguration.dart';
import 'package:yocut/utils/constants.dart';
import 'package:yocut/utils/labelKeys.dart';
import 'package:yocut/utils/utils.dart';
import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:table_calendar/table_calendar.dart';

class HolidaysContainer extends StatefulWidget {
  final int? childId;
  const HolidaysContainer({super.key, this.childId});

  @override
  State<HolidaysContainer> createState() => _HolidaysContainerState();
}

class _HolidaysContainerState extends State<HolidaysContainer> {
  //last and first day of calendar
  late DateTime firstDay = DateTime.now();
  late DateTime lastDay = DateTime.now();

  //current day
  late DateTime focusedDay = DateTime.now();
  late List<Holiday> holidays = [];
  PageController? calendarPageController;

  @override
  void initState() {
    Future.delayed(Duration.zero, () {
      context.read<HolidaysCubit>().fetchHolidays(childId: widget.childId);
    });
    super.initState();
  }

  void updateMonthViceHolidays() {
    holidays.clear();
    for (final holiday in context.read<HolidaysCubit>().holidays()) {
      if (holiday.date.month == focusedDay.month &&
          holiday.date.year == focusedDay.year) {
        holidays.add(holiday);
      }
    }

    holidays.sort((first, second) => first.date.compareTo(second.date));
    setState(() {});
  }

  Widget _buildHolidayDetailsList() {
    return Column(
      children: List.generate(
        holidays.length,
        (index) => Animate(
          key: isApplicationItemAnimationOn ? UniqueKey() : null,
          effects: listItemAppearanceEffects(
              itemIndex: index, totalLoadedItems: holidays.length),
          child: Container(
            margin: const EdgeInsets.only(bottom: 15),
            padding:
                const EdgeInsets.symmetric(horizontal: 15.0, vertical: 7.5),
            width: MediaQuery.of(context).size.width * (0.85),
            decoration: BoxDecoration(
              color: Theme.of(context).colorScheme.surface,
              borderRadius: BorderRadius.circular(10.0),
            ),
            child: LayoutBuilder(
              builder: (context, boxConstraints) {
                return Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Expanded(
                          child: Text(
                            holidays[index].title,
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                            style: TextStyle(
                              color: Theme.of(context).colorScheme.secondary,
                              fontWeight: FontWeight.w600,
                              fontSize: 14.0,
                            ),
                          ),
                        ),
                        Text(
                          Utils.formatDate(holidays[index].date),
                          style: TextStyle(
                            color: Theme.of(context).colorScheme.onSurface,
                            fontSize: 12.0,
                          ),
                        ),
                      ],
                    ),
                    SizedBox(
                      height: holidays[index].description.isEmpty ? 0 : 2.5,
                    ),
                    holidays[index].description.isEmpty
                        ? const SizedBox()
                        : Text(
                            holidays[index].description,
                            style: TextStyle(
                              color: Theme.of(context).colorScheme.onSurface,
                              fontSize: 11.5,
                            ),
                          )
                  ],
                );
              },
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildCalendarContainer() {
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
          updateMonthViceHolidays();
          //
        },

        onCalendarCreated: (contoller) {
          calendarPageController = contoller;
        },

        holidayPredicate: (dateTime) {
          return holidays.indexWhere(
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
            color: Theme.of(context).colorScheme.primary,
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

  Widget _buildHolidaysCalendar() {
    return Align(
      alignment: Alignment.topCenter,
      child: SingleChildScrollView(
        padding: EdgeInsets.only(
          left: MediaQuery.of(context).size.width *
              Utils.screenContentHorizontalPaddingInPercentage,
          right: MediaQuery.of(context).size.width *
              Utils.screenContentHorizontalPaddingInPercentage,
          bottom: Utils.getScrollViewBottomPadding(context),
          top: Utils.getScrollViewTopPadding(
            context: context,
            appBarHeightPercentage: Utils.appBarMediumtHeightPercentage,
          ),
        ),
        child: BlocConsumer<HolidaysCubit, HolidaysState>(
          listener: (context, state) {
            if (state is HolidaysFetchSuccess) {
              // print(context
              //     .read<SchoolConfigurationCubit>()
              //     .getSchoolConfiguration()
              //     .sessionYear
              //     .toJson());
              if (Utils.isTodayInSessionYear(
                context
                    .read<SchoolConfigurationCubit>()
                    .getSchoolConfiguration()
                    .sessionYear
                    .getStartDateInDateTime(),
                context
                    .read<SchoolConfigurationCubit>()
                    .getSchoolConfiguration()
                    .sessionYear
                    .getEndDateInDateTime(),
              )) {
                firstDay = context
                    .read<SchoolConfigurationCubit>()
                    .getSchoolConfiguration()
                    .sessionYear
                    .getStartDateInDateTime();
                lastDay = context
                    .read<SchoolConfigurationCubit>()
                    .getSchoolConfiguration()
                    .sessionYear
                    .getEndDateInDateTime();

                setState(() {});
                updateMonthViceHolidays();
              }
            }
          },
          builder: (context, state) {
            if (state is HolidaysFetchSuccess) {
              return Column(
                children: [
                  _buildCalendarContainer(),
                  SizedBox(
                    height: MediaQuery.of(context).size.height * (0.025),
                  ),
                  _buildHolidayDetailsList()
                ],
              );
            }

            if (state is HolidaysFetchFailure) {
              return Center(
                child: ErrorContainer(
                  errorMessageCode: state.errorMessage,
                  onTapRetry: () {
                    context
                        .read<HolidaysCubit>()
                        .fetchHolidays(childId: widget.childId);
                  },
                ),
              );
            }
            return Column(
              children: [
                const SizedBox(
                  height: 20,
                ),
                ShimmerLoadingContainer(
                  child: CustomShimmerContainer(
                    height: MediaQuery.of(context).size.height * (0.425),
                  ),
                ),
              ],
            );
          },
        ),
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
              Utils.getTranslatedLabel(holidaysKey),
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
                      "${Utils.getMonthName(focusedDay.month)} ${focusedDay.year}",
                      style: TextStyle(
                        color: Theme.of(context).colorScheme.secondary,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                  Align(
                    alignment: AlignmentDirectional.centerStart,
                    child: ChangeCalendarMonthButton(
                      onTap: () {
                        if (context.read<HolidaysCubit>().state
                            is HolidaysFetchInProgress) {
                          return;
                        }

                        calendarPageController?.previousPage(
                          duration: const Duration(milliseconds: 400),
                          curve: Curves.easeInOut,
                        );
                      },
                      isDisable: false,
                      isNextButton: false,
                    ),
                  ),
                  Align(
                    alignment: AlignmentDirectional.centerEnd,
                    child: ChangeCalendarMonthButton(
                      onTap: () {
                        if (context.read<HolidaysCubit>().state
                            is HolidaysFetchInProgress) {
                          return;
                        }

                        calendarPageController?.nextPage(
                          duration: const Duration(milliseconds: 400),
                          curve: Curves.easeInOut,
                        );
                      },
                      isDisable: false,
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

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        _buildHolidaysCalendar(),
        _buildAppBar(),
      ],
    );
  }
}
