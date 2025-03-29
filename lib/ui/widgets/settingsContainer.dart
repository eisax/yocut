import 'package:yocut/app/routes.dart';
import 'package:yocut/cubits/appConfigurationCubit.dart';
import 'package:yocut/cubits/appLocalizationCubit.dart';
import 'package:yocut/cubits/authCubit.dart';
import 'package:yocut/cubits/changePasswordCubit.dart';
import 'package:yocut/data/repositories/authRepository.dart';
import 'package:yocut/ui/widgets/changeLanguageBottomsheetContainer.dart';
import 'package:yocut/ui/widgets/changePasswordBottomsheet.dart';
import 'package:yocut/ui/widgets/customBackButton.dart';
import 'package:yocut/ui/widgets/logoutButton.dart';
import 'package:yocut/ui/widgets/screenTopBackgroundContainer.dart';
import 'package:yocut/utils/appLanguages.dart';
import 'package:yocut/utils/errorMessageKeysAndCodes.dart';
import 'package:yocut/utils/labelKeys.dart';
import 'package:yocut/utils/utils.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get/get.dart';
import 'package:url_launcher/url_launcher.dart';

class SettingsContainer extends StatelessWidget {
  const SettingsContainer({Key? key}) : super(key: key);

  Future<void> _shareApp(BuildContext context) async {
    final appUrl = context.read<AppConfigurationCubit>().getAppLink();
    if (await canLaunchUrl(Uri.parse(appUrl))) {
      launchUrl(Uri.parse(appUrl));
    } else {
      if (context.mounted) {
        Utils.showCustomSnackBar(
          context: context,
          errorMessage: Utils.getTranslatedLabel(
            ErrorMessageKeysAndCode.defaultErrorMessageKey,
          ),
          backgroundColor: Theme.of(context).colorScheme.error,
        );
      }
    }
  }

