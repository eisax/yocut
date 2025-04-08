import 'package:yocut/app/routes.dart';
import 'package:yocut/cubits/authCubit.dart';
import 'package:yocut/cubits/resetPasswordRequestCubit.dart';
import 'package:yocut/cubits/signInCubit.dart';
import 'package:yocut/data/repositories/authRepository.dart';
import 'package:yocut/ui/screens/auth/widgets/requestResetPasswordBottomsheet.dart';
import 'package:yocut/ui/screens/auth/widgets/termsAndConditionAndPrivacyPolicyContainer.dart';
import 'package:yocut/ui/widgets/customCircularProgressIndicator.dart';
import 'package:yocut/ui/widgets/customRoundedButton.dart';
import 'package:yocut/ui/widgets/customTextFieldContainer.dart';
import 'package:yocut/ui/widgets/passwordHideShowButton.dart';
import 'package:yocut/utils/constants.dart';
import 'package:yocut/utils/labelKeys.dart';
import 'package:yocut/utils/utils.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';

class StudentLoginScreen extends StatefulWidget {
  const StudentLoginScreen({super.key});

  @override
  State<StudentLoginScreen> createState() => _StudentLoginScreenState();

  static Widget routeInstance() {
    return MultiBlocProvider(
      providers: [
        BlocProvider<SignInCubit>(
          create: (_) => SignInCubit(AuthRepository()),
        ),
      ],
      child: const StudentLoginScreen(),
    );
  }
}

