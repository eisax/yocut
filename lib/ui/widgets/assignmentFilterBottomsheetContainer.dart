import 'package:yocut/ui/widgets/assignmentsContainer.dart';
import 'package:yocut/utils/labelKeys.dart';
import 'package:yocut/utils/utils.dart';
import 'package:flutter/material.dart';

class AssignmentFilterBottomsheetContainer extends StatefulWidget {
  final AssignmentFilters initialAssignmentFilterValue;
  final Function changeAssignmentFilter;
  const AssignmentFilterBottomsheetContainer({
    super.key,
    required this.initialAssignmentFilterValue,
    required this.changeAssignmentFilter,
  });

  @override
  State<AssignmentFilterBottomsheetContainer> createState() =>
      _AssignmentFilterBottomsheetContainerState();
}

class _AssignmentFilterBottomsheetContainerState
    extends State<AssignmentFilterBottomsheetContainer> {
  late AssignmentFilters _currentlySelectedAssignmentFilterValue =
      widget.initialAssignmentFilterValue;

  Widget _buildAssignmentFilterTile({
    required String title,
    required AssignmentFilters assignmentFilter,
  }) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 10.0),
      child: GestureDetector(
        onTap: () {
          setState(() {
            _currentlySelectedAssignmentFilterValue = assignmentFilter;
          });
          widget.changeAssignmentFilter(assignmentFilter);
        },
        child: Row(
          children: [
            Container(
              padding: const EdgeInsets.all(2),
              width: 20,
              height: 20,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                border: Border.all(
                  color: Theme.of(context).colorScheme.primary,
                  width: 1.75,
                ),
              ),
              child: Container(
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: _currentlySelectedAssignmentFilterValue ==
                          assignmentFilter
                      ? Theme.of(context).colorScheme.primary
                      : Theme.of(context).scaffoldBackgroundColor,
                ),
              ),
            ),
            const SizedBox(
              width: 15,
            ),
            Text(
              title,
              style: TextStyle(
                fontSize: 14,
                color: Theme.of(context).colorScheme.secondary,
              ),
            )
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(
        horizontal: MediaQuery.of(context).size.width * (0.075),
        vertical: MediaQuery.of(context).size.height * (0.05),
      ),
      width: MediaQuery.of(context).size.width,
      decoration: BoxDecoration(
        color: Theme.of(context).scaffoldBackgroundColor,
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(Utils.bottomSheetTopRadius),
          topRight: Radius.circular(Utils.bottomSheetTopRadius),
        ),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            Utils.getTranslatedLabel(sortByKey),
            style: TextStyle(
              fontSize: 16.0,
              color: Theme.of(context).colorScheme.secondary,
              fontWeight: FontWeight.bold,
            ),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 10.0),
            child: Divider(
              color: Theme.of(context).colorScheme.onSurface,
            ),
          ),
          _buildAssignmentFilterTile(
            title: Utils.getTranslatedLabel(assignedDateLatestKey),
            assignmentFilter: AssignmentFilters.assignedDateLatest,
          ),
          _buildAssignmentFilterTile(
            title: Utils.getTranslatedLabel(assignedDateOldestKey),
            assignmentFilter: AssignmentFilters.assignedDateOldest,
          ),
          _buildAssignmentFilterTile(
            title: Utils.getTranslatedLabel(dueDateLatestKey),
            assignmentFilter: AssignmentFilters.dueDateLatest,
          ),
          _buildAssignmentFilterTile(
            title: Utils.getTranslatedLabel(dueDateOldestKey),
            assignmentFilter: AssignmentFilters.dueDateOldest,
          ),
        ],
      ),
    );
  }
}