  Widget _buildAppbar(BuildContext context) {
    return ScreenTopBackgroundContainer(
      padding: EdgeInsets.zero,
      heightPercentage: Utils.appBarSmallerHeightPercentage,
      child: Stack(
        children: [
          context.read<AuthCubit>().isParent()
              ? const CustomBackButton(
                  alignmentDirectional: AlignmentDirectional.centerStart,
                )
              : const SizedBox(),
          Center(
            child: Text(
              Utils.getTranslatedLabel(settingsKey),
              style: TextStyle(
                color: Theme.of(context).scaffoldBackgroundColor,
                fontSize: Utils.screenTitleFontSize,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSettingDetailsTile({
    required String title,
    required Function onTap,
    required BuildContext context,
    required IconData icon,
  }) {
    return InkWell(
      onTap: () {
        onTap();
      },
      child: Padding(
        padding: EdgeInsetsDirectional.only(
          bottom: 10,
          top: 10,
          start: MediaQuery.of(context).size.width * (0.075),
          end: MediaQuery.of(context).size.width * (0.075),
        ),
        child: DecoratedBox(
          decoration:
              BoxDecoration(border: Border.all(color: Colors.transparent)),
          child: Row(
            children: [
              Container(
                padding: const EdgeInsets.all(10),
                decoration: BoxDecoration(
                  color: Theme.of(context).colorScheme.primary,
                  shape: BoxShape.circle,
                ),
                alignment: Alignment.center,
                child: Icon(
                  icon,
                  color: Colors.white,
                ),
              ),
              const SizedBox(
                width: 15,
              ),
              Expanded(
                child: Text(
                  title,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: TextStyle(
                    color: Theme.of(context).colorScheme.onSurface,
                    fontSize: 15,
                    fontWeight: FontWeight.w400,
                  ),
                ),
              ),
              Icon(
                Icons.chevron_right,
                color: Theme.of(context).colorScheme.onSurface.withValues(alpha: 0.8),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildSettingsContainer(BuildContext context) {
    return Column(
      children: [
        BlocBuilder<AppLocalizationCubit, AppLocalizationState>(
          builder: (context, state) {
            final String languageName = appLanguages
                .where(
                  (element) =>
                      element.languageCode == state.language.languageCode,
                )
                .toList()
                .first
                .languageName;
            return _buildSettingDetailsTile(
              icon: Icons.translate,
              title: languageName,
              onTap: () async {
                Utils.showBottomSheet(
                  child: const ChangeLanguageBottomsheetContainer(),
                  context: context,
                );
              },
              context: context,
            );
          },
        ),
        context.read<AuthCubit>().isParent()
            ? _buildSettingDetailsTile(
                icon: Icons.receipt,
                title: Utils.getTranslatedLabel(transactionsKey),
                onTap: () {
                  Get.toNamed(Routes.transactions);
                },
                context: context)
            : const SizedBox(),
        _buildSettingDetailsTile(
          icon: Icons.password,
          title: Utils.getTranslatedLabel(changePasswordKey),
          onTap: () {
            Utils.showBottomSheet(
              child: BlocProvider<ChangePasswordCubit>(
                create: (_) => ChangePasswordCubit(AuthRepository()),
                child: const ChangePasswordBottomsheet(),
              ),
              context: context,
            ).then((value) {
              if (value != null && !value['error']) {
                Utils.showCustomSnackBar(
                  context: context,
                  errorMessage: Utils.getTranslatedLabel(
                    passwordChangedSuccessfullyKey,
                  ),
                  backgroundColor: Theme.of(context).colorScheme.onPrimary,
                );
              }
            });
          },
          context: context,
        ),
        _buildSettingDetailsTile(
          icon: Icons.notifications,
          title: Utils.getTranslatedLabel(notificationsKey),
          onTap: () {
            Get.toNamed(Routes.notifications);
          },
          context: context,
        ),
        _buildSettingDetailsTile(
          icon: Icons.privacy_tip,
          title: Utils.getTranslatedLabel(privacyPolicyKey),
          onTap: () {
            Get.toNamed(Routes.privacyPolicy);
          },
          context: context,
        ),
        _buildSettingDetailsTile(
          icon: Icons.description,
          title: Utils.getTranslatedLabel(termsAndConditionKey),
          onTap: () {
            Get.toNamed(Routes.termsAndCondition);
          },
          context: context,
        ),
        _buildSettingDetailsTile(
          icon: Icons.info,
          title: Utils.getTranslatedLabel(aboutUsKey),
          onTap: () {
            Get.toNamed(Routes.aboutUs);
          },
          context: context,
        ),
        _buildSettingDetailsTile(
          icon: Icons.contact_support,
          title: Utils.getTranslatedLabel(contactUsKey),
          onTap: () {
            Get.toNamed(Routes.contactUs);
          },
          context: context,
        ),
        _buildSettingDetailsTile(
          icon: Icons.star,
          title: Utils.getTranslatedLabel(rateUsKey),
          onTap: () {
            _shareApp(context);
          },
          context: context,
        ),
        _buildSettingDetailsTile(
          icon: Icons.share,
          title: Utils.getTranslatedLabel(shareKey),
          onTap: () {
            _shareApp(context);
          },
          context: context,
        ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Align(
          alignment: Alignment.topCenter,
          child: SingleChildScrollView(
            padding: EdgeInsetsDirectional.only(
              bottom: Utils.getScrollViewBottomPadding(context),
              top: Utils.getScrollViewTopPadding(
                      context: context,
                      appBarHeightPercentage:
                          Utils.appBarSmallerHeightPercentage) -
                  10, //10 is the top padding of first item
            ),
            child: Column(
              children: [
                _buildSettingsContainer(context),
                const SizedBox(
                  height: 25.0,
                ),
                const LogoutButton(),
                const SizedBox(
                  height: 5.0,
                ),
                Text(
                  "${Utils.getTranslatedLabel(appVersionKey)}  ${context.read<AppConfigurationCubit>().getAppVersion()}",
                  style: TextStyle(
                    color: Theme.of(context).colorScheme.onSurface,
                    fontWeight: FontWeight.w500,
                    fontSize: 11.0,
                  ),
                  textAlign: TextAlign.start,
                ),
                //extra height to avoide dashboard's bottom navigationbar
                SizedBox(
                  height: MediaQuery.of(context).size.height *
                      Utils.bottomNavigationHeightPercentage,
                ),
              ],
            ),
          ),
        ),
        _buildAppbar(context),
      ],
    );
  }
}
