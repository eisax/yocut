import 'package:yocut/app/routes.dart';
import 'package:yocut/cubits/noticeBoardCubit.dart';
import 'package:yocut/ui/widgets/announcementDetailsContainer.dart';
import 'package:yocut/ui/widgets/shimmerLoaders/announcementShimmerLoadingContainer.dart';
import 'package:yocut/utils/animationConfiguration.dart';
import 'package:yocut/utils/constants.dart';
import 'package:yocut/utils/labelKeys.dart';
import 'package:yocut/utils/utils.dart';
import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get/get.dart';

class LatestNoticiesContainer extends StatelessWidget {
  final bool animate;
  final int? childId;
  const LatestNoticiesContainer({
    super.key,
    this.animate = true,
    this.childId,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: MediaQuery.of(context).size.width,
      margin: EdgeInsets.symmetric(
        horizontal: MediaQuery.of(context).size.width *
            Utils.screenContentHorizontalPaddingInPercentage,
      ),
      child: Column(
        children: [
          BlocBuilder<NoticeBoardCubit, NoticeBoardState>(
            builder: (context, state) {
              if (state is NoticeBoardFetchSuccess) {
                if (state.announcements.isEmpty) {
                  return const SizedBox();
                }
                final announcements = state.announcements.length >
                        numberOfLatestNoticesInHomeScreen
                    ? state.announcements
                        .sublist(0, numberOfLatestNoticesInHomeScreen)
                        .toList()
                    : state.announcements;
                return Column(
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          Utils.getTranslatedLabel(latestNoticesKey),
                          style: TextStyle(
                            color: Utils.getColorScheme(context).secondary,
                            fontWeight: FontWeight.w600,
                            fontSize: 16.0,
                          ),
                          textAlign: TextAlign.start,
                        ),
                        InkWell(
                          onTap: () {
                            Get.toNamed(Routes.noticeBoard, arguments: childId);
                          },
                          child: Text(
                            Utils.getTranslatedLabel(viewAllKey),
                            style: TextStyle(
                              color: Utils.getColorScheme(context).onSurface,
                              fontSize: 13.0,
                            ),
                            textAlign: TextAlign.start,
                          ),
                        ),
                      ],
                    ),
                    SizedBox(
                      height: MediaQuery.of(context).size.height * (0.025),
                    ),
                    ...List.generate(
                      announcements.length,
                      (index) => Animate(
                        effects: animate
                            ? listItemAppearanceEffects(
                                itemIndex: index,
                                totalLoadedItems: announcements.length,
                              )
                            : null,
                        child: AnnouncementDetailsContainer(
                          announcement: announcements[index],
                        ),
                      ),
                    )
                  ],
                );
              }

              if (state is NoticeBoardFetchInProgress ||
                  state is NoticeBoardInitial) {
                return Column(
                  children: List.generate(3, (index) => index)
                      .map((notice) =>
                          const AnnouncementShimmerLoadingContainer())
                      .toList(),
                );
              }

              return const SizedBox();
            },
          ),
          SizedBox(
            height: MediaQuery.of(context).size.height * (0.025),
          ),
        ],
      ),
    );
  }
}
