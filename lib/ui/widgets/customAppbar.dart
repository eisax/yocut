import 'package:yocut/ui/widgets/screenTopBackgroundContainer.dart';
import 'package:yocut/ui/widgets/svgButton.dart';
import 'package:yocut/utils/utils.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class CustomAppBar extends StatelessWidget {
  final String title;
  final Function? onPressBackButton;
  final String? subTitle;
  final bool? showBackButton;
  const CustomAppBar({
    Key? key,
    this.onPressBackButton,
    required this.title,
    this.subTitle,
    this.showBackButton,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ScreenTopBackgroundContainer(
      padding: EdgeInsets.zero,
      heightPercentage: Utils.appBarSmallerHeightPercentage,
      child: LayoutBuilder(
        builder: (context, boxConstraints) {
          return Stack(
            children: [
              (showBackButton ?? true)
                  ? Align(
                      alignment: AlignmentDirectional.centerStart,
                      child: Padding(
                        padding: EdgeInsetsDirectional.only(
                          start: Utils.screenContentHorizontalPadding,
                        ),
                        child: SvgButton(
                          onTap: () {
                            if (onPressBackButton != null) {
                              onPressBackButton!.call();
                            } else {
                              Get.back();
                            }
                          },
                          svgIconUrl: Utils.getBackButtonPath(context),
                        ),
                      ),
                    )
                  : const SizedBox(),
              Align(
                child: Container(
                  alignment: Alignment.center,
                  width: boxConstraints.maxWidth * (0.6),
                  child: Text(
                    Utils.getTranslatedLabel(title),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontSize: Utils.screenTitleFontSize,
                      color: Theme.of(context).scaffoldBackgroundColor,
                    ),
                  ),
                ),
              ),
              Align(
                child: Padding(
                  padding: EdgeInsets.only(
                      top: boxConstraints.maxHeight * (0.31) +
                          Utils.screenTitleFontSize,
                      left: Utils.screenContentHorizontalPadding,
                      right: Utils.screenContentHorizontalPadding),
                  child: Text(
                    subTitle ?? "",
                    textAlign: TextAlign.center,
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                    style: TextStyle(
                      height: 1.1,
                      fontSize: Utils.screenSubTitleFontSize,
                      color: Theme.of(context).scaffoldBackgroundColor,
                    ),
                  ),
                ),
              ),
            ],
          );
        },
      ),
    );
  }
}
