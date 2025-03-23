import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:yocut/ui/widgets/errorMessageOverlayContainer.dart';
import 'package:yocut/utils/constants.dart';
import 'package:yocut/utils/errorMessageKeysAndCode.dart';

class Utils {

  static String getImagePath(String imageName) {
    return "assets/images/$imageName";
  }

  static String getTranslatedLabel(String labelKey) {
    return labelKey.tr.trim();
  }

  static String getErrorMessageFromErrorCode(
    BuildContext context,
    String errorCode,
  ) {
    return Utils.getTranslatedLabel(
      ErrorMessageKeysAndCode.getErrorMessageKeyFromCode(errorCode),
    );
  }

  static Future<void> showCustomSnackBar({
    required BuildContext context,
    required String errorMessage,
    required Color backgroundColor,
    Duration delayDuration = errorMessageDisplayDuration,
  }) async {
    OverlayState? overlayState = Overlay.of(context);
    OverlayEntry overlayEntry = OverlayEntry(
      builder: (context) => ErrorMessageOverlayContainer(
        backgroundColor: backgroundColor,
        errorMessage: errorMessage,
      ),
    );

    overlayState.insert(overlayEntry);
    await Future.delayed(delayDuration);
    overlayEntry.remove();
  }

  static ColorScheme getColorScheme(BuildContext context) {
    return Theme.of(context).colorScheme;
  }
}