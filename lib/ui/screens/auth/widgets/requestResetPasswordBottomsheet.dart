import 'package:yocut/cubits/resetPasswordRequestCubit.dart';
import 'package:yocut/ui/widgets/bottomsheetTopTitleAndCloseButton.dart';
import 'package:yocut/ui/widgets/customRoundedButton.dart';
import 'package:yocut/ui/widgets/customTextFieldContainer.dart';
import 'package:yocut/utils/hiveBoxKeys.dart';
import 'package:yocut/utils/labelKeys.dart';
import 'package:yocut/utils/utils.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get/route_manager.dart';

class RequestResetPasswordBottomsheet extends StatefulWidget {
  const RequestResetPasswordBottomsheet({super.key});

  @override
  State<RequestResetPasswordBottomsheet> createState() =>
      _RequestResetPasswordBottomsheetState();
}

class _RequestResetPasswordBottomsheetState
    extends State<RequestResetPasswordBottomsheet> {
  final TextEditingController _grNumberTextEditingController =
      TextEditingController();
  final TextEditingController _schoolCodeController = TextEditingController();

  DateTime? dateOfBirth;

  @override
  void dispose() {
    _grNumberTextEditingController.dispose();
    _schoolCodeController.dispose();

    super.dispose();
  }

  String _formatDateOfBirth() {
    return Utils.formatDate(dateOfBirth!);
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      // margin: MediaQuery.of(context).viewInsets,
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
                if (context.read<RequestResetPasswordCubit>().state
                    is RequestResetPasswordInProgress) {
                  return;
                }
                Get.back();
              },
              titleKey: resetPasswordKey,
            ),
            CustomTextFieldContainer(
              hideText: false,
              hintTextKey: schoolCodeKey,
              textEditingController: _schoolCodeController,
            ),
            CustomTextFieldContainer(
              hideText: false,
              hintTextKey: grNumberKey,
              textEditingController: _grNumberTextEditingController,
            ),
            GestureDetector(
              onTap: () {
                showDatePicker(
                  builder: (context, child) {
                    return Theme(
                      data: Theme.of(context).copyWith(
                        colorScheme: Theme.of(context).colorScheme.copyWith(
                              onPrimary:
                                  Theme.of(context).scaffoldBackgroundColor,
                            ),
                      ),
                      child: child!,
                    );
                  },
                  context: context,
                  initialDate: DateTime.now(),
                  firstDate: DateTime(
                    DateTime.now().year - 50,
                  ),
                  lastDate: DateTime.now(),
                ).then((value) {
                  dateOfBirth = value;
                  setState(() {});
                });
              },
              child: Container(
                alignment: AlignmentDirectional.centerStart,
                width: MediaQuery.of(context).size.width,
                height: 50,
                margin: const EdgeInsets.only(bottom: 10.0),
                padding: const EdgeInsetsDirectional.only(
                  start: 20.0,
                ),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(10),
                  border: Border.all(
                    color: Utils.getColorScheme(context).secondary,
                  ),
                ),
                child: Text(
                  dateOfBirth == null
                      ? Utils.getTranslatedLabel(dateOfBirthKey)
                      : _formatDateOfBirth(),
                  style: TextStyle(
                    color: Utils.getColorScheme(context).secondary,
                    fontSize: 16,
                  ),
                ),
              ),
            ),
            SizedBox(
              height: MediaQuery.of(context).size.height * (0.025),
            ),
            BlocConsumer<RequestResetPasswordCubit, RequestResetPasswordState>(
              listener: (context, state) {
                if (state is RequestResetPasswordFailure) {
                  Utils.showCustomSnackBar(
                    context: context,
                    errorMessage: state.errorMessage,
                    backgroundColor: Theme.of(context).colorScheme.error,
                  );
                } else if (state is RequestResetPasswordSuccess) {
                  Get.back(result: {
                    "error": false,
                  });
                }
              },
              builder: (context, state) {
                return PopScope(
                  canPop: context.read<RequestResetPasswordCubit>().state
                      is! RequestResetPasswordInProgress,
                  child: CustomRoundedButton(
                    onTap: () {
                      if (state is RequestResetPasswordInProgress) {
                        return;
                      }
                      FocusScope.of(context).unfocus();
                      if (_grNumberTextEditingController.text.trim().isEmpty) {
                        Utils.showCustomSnackBar(
                          context: context,
                          errorMessage: Utils.getTranslatedLabel(
                            enterGrNumberKey,
                          ),
                          backgroundColor: Theme.of(context).colorScheme.error,
                        );
                        return;
                      }
                      if (dateOfBirth == null) {
                        Utils.showCustomSnackBar(
                          context: context,
                          errorMessage: Utils.getTranslatedLabel(
                            selectDateOfBirthKey,
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
                          .read<RequestResetPasswordCubit>()
                          .requestResetPassword(
                            schoolCode: _schoolCodeController.text.trim(),
                            grNumber:
                                _grNumberTextEditingController.text.trim(),
                            dob: dateOfBirth!,
                          );
                    },
                    height: 40,
                    textSize: 16.0,
                    widthPercentage: 0.45,
                    titleColor: Theme.of(context).scaffoldBackgroundColor,
                    backgroundColor: Theme.of(context).colorScheme.primary,
                    buttonTitle: Utils.getTranslatedLabel(
                      state is RequestResetPasswordInProgress
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
