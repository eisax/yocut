import 'package:yocut/cubits/appLocalizationCubit.dart';
import 'package:yocut/data/models/appLanguage.dart';
import 'package:yocut/utils/appLanguages.dart';
import 'package:yocut/utils/labelKeys.dart';
import 'package:yocut/utils/utils.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class ChangeLanguageBottomsheetContainer extends StatelessWidget {
  const ChangeLanguageBottomsheetContainer({super.key});

  Widget _buildAppLanguageTile({
    required AppLanguage appLanguage,
    required BuildContext context,
    required String currentSelectedLanguageCode,
  }) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 10.0),
      child: GestureDetector(
        onTap: () {
          context
              .read<AppLocalizationCubit>()
              .changeLanguage(appLanguage.languageCode);
        },
        child: Row(
          children: [
            Container(
              padding: const EdgeInsets.all(2),
              width: 20,
              height: 20,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                border: Border.all(
                  color: Theme.of(context).colorScheme.primary,
                  width: 1.75,
                ),
              ),
              child: Container(
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: appLanguage.languageCode == currentSelectedLanguageCode
                      ? Theme.of(context).colorScheme.primary
                      : Theme.of(context).scaffoldBackgroundColor,
                ),
              ),
            ),
            const SizedBox(
              width: 15,
            ),
            Text(
              appLanguage.languageName,
              style: TextStyle(
                fontSize: 14,
                color: Theme.of(context).colorScheme.secondary,
              ),
            )
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(
        horizontal: MediaQuery.of(context).size.width * (0.075),
        vertical: MediaQuery.of(context).size.height * (0.05),
      ),
      width: MediaQuery.of(context).size.width,
      decoration: BoxDecoration(
        color: Theme.of(context).scaffoldBackgroundColor,
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(Utils.bottomSheetTopRadius),
          topRight: Radius.circular(Utils.bottomSheetTopRadius),
        ),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            Utils.getTranslatedLabel(appLanguageKey),
            style: TextStyle(
              fontSize: 16.0,
              color: Theme.of(context).colorScheme.secondary,
              fontWeight: FontWeight.bold,
            ),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 10.0),
            child: Divider(
              color: Theme.of(context).colorScheme.onSurface,
            ),
          ),
          BlocBuilder<AppLocalizationCubit, AppLocalizationState>(
            builder: (context, state) {
              return Column(
                children: appLanguages
                    .map(
                      (appLanguage) => _buildAppLanguageTile(
                        appLanguage: appLanguage,
                        context: context,
                        currentSelectedLanguageCode:
                            state.language.languageCode,
                      ),
                    )
                    .toList(),
              );
            },
          )
        ],
      ),
    );
  }
}
