import 'package:yocut/utils/utils.dart';
import 'package:flutter/material.dart';

class CustomTabBarContainer extends StatelessWidget {
  final BoxConstraints boxConstraints;
  final AlignmentGeometry alignment;
  final bool isSelected;
  final String titleKey;
  final Function onTap;
  const CustomTabBarContainer({
    super.key,
    required this.boxConstraints,
    required this.alignment,
    required this.isSelected,
    required this.onTap,
    required this.titleKey,
  });

  @override
  Widget build(BuildContext context) {
    return Align(
      alignment: alignment,
      child: GestureDetector(
        onTap: () {
          onTap();
        },
        child: Container(
          decoration:
              BoxDecoration(border: Border.all(color: Colors.transparent)),
          alignment: Alignment.center,
          margin: EdgeInsets.only(
            left: boxConstraints.maxWidth * (0.1),
            right: boxConstraints.maxWidth * (0.1),
            top: boxConstraints.maxHeight * (0.125),
          ),
          height: boxConstraints.maxHeight * (0.325),
          width: boxConstraints.maxWidth * (0.375),
          child: AnimatedDefaultTextStyle(
            curve: Curves.easeInOut,
            duration: const Duration(milliseconds: 300),
            style: TextStyle(
              fontSize: 15.0,
              fontWeight: FontWeight.w600,
              color: isSelected
                  ? Theme.of(context).colorScheme.onSurface
                  : Theme.of(context).scaffoldBackgroundColor,
            ),
            child: Text(
              Utils.getTranslatedLabel(titleKey),
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
            ),
          ),
        ),
      ),
    );
  }
}
