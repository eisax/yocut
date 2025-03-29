import 'package:yocut/utils/constants.dart';
import 'package:yocut/utils/utils.dart';
import 'package:flutter/material.dart';

class ExamFiltersContainer extends StatefulWidget {
  final Function(int) onTapSubject;
  final int selectedExamFilterIndex;

  const ExamFiltersContainer({
    Key? key,
    required this.onTapSubject,
    required this.selectedExamFilterIndex,
  }) : super(key: key);

  @override
  State<ExamFiltersContainer> createState() => _ExamFiltersContainerState();
}

class _ExamFiltersContainerState extends State<ExamFiltersContainer> {
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
              _scrollController.animateTo(
                _scrollController.offset +
                    (index > widget.selectedExamFilterIndex ? 1 : -1) *
                        MediaQuery.of(context).size.width *
                        (0.2),
                duration: const Duration(milliseconds: 300),
                curve: Curves.easeInOut,
              );

              widget.onTapSubject(index);
            },
            child: Container(
              margin: const EdgeInsetsDirectional.only(end: 20.0),
              decoration: BoxDecoration(
                color: widget.selectedExamFilterIndex == index
                    ? Theme.of(context).colorScheme.primary
                    : Colors.transparent,
                borderRadius: BorderRadius.circular(10),
              ),
              padding: const EdgeInsets.symmetric(horizontal: 15),
              alignment: Alignment.center,
              child: Text(
                Utils.getTranslatedLabel(examFilters[index]),
                style: TextStyle(
                  color: widget.selectedExamFilterIndex == index
                      ? Theme.of(context).scaffoldBackgroundColor
                      : Theme.of(context).colorScheme.onSurface,
                ),
              ),
            ),
          );
        },
        itemCount: examFilters.length,
        scrollDirection: Axis.horizontal,
        padding: EdgeInsets.symmetric(
          horizontal: MediaQuery.of(context).size.width * (0.1),
        ),
      ),
    );
  }
}
