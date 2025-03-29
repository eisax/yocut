import 'package:yocut/utils/hiveBoxKeys.dart';
import 'package:hive_flutter/hive_flutter.dart';

// ignore: avoid_classes_with_only_static_members
class AppShowCaseRepository {
  static bool getShowHomeScreenShowCase() {
    return Hive.box(showCaseBoxKey).get(showHomeScreenGuideKey) ?? true;
  }

  static void setShowHomeScreenShowCase(bool value) {
    Hive.box(showCaseBoxKey).put(showHomeScreenGuideKey, value);
  }
}
