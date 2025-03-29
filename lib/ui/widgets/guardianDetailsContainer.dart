import 'package:yocut/data/models/guardian.dart';
import 'package:yocut/ui/widgets/customUserProfileImageWidget.dart';
import 'package:yocut/utils/labelKeys.dart';
import 'package:yocut/utils/utils.dart';
import 'package:flutter/material.dart';

class GuardianDetailsContainer extends StatelessWidget {
  final Guardian guardian;
  const GuardianDetailsContainer({
    Key? key,
    required this.guardian,
  }) : super(key: key);

  Widget _buildGuardianDetailsTitleAndValue({
    required String title,
    required String value,
    required BuildContext context,
  }) {
    return Padding(
      padding: const EdgeInsets.only(
        left: 20.0,
        right: 20.0,
        bottom: 20,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title,
            style: TextStyle(
              color: Theme.of(context).colorScheme.onSurface.withValues(alpha: 0.75),
              fontSize: 13.0,
            ),
          ),
          const SizedBox(
            height: 5.0,
          ),
          Text(
            value,
            style: TextStyle(
              color: Theme.of(context).colorScheme.secondary,
              fontWeight: FontWeight.w600,
            ),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      width: MediaQuery.of(context).size.width * (0.8),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(15.0),
        color: Theme.of(context).colorScheme.surface,
      ),
      child: Stack(
        clipBehavior: Clip.none,
        children: [
          PositionedDirectional(
            top: -40,
            start: MediaQuery.of(context).size.width * (0.4) - 42.5,
            child: Container(
              width: 85.0,
              height: 85.0,
              padding: const EdgeInsets.all(10),
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: Theme.of(context).scaffoldBackgroundColor,
              ),
              child: Container(
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: Theme.of(context).colorScheme.primary,
                ),
                child: CustomUserProfileImageWidget(
                    profileUrl: guardian.image ?? ""),
              ),
            ),
          ),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              const SizedBox(
                height: 60,
              ),
              Divider(
                color:
                    Theme.of(context).colorScheme.onSurface.withValues(alpha: 0.75),
                height: 1.25,
              ),
              const SizedBox(
                height: 20,
              ),
              _buildGuardianDetailsTitleAndValue(
                title: Utils.getTranslatedLabel(nameKey),
                context: context,
                value: Utils.formatEmptyValue(
                  guardian.getFullName(),
                ),
              ),
              _buildGuardianDetailsTitleAndValue(
                context: context,
                title: Utils.getTranslatedLabel(emailKey),
                value: Utils.formatEmptyValue(guardian.email ?? ""),
              ),
              (guardian.mobile ?? "").isEmpty
                  ? const SizedBox()
                  : _buildGuardianDetailsTitleAndValue(
                      context: context,
                      title: Utils.getTranslatedLabel(phoneNumberKey),
                      value: Utils.formatEmptyValue(guardian.mobile ?? ""),
                    ),
              (guardian.currentAddress ?? "").isEmpty
                  ? const SizedBox()
                  : _buildGuardianDetailsTitleAndValue(
                      context: context,
                      title: Utils.getTranslatedLabel(addressKey),
                      value:
                          Utils.formatEmptyValue(guardian.currentAddress ?? ""),
                    ),
              const SizedBox(
                height: 20,
              ),
            ],
          ),
        ],
      ),
    );
  }
}
