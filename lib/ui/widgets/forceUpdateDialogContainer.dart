import 'dart:io';

import 'package:yocut/cubits/appConfigurationCubit.dart';
import 'package:yocut/utils/labelKeys.dart';
import 'package:yocut/utils/utils.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:url_launcher/url_launcher.dart';

class ForceUpdateDialogContainer extends StatelessWidget {
  const ForceUpdateDialogContainer({super.key});

  Widget _buildUpdateButton(BuildContext context) {
    return CupertinoButton(
      child: Text(Utils.getTranslatedLabel(updateKey)),
      onPressed: () async {
        final appUrl = context.read<AppConfigurationCubit>().getAppLink();
        if (await canLaunchUrl(Uri.parse(appUrl))) {
          launchUrl(Uri.parse(appUrl));
        }
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.black.withValues(alpha: 0.5),
      width: MediaQuery.of(context).size.width,
      height: MediaQuery.of(context).size.height,
      child: Center(
        child: Platform.isIOS
            ? CupertinoAlertDialog(
                title: Text(
                  Utils.getTranslatedLabel(newUpdateAvailableKey),
                ),
                actions: [_buildUpdateButton(context)],
              )
            : AlertDialog(
                content: Text(
                  Utils.getTranslatedLabel(newUpdateAvailableKey),
                  style: TextStyle(fontSize: 17.0),
                ),
                actions: [_buildUpdateButton(context)],
              ),
      ),
    );
  }
}
