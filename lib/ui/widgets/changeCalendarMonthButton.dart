import 'package:flutter/material.dart';

class ChangeCalendarMonthButton extends StatelessWidget {
  final Function onTap;
  final bool isDisable;
  final bool isNextButton;
  const ChangeCalendarMonthButton({
    super.key,
    required this.onTap,
    required this.isDisable,
    required this.isNextButton,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        onTap.call();
      },
      child: Container(
        margin: EdgeInsetsDirectional.only(
          end: isNextButton ? 15.0 : 0,
          start: isNextButton ? 0 : 15.0,
        ),
        width: 40.0,
        height: 40.0,
        decoration: BoxDecoration(
          border: Border.all(color: Colors.transparent),
          color: Theme.of(context)
              .colorScheme
              .primary
              .withValues(alpha: isDisable ? 0.75 : 1.0),
          borderRadius: BorderRadius.circular(7.5),
        ),
        child: Icon(
          isNextButton ? Icons.chevron_right : Icons.chevron_left,
          size: 30,
          color: Theme.of(context)
              .scaffoldBackgroundColor
              .withValues(alpha: isDisable ? 0.75 : 1.0),
        ),
      ),
    );
  }
}
