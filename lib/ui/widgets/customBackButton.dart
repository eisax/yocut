import 'package:yocut/ui/widgets/svgButton.dart';
import 'package:yocut/utils/utils.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class CustomBackButton extends StatelessWidget {
  final Function? onTap;
  final double? topPadding;
  final AlignmentDirectional? alignmentDirectional;
  const CustomBackButton({
    super.key,
    this.onTap,
    this.topPadding,
    this.alignmentDirectional,
  });

  @override
  Widget build(BuildContext context) {
    return Align(
      alignment: alignmentDirectional ?? AlignmentDirectional.topStart,
      child: Padding(
        padding: EdgeInsetsDirectional.only(
          top: topPadding ?? 0,
          start: Utils.screenContentHorizontalPadding,
        ),
        child: SvgButton(
          onTap: () {
            if (onTap != null) {
              onTap?.call();
            } else {
              Get.back();
            }
          },
          svgIconUrl: Utils.getBackButtonPath(context),
        ),
      ),
    );
  }
}
