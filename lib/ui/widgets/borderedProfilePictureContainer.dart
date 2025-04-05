import 'package:yocut/ui/widgets/customUserProfileImageWidget.dart';

import 'package:flutter/material.dart';

class BorderedProfilePictureContainer extends StatelessWidget {
  final String imageUrl;
  final Function? onTap;
  final double heightAndWidth;
  const BorderedProfilePictureContainer({
    Key? key,
    required this.imageUrl,
    required this.heightAndWidth,
    this.onTap,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return InkWell(
      borderRadius: BorderRadius.circular(
        heightAndWidth * 0.5,
      ),
      onTap: () {
        onTap?.call();
      },
      child: Container(
        padding: const EdgeInsets.all(4.0),
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          border: Border.all(
            color: Theme.of(context).scaffoldBackgroundColor,
          ),
        ),
        width: heightAndWidth,
        height: heightAndWidth,
        child: CustomUserProfileImageWidget(profileUrl: imageUrl),
      ),
    );
  }
}
