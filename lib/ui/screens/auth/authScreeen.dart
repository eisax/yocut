import 'package:yocut/app/routes.dart';
import 'package:yocut/cubits/appConfigurationCubit.dart';
import 'package:yocut/ui/widgets/customRoundedButton.dart';
import 'package:yocut/utils/labelKeys.dart';
import 'package:yocut/utils/utils.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get/get.dart';
import 'package:lottie/lottie.dart';

class AuthScreen extends StatefulWidget {
  const AuthScreen({super.key});

  @override
  State<AuthScreen> createState() => _AuthScreenState();

  static Widget routeInstance() {
    return AuthScreen();
  }
}

class _AuthScreenState extends State<AuthScreen> with TickerProviderStateMixin {
  late final AnimationController _bottomMenuHeightAnimationController =
      AnimationController(
    vsync: this,
    duration: const Duration(milliseconds: 600),
  );

  late final Animation<double> _bottomMenuHeightUpAnimation =
      Tween<double>(begin: 0.0, end: 1.0).animate(
    CurvedAnimation(
      parent: _bottomMenuHeightAnimationController,
      curve: const Interval(0.0, 0.6, curve: Curves.easeInOut),
    ),
  );
  late final Animation<double> _bottomMenuHeightDownAnimation =
      Tween<double>(begin: 0.0, end: 1.0).animate(
    CurvedAnimation(
      parent: _bottomMenuHeightAnimationController,
      curve: const Interval(0.6, 1.0, curve: Curves.easeInOut),
    ),
  );
  var canPop = false;

  Future<void> startAnimation() async {
    //cupertino page transtion duration
    await Future.delayed(const Duration(milliseconds: 300));

    _bottomMenuHeightAnimationController.forward();
  }

  @override
  void initState() {
    super.initState();
    startAnimation();
  }

  @override
  void dispose() {
    _bottomMenuHeightAnimationController.dispose();
    super.dispose();
  }

  Widget _buildLottieAnimation() {
    return Align(
      alignment: Alignment.topCenter,
      child: Container(
        width: MediaQuery.of(context).size.width,
        margin: EdgeInsets.only(
          top: MediaQuery.of(context).padding.top +
              MediaQuery.of(context).size.height * (0.05),
        ),
        height: MediaQuery.of(context).size.height * (0.4),
        child: Lottie.asset("assets/animations/onboarding.json"),
      ),
    );
  }

  Widget _buildBottomMenu() {
    return Align(
      alignment: Alignment.bottomCenter,
      child: AnimatedBuilder(
        animation: _bottomMenuHeightAnimationController,
        builder: (context, child) {
          final height = MediaQuery.of(context).size.height *
                  (0.525) *
                  _bottomMenuHeightUpAnimation.value -
              MediaQuery.of(context).size.height *
                  (0.05) *
                  _bottomMenuHeightDownAnimation.value;
          return Container(
            width: MediaQuery.of(context).size.width,
            height: height,
            decoration: BoxDecoration(
              color: Theme.of(context).scaffoldBackgroundColor,
              borderRadius: const BorderRadius.only(
                topLeft: Radius.circular(30.0),
                topRight: Radius.circular(30.0),
              ),
            ),
            child: AnimatedSwitcher(
              switchInCurve: Curves.easeInOut,
              duration: const Duration(milliseconds: 400),
              child: _bottomMenuHeightAnimationController.value != 1.0
                  ? const SizedBox()
                  : LayoutBuilder(
                      builder: (context, boxConstraints) {
                        return Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            //

                            Padding(
                              padding: EdgeInsets.symmetric(
                                horizontal:
                                    MediaQuery.of(context).size.width * (0.1),
                              ),
                              child: Text(
                                context
                                    .read<AppConfigurationCubit>()
                                    .getAppConfiguration()
                                    .tagline,
                                textAlign: TextAlign.center,
                                maxLines: 3,
                                overflow: TextOverflow.ellipsis,
                                style: TextStyle(
                                  fontSize: 16.0,
                                  fontWeight: FontWeight.w300,
                                  color:
                                      Utils.getColorScheme(context).onSurface,
                                ),
                              ),
                            ),
                            SizedBox(
                              height: boxConstraints.maxHeight * (0.05),
                            ),
                            CustomRoundedButton(
                              onTap: () {
                                Get.toNamed(
                                  Routes.studentLogin,
                                );
                              },
                              widthPercentage: 0.8,
                              backgroundColor:
                                  Utils.getColorScheme(context).primary,
                              buttonTitle:
                                  "${Utils.getTranslatedLabel(loginAsKey)} ${Utils.getTranslatedLabel(studentKey)}",
                              showBorder: false,
                            ),
                            SizedBox(
                              height: boxConstraints.maxHeight * (0.04),
                            ),
                            CustomRoundedButton(
                              onTap: () {
                                Get.toNamed(Routes.parentLogin);
                              },
                              widthPercentage: 0.8,
                              backgroundColor:
                                  Theme.of(context).scaffoldBackgroundColor,
                              buttonTitle:
                                  "${Utils.getTranslatedLabel(loginAsKey)} ${Utils.getTranslatedLabel(parentKey)}",
                              titleColor: Utils.getColorScheme(context).primary,
                              showBorder: true,
                              borderColor:
                                  Utils.getColorScheme(context).primary,
                            ),
                          ],
                        );
                      },
                    ),
            ),
          );
        },
      ),
    );
  }

  void _onWillPop() {
    setState(() {
      canPop = true;
    });
    Utils.showCustomSnackBar(
      context: context,
      errorMessage: Utils.getTranslatedLabel(pressbackagaintoexitKey),
      backgroundColor: Theme.of(context).colorScheme.error,
    ); // Do not exit the app
    Future.delayed(Duration(seconds: 2), () {
      setState(() {
        canPop = false;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return PopScope(
      canPop: canPop,
      onPopInvokedWithResult: (didPop, _) {
        if (didPop) return;

        _onWillPop();
      },
      child: Scaffold(
        backgroundColor: Theme.of(context).colorScheme.primary,
        body:Center(
          child:Text("Hey")
        )
        // body: Stack(
        //   children: [
        //     _buildLottieAnimation(),
        //     _buildBottomMenu(),
        //   ],
        // ),
      ),
    );
  }
}
