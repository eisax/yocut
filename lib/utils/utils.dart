import 'package:flutter/material.dart';
import 'package:get/get.dart';
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
}