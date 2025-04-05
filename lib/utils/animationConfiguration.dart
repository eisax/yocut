import 'package:yocut/utils/constants.dart';
import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';

/*
 change the effects to apply your own custom effects - only if you know about the flutter_animate package
*/
List<Effect<dynamic>> listItemAppearanceEffects(
    {required int itemIndex, int totalLoadedItems = 15}) {
  return isApplicationItemAnimationOn
      ? [
          FadeEffect(
            delay: Duration(
              milliseconds: (itemIndex % totalLoadedItems) *
                  (listItemAnimationDelayInMilliseconds - 9),
            ),
          ),
          SlideEffect(
            delay: Duration(
              milliseconds: (itemIndex % totalLoadedItems) *
                  listItemAnimationDelayInMilliseconds,
            ),
            curve: Curves.easeInOut,
            end: SlideEffect.neutralValue.copyWith(dx: 0),
            begin: SlideEffect.neutralValue.copyWith(dx: -0.5),
          ),
        ]
      : [];
}

List<Effect<dynamic>> customItemFadeAppearanceEffects() {
  return isApplicationItemAnimationOn
      ? [
          const FadeEffect(
            duration: Duration(
              milliseconds: itemFadeAnimationDurationInMilliseconds,
            ),
          ),
        ]
      : [];
}

List<Effect<dynamic>> customItemZoomAppearanceEffects({
  Duration? delay,
  Duration? duration,
}) {
  return isApplicationItemAnimationOn
      ? [
          ScaleEffect(
            delay: delay,
            duration: duration ??
                const Duration(
                  milliseconds: itemZoomAnimationDurationInMilliseconds,
                ),
          ),
        ]
      : [];
}

List<Effect<dynamic>> customItemBounceScaleAppearanceEffects() {
  return isApplicationItemAnimationOn
      ? [
          const ScaleEffect(
            duration: Duration(
              milliseconds: itemBouncScaleAnimationDurationInMilliseconds,
            ),
            curve: Curves.bounceOut,
          )
        ]
      : [];
}