class _StudentLoginScreenState extends State<StudentLoginScreen>
    with TickerProviderStateMixin {
  late final AnimationController _animationController = AnimationController(
    vsync: this,
    duration: const Duration(milliseconds: 1000),
  );

  late final Animation<double> _patterntAnimation =
      Tween<double>(begin: 0.0, end: 1.0).animate(
    CurvedAnimation(
      parent: _animationController,
      curve: const Interval(0.0, 0.5, curve: Curves.easeInOut),
    ),
  );

  late final Animation<double> _formAnimation =
      Tween<double>(begin: 0.0, end: 1.0).animate(
    CurvedAnimation(
      parent: _animationController,
      curve: const Interval(0.5, 1.0, curve: Curves.easeInOut),
    ),
  );

  final TextEditingController _grNumberTextEditingController =
      TextEditingController(
          text: showDefaultCredentials
              ? defaultStudentGRNumber
              : null); //default grNumber

  final TextEditingController _passwordTextEditingController =
      TextEditingController(
          text: showDefaultCredentials
              ? defaultStudentPassword
              : null); //default password

  final _schoolCodeController = TextEditingController(
    text: showDefaultCredentials ? defaultSchoolCode : null,
  );

  bool _hidePassword = true;

  @override
  void initState() {
    super.initState();
    _animationController.forward();
  }

  @override
  void dispose() {
    _animationController.dispose();
    _grNumberTextEditingController.dispose();
    _passwordTextEditingController.dispose();
    super.dispose();
  }

  void _signInStudent() {
    if (_schoolCodeController.text.trim().isEmpty) {
      Utils.showCustomSnackBar(
        context: context,
        errorMessage: Utils.getTranslatedLabel(
          Utils.getTranslatedLabel("pleaseEnterSchoolCode"),
        ),
        backgroundColor: Theme.of(context).colorScheme.error,
      );
      return;
    }

    if (_grNumberTextEditingController.text.trim().isEmpty) {
      Utils.showCustomSnackBar(
        context: context,
        errorMessage: Utils.getTranslatedLabel(pleaseEnterGRNumberKey),
        backgroundColor: Theme.of(context).colorScheme.error,
      );
      return;
    }

    if (_passwordTextEditingController.text.trim().isEmpty) {
      Utils.showCustomSnackBar(
        context: context,
        errorMessage: Utils.getTranslatedLabel(pleaseEnterPasswordKey),
        backgroundColor: Theme.of(context).colorScheme.error,
      );
      return;
    }

    context.read<SignInCubit>().signInUser(
          userId: _grNumberTextEditingController.text.trim(),
          password: _passwordTextEditingController.text.trim(),
          schoolCode: _schoolCodeController.text.trim(),
          isStudentLogin: true,
        );
  }

  Widget _buildRequestResetPasswordContainer() {
    return Align(
      alignment: AlignmentDirectional.centerEnd,
      child: Padding(
        padding: const EdgeInsets.only(top: 8),
        child: GestureDetector(
          onTap: () {
            Utils.showBottomSheet(
              child: BlocProvider(
                create: (_) => RequestResetPasswordCubit(AuthRepository()),
              child: const RequestResetPasswordBottomsheet(),
              ),
              context: context,
            ).then((value) {
              if (value != null && !value['error']) {
                Utils.showCustomSnackBar(
                  context: context,
                  errorMessage: Utils.getTranslatedLabel(
                    passwordResetRequestKey,
                  ),
                  backgroundColor: Theme.of(context).colorScheme.onPrimary,
                );
              }
            });
          },
          child: Text(
            "${Utils.getTranslatedLabel(resetPasswordKey)}?",
            style: TextStyle(color: Theme.of(context).colorScheme.primary),
          ),
        ),
      ),
    );
  }

  Widget _buildUpperPattern() {
    return Align(
      alignment: AlignmentDirectional.topEnd,
      child: FadeTransition(
        opacity: _patterntAnimation,
        child: SlideTransition(
          position: _patterntAnimation.drive(
            Tween<Offset>(begin: const Offset(0.0, -1.0), end: Offset.zero),
          ),
          child: Image.asset(Utils.getImagePath("upper_pattern.png")),
        ),
      ),
    );
  }

  Widget _buildLowerPattern() {
    return Align(
      alignment: AlignmentDirectional.bottomStart,
      child: FadeTransition(
        opacity: _patterntAnimation,
        child: SlideTransition(
          position: _patterntAnimation.drive(
            Tween<Offset>(begin: const Offset(0.0, 1.0), end: Offset.zero),
          ),
          child: Image.asset(Utils.getImagePath("lower_pattern.png")),
        ),
      ),
    );
  }

  Widget _buildLoginForm() {
    return Align(
      alignment: Alignment.topCenter,
      child: FadeTransition(
        opacity: _formAnimation,
        child: SizedBox(
          height: MediaQuery.of(context).size.height,
          child: NotificationListener(
            onNotification: (OverscrollIndicatorNotification overscroll) {
              overscroll.disallowIndicator();
              return true;
            },
            child: SingleChildScrollView(
              physics: const ClampingScrollPhysics(),
              padding: EdgeInsets.only(
                left: MediaQuery.of(context).size.width * (0.075),
                right: MediaQuery.of(context).size.width * (0.075),
                top: MediaQuery.of(context).size.height * (0.25),
              ),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    Utils.getTranslatedLabel(letsSignInKey),
                    style: TextStyle(
                      fontSize: 34.0,
                      fontWeight: FontWeight.bold,
                      color: Utils.getColorScheme(context).secondary,
                    ),
                  ),
                  const SizedBox(
                    height: 10.0,
                  ),
                  Text(
                    "${Utils.getTranslatedLabel(welcomeBackKey)}, \n${Utils.getTranslatedLabel(youHaveBeenMissedKey)}",
                    style: TextStyle(
                      fontSize: 24.0,
                      height: 1.5,
                      color: Utils.getColorScheme(context).secondary,
                    ),
                  ),

                  /// School code field
                  // const SizedBox(height: 30.0),
                  // CustomTextFieldContainer(
                  //   hideText: false,
                  //   hintTextKey: Utils.getTranslatedLabel("schoolCode"),
                  //   bottomPadding: 0,
                  //   textEditingController: _schoolCodeController,
                  // ),

                  /// GR number field
                  const SizedBox(height: 30.0),
                  CustomTextFieldContainer(
                    hideText: false,
                    hintTextKey: grNumberKey,
                    bottomPadding: 0,
                    textEditingController: _grNumberTextEditingController,
                    suffixWidget: Padding(
                      padding: const EdgeInsets.all(12.0),
                      child: SvgPicture.asset(
                        Utils.getImagePath("user_icon.svg"),
                        colorFilter: ColorFilter.mode(
                          Utils.getColorScheme(context).secondary,
                          BlendMode.srcIn,
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(
                    height: 30.0,
                  ),
                  CustomTextFieldContainer(
                    textEditingController: _passwordTextEditingController,
                    suffixWidget: PasswordHideShowButton(
                      hidePassword: _hidePassword,
                      onTap: () {
                        setState(() {
                          _hidePassword = !_hidePassword;
                        });
                      },
                    ),
                    hideText: _hidePassword,
                    hintTextKey: passwordKey,
                    bottomPadding: 0,
                  ),
                  _buildRequestResetPasswordContainer(),
                  const SizedBox(height: 30.0),
                  Center(
                    child: BlocConsumer<SignInCubit, SignInState>(
                      listener: (context, state) {
                        if (state is SignInSuccess) {
                          //
                          context.read<AuthCubit>().authenticateUser(
                                schoolCode: state.schoolCode,
                                jwtToken: state.jwtToken,
                                isStudent: state.isStudentLogIn,
                                parent: state.parent,
                                student: state.student,
                              );

                          Get.offNamedUntil(Routes.studentOnbording,
                              (Route<dynamic> route) => false);
                        } else if (state is SignInFailure) {
                          Utils.showCustomSnackBar(
                            context: context,
                            errorMessage:
                                Utils.getTranslatedLabel(state.errorMessage),
                            backgroundColor:
                                Theme.of(context).colorScheme.error,
                          );
                        }
                      },
                      builder: (context, state) {
                        return CustomRoundedButton(
                          onTap: () {
                            if (state is SignInInProgress) {
                              return;
                            }
                            FocusScope.of(context).unfocus();

                            _signInStudent();
                          },
                          widthPercentage: 0.8,
                          backgroundColor:
                              Utils.getColorScheme(context).primary,
                          buttonTitle: Utils.getTranslatedLabel(signInKey),
                          titleColor: Theme.of(context).scaffoldBackgroundColor,
                          showBorder: false,
                          child: state is SignInInProgress
                              ? const CustomCircularProgressIndicator(
                                  strokeWidth: 2,
                                  widthAndHeight: 20,
                                )
                              : null,
                        );
                      },
                    ),
                  ),
                  const SizedBox(
                    height: 20.0,
                  ),
                  // BlocBuilder<SignInCubit, SignInState>(
                  //   builder: (context, state) {
                  //     return Center(
                  //       child: InkWell(
                  //         onTap: () {
                  //           if (state is SignInInProgress) {
                  //             return;
                  //           }
                  //           Get.offNamed(Routes.parentLogin);
                  //         },
                  //         child: RichText(
                  //           text: TextSpan(
                  //             children: [
                  //               TextSpan(
                  //                 style: TextStyle(
                  //                   fontSize: 16.0,
                  //                   color:
                  //                       Utils.getColorScheme(context).primary,
                  //                 ),
                  //                 text: Utils.getTranslatedLabel(
                  //                   loginAsKey,
                  //                 ),
                  //               ),
                  //               const TextSpan(text: " "),
                  //               TextSpan(
                  //                 style: TextStyle(
                  //                   fontWeight: FontWeight.w500,
                  //                   fontSize: 16.0,
                  //                   color:
                  //                       Utils.getColorScheme(context).secondary,
                  //                 ),
                  //                 text:
                  //                     "${Utils.getTranslatedLabel(parentKey)}?",
                  //               ),
                  //             ],
                  //           ),
                  //         ),
                  //       ),
                  //     );
                  //   },
                  // ),
                  // const SizedBox(
                  //   height: 20,
                  // ),
                  const TermsAndConditionAndPrivacyPolicyContainer(),
                  SizedBox(
                    height: MediaQuery.of(context).size.height * (0.025),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          _buildLowerPattern(),
          _buildUpperPattern(),
          _buildLoginForm(),
        ],
      ),
    );
  }
}
