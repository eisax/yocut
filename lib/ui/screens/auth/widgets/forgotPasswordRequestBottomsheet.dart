import 'package:yocut/cubits/forgotPasswordRequestCubit.dart';
import 'package:yocut/ui/widgets/bottomsheetTopTitleAndCloseButton.dart';
import 'package:yocut/ui/widgets/customRoundedButton.dart';
import 'package:yocut/ui/widgets/customTextFieldContainer.dart';
import 'package:yocut/utils/hiveBoxKeys.dart';
import 'package:yocut/utils/labelKeys.dart';
import 'package:yocut/utils/utils.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get/route_manager.dart';

class ForgotPasswordRequestBottomsheet extends StatefulWidget {
  const ForgotPasswordRequestBottomsheet({super.key});

  @override
  State<ForgotPasswordRequestBottomsheet> createState() =>
      _ForgotPasswordRequestBottomsheetState();
}

class _ForgotPasswordRequestBottomsheetState
    extends State<ForgotPasswordRequestBottomsheet> {
  final TextEditingController _emailTextEditingController =
      TextEditingController();
  final TextEditingController _schoolCodeController = TextEditingController();

  @override
  void dispose() {
    _emailTextEditingController.dispose();
    _schoolCodeController.dispose();
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
                if (context.read<ForgotPasswordRequestCubit>().state
                    is ForgotPasswordRequestInProgress) {
                  return;
                }
                Get.back();
              },
              titleKey: forgotPasswordKey,
            ),
            CustomTextFieldContainer(
              hideText: false,
              hintTextKey: schoolCodeKey,
              textEditingController: _schoolCodeController,
            ),
            CustomTextFieldContainer(
              hideText: false,
              hintTextKey: emailKey,
              textEditingController: _emailTextEditingController,
            ),
            SizedBox(
              height: MediaQuery.of(context).size.height * (0.025),
            ),
            BlocConsumer<ForgotPasswordRequestCubit,
                ForgotPasswordRequestState>(
              listener: (context, state) {
                if (state is ForgotPasswordRequestFailure) {
                  Utils.showCustomSnackBar(
                    context: context,
                    errorMessage: Utils.getTranslatedLabel(state.errorMessage),
                    backgroundColor: Theme.of(context).colorScheme.error,
                  );
                } else if (state is ForgotPasswordRequestSuccess) {
                  Get.back(result: {
                    "error": false,
                    "email": _emailTextEditingController.text.trim()
                  });
                }
              },
              builder: (context, state) {
                return PopScope(
                  canPop: context.read<ForgotPasswordRequestCubit>().state
                      is! ForgotPasswordRequestInProgress,
                  child: CustomRoundedButton(
                    onTap: () {
                      if (state is ForgotPasswordRequestInProgress) {
                        return;
                      }
                      FocusScope.of(context).unfocus();
                      if (_emailTextEditingController.text.trim().isEmpty) {
                        Utils.showCustomSnackBar(
                          context: context,
                          errorMessage: Utils.getTranslatedLabel(
                            pleaseEnterEmailKey,
                          ),
                          backgroundColor: Theme.of(context).colorScheme.error,
                        );
                        return;
                      }
                      if (_schoolCodeController.text.trim().isEmpty) {
                        Utils.showCustomSnackBar(
                          context: context,
                          errorMessage: Utils.getTranslatedLabel(
                            pleaseEnterSchoolCodeKey,
                          ),
                          backgroundColor: Theme.of(context).colorScheme.error,
                        );
                        return;
                      }

                      context
                          .read<ForgotPasswordRequestCubit>()
                          .requestforgotPassword(
                            schoolCode: _schoolCodeController.text.trim(),
                            email: _emailTextEditingController.text.trim(),
                          );
                    },
                    height: 40,
                    textSize: 16.0,
                    widthPercentage: 0.45,
                    titleColor: Theme.of(context).scaffoldBackgroundColor,
                    backgroundColor: Theme.of(context).colorScheme.primary,
                    buttonTitle: Utils.getTranslatedLabel(
                      state is ForgotPasswordRequestInProgress
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
