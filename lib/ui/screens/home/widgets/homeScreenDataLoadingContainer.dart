import 'package:yocut/ui/widgets/customShimmerContainer.dart';
import 'package:yocut/ui/widgets/shimmerLoaders/announcementShimmerLoadingContainer.dart';
import 'package:yocut/ui/widgets/shimmerLoaders/subjectsShimmerLoadingContainer.dart';
import 'package:yocut/ui/widgets/shimmerLoadingContainer.dart';
import 'package:yocut/utils/utils.dart';
import 'package:flutter/material.dart';

class HomeScreenDataLoadingContainer extends StatelessWidget {
  final bool addTopPadding;
  const HomeScreenDataLoadingContainer(
      {super.key, required this.addTopPadding});

  @override
  Widget build(BuildContext context) {
    return ListView(
      padding: EdgeInsets.only(
          top: addTopPadding
              ? Utils.getScrollViewTopPadding(
                  context: context,
                  appBarHeightPercentage: Utils.appBarBiggerHeightPercentage,
                )
              : 25),
      children: [
        ShimmerLoadingContainer(
          child: CustomShimmerContainer(
            margin: EdgeInsets.symmetric(
              horizontal: MediaQuery.of(context).size.width * (0.075),
            ),
            width: MediaQuery.of(context).size.width,
            borderRadius: 25,
            height: MediaQuery.of(context).size.height *
                Utils.appBarBiggerHeightPercentage,
          ),
        ),
        SizedBox(
          height: MediaQuery.of(context).size.height * (0.025),
        ),
        const SubjectsShimmerLoadingContainer(),
        SizedBox(
          height: MediaQuery.of(context).size.height * (0.025),
        ),
        Column(
          children: List.generate(3, (index) => index)
              .map((notice) => const AnnouncementShimmerLoadingContainer())
              .toList(),
        )
      ],
    );
  }
}
