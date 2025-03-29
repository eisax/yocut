import 'dart:math';
import 'package:yocut/app/routes.dart';
import 'package:yocut/cubits/authCubit.dart';
import 'package:yocut/ui/widgets/customUserProfileImageWidget.dart';
import 'package:yocut/utils/homeBottomsheetMenu.dart';
import 'package:yocut/utils/labelKeys.dart';
import 'package:yocut/utils/utils.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';

class MoreMenuBottomsheetContainer extends StatelessWidget {
  final Function onTapMoreMenuItemContainer;
  final Function closeBottomMenu;
  const MoreMenuBottomsheetContainer({
    Key? key,
    required this.onTapMoreMenuItemContainer,
    required this.closeBottomMenu,
  }) : super(key: key);

  Widget _buildMoreMenuContainer(
      {required BuildContext context,
      required BoxConstraints boxConstraints,
      required Menu menu}) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 20),
      child: GestureDetector(
        onTap: () {
          onTapMoreMenuItemContainer(
            homeBottomSheetMenu
                .indexWhere((element) => element.title == menu.title),
          );
        },
        child: Column(
          children: [
            Container(
              decoration: BoxDecoration(
                border: Border.all(
                  color:
                      Theme.of(context).colorScheme.onSurface.withValues(alpha: 0.5),
                ),
                color:
                    Theme.of(context).colorScheme.onSecondary.withValues(alpha: 0.2),
                borderRadius: BorderRadius.circular(15.0),
              ),
              margin: EdgeInsets.symmetric(
                horizontal: boxConstraints.maxWidth * (0.065),
              ),
              width: boxConstraints.maxWidth * (0.2),
              height: boxConstraints.maxWidth * (0.2),
              padding: const EdgeInsets.all(12.5),
              child: SvgPicture.asset(menu.iconUrl),
            ),
            const SizedBox(height: 10),
            SizedBox(
              width: boxConstraints.maxWidth * (0.3),
              child: Text(
                Utils.getTranslatedLabel(menu.title),
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
                textAlign: TextAlign.center,
                style: TextStyle(
                  color: Theme.of(context).colorScheme.secondary,
                  fontSize: 14.0,
                ),
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
      constraints: BoxConstraints(
          maxHeight: MediaQuery.of(context).size.height * (0.85)),
      padding: const EdgeInsets.only(top: 25.0, right: 25.0, left: 25.0),
      width: MediaQuery.of(context).size.width,
      decoration: BoxDecoration(
        color: Theme.of(context).scaffoldBackgroundColor,
        borderRadius: const BorderRadius.only(
          topLeft: Radius.circular(25),
          topRight: Radius.circular(25),
        ),
      ),
      child: LayoutBuilder(
        builder: (context, boxConstraints) {
          return Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              Row(
                children: [
                  Container(
                    height: boxConstraints.maxWidth * (0.22),
                    width: boxConstraints.maxWidth * (0.22),
                    decoration: BoxDecoration(
                      border: Border.all(
                        width: 2.0,
                        color: Theme.of(context).colorScheme.onSurface,
                      ),
                      borderRadius: BorderRadius.circular(
                        boxConstraints.maxWidth * (0.11),
                      ),
                    ),
                    child: CustomUserProfileImageWidget(
                      profileUrl:
                          context.read<AuthCubit>().getStudentDetails().image ??
                              "",
                      color: Colors.black,
                    ),
                  ),
                  SizedBox(
                    width: boxConstraints.maxWidth * (0.075),
                  ),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          context
                              .read<AuthCubit>()
                              .getStudentDetails()
                              .getFullName(),
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          style: TextStyle(
                            color: Theme.of(context).colorScheme.secondary,
                            fontWeight: FontWeight.w500,
                            fontSize: 18.0,
                          ),
                        ),
                        Row(
                          children: [
                            Flexible(
                              child: Text(
                                "${Utils.getTranslatedLabel(classKey)} : ${context.read<AuthCubit>().getStudentDetails().classSection?.fullName}",
                                maxLines: 2,
                                overflow: TextOverflow.ellipsis,
                                style: TextStyle(
                                  fontSize: 12.0,
                                  fontWeight: FontWeight.w400,
                                  color:
                                      Theme.of(context).colorScheme.onSurface,
                                ),
                              ),
                            ),
                          ],
                        ),
                        Row(
                          children: [
                            Flexible(
                              child: Text(
                                "${Utils.getTranslatedLabel(rollNoKey)} : ${context.read<AuthCubit>().getStudentDetails().rollNumber}",
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
                                style: TextStyle(
                                  fontSize: 12.0,
                                  fontWeight: FontWeight.w400,
                                  color:
                                      Theme.of(context).colorScheme.onSurface,
                                ),
                              ),
                            ),
                          ],
                        )
                      ],
                    ),
                  ),
                  IconButton(
                    onPressed: () async {
                      closeBottomMenu();

                      Get.toNamed(Routes.studentProfile);
                    },
                    icon: Transform.rotate(
                      angle: pi,
                      child: Icon(
                        Icons.arrow_back_ios,
                        color: Theme.of(context).colorScheme.secondary,
                      ),
                    ),
                  )
                ],
              ),
              Divider(
                color: Theme.of(context).colorScheme.onSurface,
                height: 50,
              ),
              Expanded(
                child: SingleChildScrollView(
                  child: Wrap(
                    crossAxisAlignment: WrapCrossAlignment.start,
                    children: homeBottomSheetMenu
                        .map(
                          (e) => Utils.isModuleEnabled(
                                  context: context, moduleId: e.menuModuleId)
                              ? _buildMoreMenuContainer(
                                  context: context,
                                  boxConstraints: boxConstraints,
                                  menu: e)
                              : const SizedBox(),
                        )
                        .toList(),
                  ),
                ),
              ),
              SizedBox(
                height: Utils.getScrollViewBottomPadding(context),
              ),
            ],
          );
        },
      ),
    );
  }
}
