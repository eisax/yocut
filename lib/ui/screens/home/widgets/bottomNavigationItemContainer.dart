import 'package:yocut/utils/utils.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';

class BottomNavItem {
  final String title;
  final String activeImageUrl;
  final String disableImageUrl;

  BottomNavItem({
    required this.activeImageUrl,
    required this.disableImageUrl,
    required this.title,
  });
}

class BottomNavItemContainer extends StatefulWidget {
  final BoxConstraints boxConstraints;
  final int index;
  final int currentIndex;
  final AnimationController animationController;
  final BottomNavItem bottomNavItem;
  final Function onTap;
  final String showCaseDescription;
  const BottomNavItemContainer({
    super.key,
    required this.boxConstraints,
    required this.currentIndex,
    required this.showCaseDescription,
    required this.bottomNavItem,
    required this.animationController,
    required this.onTap,
    required this.index,
  });

  @override
  State<BottomNavItemContainer> createState() => _BottomNavItemContainerState();
}

class _BottomNavItemContainerState extends State<BottomNavItemContainer> {
  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () async {
        widget.onTap(widget.index);
      },
      child: SizedBox(
        width: widget.boxConstraints.maxWidth * (0.25),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          mainAxisSize: MainAxisSize.min,
          children: [
            SlideTransition(
              position: Tween<Offset>(
                begin: const Offset(0.0, 0.05),
                end: const Offset(0.0, 0.35),
              ).animate(
                CurvedAnimation(
                  parent: widget.animationController,
                  curve: Curves.easeInOut,
                ),
              ),
              child: SvgPicture.asset(
                widget.index == widget.currentIndex
                    ? widget.bottomNavItem.activeImageUrl
                    : widget.bottomNavItem.disableImageUrl,
              ),
            ),
            SizedBox(
              height: widget.boxConstraints.maxHeight * (0.051),
            ),
            FadeTransition(
              opacity: Tween<double>(begin: 1.0, end: 0.0)
                  .animate(widget.animationController),
              child: SlideTransition(
                position: Tween<Offset>(
                  // ignore: use_named_constants
                  begin: const Offset(0.0, 0.0),
                  end: const Offset(0.0, 0.5),
                ).animate(
                  CurvedAnimation(
                    parent: widget.animationController,
                    curve: Curves.easeInOut,
                  ),
                ),
                child: Text(
                  Utils.getTranslatedLabel(
                    widget.bottomNavItem.title,
                  ),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: const TextStyle(
                    fontSize: 11.5,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
