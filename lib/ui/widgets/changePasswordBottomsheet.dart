import 'package:yocut/cubits/changePasswordCubit.dart';
import 'package:yocut/ui/widgets/bottomsheetTopTitleAndCloseButton.dart';
import 'package:yocut/ui/widgets/customRoundedButton.dart';
import 'package:yocut/ui/widgets/customTextFieldContainer.dart';
import 'package:yocut/ui/widgets/passwordHideShowButton.dart';
import 'package:yocut/utils/constants.dart';
import 'package:yocut/utils/labelKeys.dart';
import 'package:yocut/utils/utils.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get/get.dart';

class ChangePasswordBottomsheet extends StatefulWidget {
  const ChangePasswordBottomsheet({Key? key}) : super(key: key);

  @override
  State<ChangePasswordBottomsheet> createState() =>
      _ChangePasswordBottomsheetState();
}

class _ChangePasswordBottomsheetState extends State<ChangePasswordBottomsheet> {
  final TextEditingController _currentPasswordTextEditingController =
      TextEditingController();
  final TextEditingController _newPasswordTextEditingController =
      TextEditingController();
  final TextEditingController _confirmNewPasswordTextEditingController =
      TextEditingController();

  bool _hideCurrentPassword = true;

  bool _hideNewPassword = true;

  bool _hideConfirmNewPassword = true;

  @override
  void dispose() {
    _currentPasswordTextEditingController.dispose();
    _newPasswordTextEditingController.dispose();
    _confirmNewPasswordTextEditingController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(
        horizontal: MediaQuery.of(context).size.width * (0.075),
        vertical: MediaQuery.of(context).size.height * (0.04),
      ),
      decoration: BoxDecoration(
        color: Theme.of(context).scaffoldBackgroundColor,
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(Utils.bottomSheetTopRadius),
          topRight: Radius.circular(Utils.bottomSheetTopRadius),
        ),
      ),
      child: SingleChildScrollView(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            BottomsheetTopTitleAndCloseButton(
              onTapCloseButton: () {
                if (context.read<ChangePasswordCubit>().state
                    is ChangePasswordInProgress) {
                  return;
                }
                Get.back();
              },
              titleKey: changePasswordKey,
            ),
            SizedBox(
              height: MediaQuery.of(context).size.height * (0.025),
            ),
            CustomTextFieldContainer(
              suffixWidget: PasswordHideShowButton(
                hidePassword: _hideCurrentPassword,
                onTap: () {
                  setState(() {
                    _hideCurrentPassword = !_hideCurrentPassword;
                  });
                },
              ),
              hideText: _hideCurrentPassword,
              hintTextKey: currentPasswordKey,
              textEditingController: _currentPasswordTextEditingController,
            ),
            CustomTextFieldContainer(
              suffixWidget: PasswordHideShowButton(
                hidePassword: _hideNewPassword,
                onTap: () {
                  setState(() {
                    _hideNewPassword = !_hideNewPassword;
                  });
                },
              ),
              hideText: _hideNewPassword,
              hintTextKey: newPasswordKey,
              textEditingController: _newPasswordTextEditingController,
            ),
            CustomTextFieldContainer(
              suffixWidget: PasswordHideShowButton(
                hidePassword: _hideConfirmNewPassword,
                onTap: () {
                  setState(() {
                    _hideConfirmNewPassword = !_hideConfirmNewPassword;
                  });
                },
              ),
              hideText: _hideConfirmNewPassword,
              hintTextKey: confirmNewPasswordKey,
              textEditingController: _confirmNewPasswordTextEditingController,
            ),
            BlocConsumer<ChangePasswordCubit, ChangePasswordState>(
              listener: (context, state) {
                if (state is ChangePasswordFailure) {
                  Utils.showCustomSnackBar(
                    context: context,
                    errorMessage: Utils.getTranslatedLabel(state.errorMessage),
                    backgroundColor: Theme.of(context).colorScheme.error,
                  );
                } else if (state is ChangePasswordSuccess) {
                  Get.back(result: {
                    "error": false,
                  });
                }
              },
              builder: (context, state) {
                return PopScope(
                  canPop: context.read<ChangePasswordCubit>().state
                      is! ChangePasswordInProgress,
                  child: CustomRoundedButton(
                    onTap: () {
                      if (state is ChangePasswordInProgress) {
                        return;
                      }
                      FocusScope.of(context).unfocus();
                      if (_currentPasswordTextEditingController.text
                              .trim()
                              .isEmpty ||
                          _newPasswordTextEditingController.text
                              .trim()
                              .isEmpty ||
                          _confirmNewPasswordTextEditingController.text
                              .trim()
                              .isEmpty) {
                        Utils.showCustomSnackBar(
                          context: context,
                          errorMessage: Utils.getTranslatedLabel(
                            pleaseEnterAllFieldKey,
                          ),
                          backgroundColor: Theme.of(context).colorScheme.error,
                        );
                        return;
                      }

                      //new password and confirm password must be same
                      if (_newPasswordTextEditingController.text.trim() !=
                          _confirmNewPasswordTextEditingController.text
                              .trim()) {
                        Utils.showCustomSnackBar(
                          context: context,
                          errorMessage: Utils.getTranslatedLabel(
                            newPasswordAndConfirmSameKey,
                          ),
                          backgroundColor: Theme.of(context).colorScheme.error,
                        );
                        return;
                      }

                      //new password and confirm password must be same
                      if (_newPasswordTextEditingController.text.trim().length <
                          minimumPasswordLength) {
                        Utils.showCustomSnackBar(
                          context: context,
                          errorMessage: Utils.getTranslatedLabel(
                            minimumPasswordLenghtIs6CharactersKey,
                          ),
                          backgroundColor: Theme.of(context).colorScheme.error,
                        );
                        return;
                      }

                      context.read<ChangePasswordCubit>().changePassword(
                            currentPassword:
                                _currentPasswordTextEditingController.text
                                    .trim(),
                            newPassword:
                                _newPasswordTextEditingController.text.trim(),
                            newConfirmedPassword:
                                _confirmNewPasswordTextEditingController.text
                                    .trim(),
                          );
                    },
                    height: 40,
                    textSize: 16.0,
                    widthPercentage: 0.45,
                    titleColor: Theme.of(context).scaffoldBackgroundColor,
                    backgroundColor: Theme.of(context).colorScheme.primary,
                    buttonTitle: Utils.getTranslatedLabel(
                      state is ChangePasswordInProgress
                          ? submittingKey
                          : submitKey,
                    ),
                    showBorder: false,
                  ),
                );
              },
            ),
          ],
        ),
      ),
    );
  }
}
