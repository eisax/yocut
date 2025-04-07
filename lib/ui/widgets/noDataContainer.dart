import 'package:yocut/utils/animationConfiguration.dart';
import 'package:yocut/utils/utils.dart';
import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter_svg/flutter_svg.dart';

class NoDataContainer extends StatelessWidget {
  final Color? textColor;
  final String titleKey;
  final bool animate;
  const NoDataContainer(
      {super.key, this.textColor, required this.titleKey, this.animate = true});

  @override
  Widget build(BuildContext context) {
    return Animate(
      effects: animate ? customItemBounceScaleAppearanceEffects() : null,
      child: Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            SizedBox(
              height: MediaQuery.of(context).size.height * (0.025),
            ),
            SizedBox(
              height: MediaQuery.of(context).size.height * (0.35),
              child: SvgPicture.asset(Utils.getImagePath("fileNotFound.svg")),
            ),
            SizedBox(
              height: MediaQuery.of(context).size.height * (0.025),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 15),
              child: Text(
                Utils.getTranslatedLabel(titleKey),
                textAlign: TextAlign.center,
                style: TextStyle(
                  color: textColor ?? Theme.of(context).colorScheme.secondary,
                  fontSize: 16,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
