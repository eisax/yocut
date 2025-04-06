import 'package:yocut/utils/utils.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

class PasswordHideShowButton extends StatelessWidget {
  final bool hidePassword;
  final Function onTap;
  final double? allSidePadding;
  const PasswordHideShowButton({
    super.key,
    required this.hidePassword,
    required this.onTap,
    this.allSidePadding,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.all(allSidePadding ?? 12.0),
      child: GestureDetector(
        onTap: () {
          onTap();
        },
        child: SvgPicture.asset(
          Utils.getImagePath(
            hidePassword ? "hide_password.svg" : "show_password.svg",
          ),
          colorFilter: ColorFilter.mode(
              Utils.getColorScheme(context).secondary, BlendMode.srcIn),
        ),
      ),
    );
  }
}
