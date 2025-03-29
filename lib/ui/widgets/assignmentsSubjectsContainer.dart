import 'package:yocut/cubits/assignmentsCubit.dart';
import 'package:yocut/cubits/examsOnlineCubit.dart';
import 'package:yocut/cubits/resultsCubit.dart';
import 'package:yocut/data/models/subject.dart';
import 'package:yocut/utils/labelKeys.dart';
import 'package:yocut/utils/utils.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

//It must be child of AssignmentsCibit
class AssignmentsSubjectContainer extends StatefulWidget {
  final List<Subject> subjects;
  final Function(int) onTapSubject;
  final int selectedClassSubjectId;
  final String cubitAndState;

  const AssignmentsSubjectContainer({
    Key? key,
    required this.subjects,
    required this.onTapSubject,
    required this.selectedClassSubjectId,
    required this.cubitAndState,
  }) : super(key: key);

  @override
  State<AssignmentsSubjectContainer> createState() =>
      _AssignmentsSubjectContainerState();
}

class _AssignmentsSubjectContainerState
    extends State<AssignmentsSubjectContainer> {
  late final ScrollController _scrollController = ScrollController();

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 40,
      child: ListView.builder(
        controller: _scrollController,
        itemBuilder: (context, index) {
          return GestureDetector(
            onTap: () {
              if (widget.cubitAndState == "onlineExam") {
                if (context.read<ExamsOnlineCubit>().state
                    is ExamsOnlineFetchInProgress) {
                  return;
                }
              } else if (widget.cubitAndState == "onlineResult") {
                //change cubit later - according to Online Result
                if (context.read<ResultsCubit>().state
                    is ResultsFetchInProgress) {
                  return;
                }
              } else {
                if (context.read<AssignmentsCubit>().state
                    is AssignmentsFetchInProgress) {
                  return;
                }
              }

              if (widget.subjects[index].classSubjectId ==
                  widget.selectedClassSubjectId) {
                return;
              }

              final subjectIdIndex = widget.subjects.indexWhere(
                (element) =>
                    widget.subjects[index].classSubjectId ==
                    element.classSubjectId,
              );

              final selectedSubjectIdIndex = widget.subjects.indexWhere(
                (element) =>
                    widget.selectedClassSubjectId == element.classSubjectId,
              );

              _scrollController.animateTo(
                _scrollController.offset +
                    (subjectIdIndex > selectedSubjectIdIndex ? 1 : -1) *
                        MediaQuery.of(context).size.width *
                        (0.2),
                duration: const Duration(milliseconds: 300),
                curve: Curves.easeInOut,
              );

              //

              widget.onTapSubject(widget.subjects[index].classSubjectId ?? 0);
            },
            child: Container(
              margin: const EdgeInsetsDirectional.only(end: 20.0),
              decoration: BoxDecoration(
                color: widget.selectedClassSubjectId ==
                        widget.subjects[index].classSubjectId
                    ? Theme.of(context).colorScheme.primary
                    : Colors.transparent,
                borderRadius: BorderRadius.circular(10),
              ),
              padding: const EdgeInsets.symmetric(horizontal: 15),
              alignment: Alignment.center,
              child: Text(
                widget.subjects[index].classSubjectId == 0
                    ? Utils.getTranslatedLabel(allSubjectsKey)
                    : widget.subjects[index].getSubjectName(context: context),
                style: TextStyle(
                  color: widget.selectedClassSubjectId ==
                          widget.subjects[index].classSubjectId
                      ? Theme.of(context).scaffoldBackgroundColor
                      : Theme.of(context).colorScheme.onSurface,
                ),
              ),
            ),
          );
        },
        itemCount: widget.subjects.length,
        scrollDirection: Axis.horizontal,
        padding: EdgeInsets.symmetric(
          horizontal: MediaQuery.of(context).size.width * (0.1),
        ),
      ),
    );
  }
}
