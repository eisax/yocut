import 'package:yocut/utils/utils.dart';
import 'package:flutter/material.dart';

class CustomTextFieldContainer extends StatelessWidget {
  final String hintTextKey;
  final bool hideText;
  final double? bottomPadding;
  final Widget? suffixWidget;
  final TextEditingController? textEditingController;
  const CustomTextFieldContainer({
    super.key,
    this.bottomPadding,
    this.suffixWidget,
    required this.hideText,
    required this.hintTextKey,
    this.textEditingController,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 50,
      margin: EdgeInsets.only(bottom: bottomPadding ?? 20.0),
      padding: const EdgeInsetsDirectional.only(
        start: 20.0,
      ),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(10),
        border: Border.all(color: Utils.getColorScheme(context).secondary),
      ),
      child: TextFormField(
          controller: textEditingController,
          obscureText: hideText,
          decoration: InputDecoration(
            suffixIcon: suffixWidget,
            hintStyle:
                TextStyle(color: Utils.getColorScheme(context).secondary),
            hintText: Utils.getTranslatedLabel(hintTextKey),
            border: InputBorder.none,
            contentPadding:
                suffixWidget != null ? EdgeInsets.only(top: 12.5) : null,
          )),
    );
  }
}
