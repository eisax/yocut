import 'dart:convert';

import 'package:yocut/utils/appLanguages.dart';
import 'package:flutter/services.dart';

abstract class AppTranslation {
  static Map<String, Map<String, String>> translationsKeys = Map.fromEntries(
      appLanguages.map((appLanguage) => appLanguage.languageCode).toList().map(
          (languageCode) =>
              MapEntry(languageCode, Map<String, String>.from({}))));

  static Future loadJsons() async {
    for (var languageCode in translationsKeys.keys) {
      final String jsonStringValues =
          await rootBundle.loadString('assets/languages/$languageCode.json');
      //value from rootbundle will be encoded string
      Map<String, dynamic> mappedJson = json.decode(jsonStringValues);

      translationsKeys[languageCode] = mappedJson.cast<String, String>();
    }

    //
  }
}
