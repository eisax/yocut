import 'package:yocut/app/routes.dart';
import 'package:yocut/cubits/appConfigurationCubit.dart';
import 'package:yocut/cubits/authCubit.dart';
import 'package:yocut/ui/widgets/errorContaineer.dart';
import 'package:yocut/utils/animationConfiguration.dart';
import 'package:yocut/utils/utils.dart';
import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/route_manager.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();

  static Widget routeInstance() {
    return SplashScreen();
  }
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    super.initState();
    Future.delayed(Duration.zero, () {
    
      context.read<AppConfigurationCubit>().fetchAppConfiguration();
    });
  }

  void navigateToNextScreen()async {
    if (context.read<AuthCubit>().state is Unauthenticated) {
      Get.offNamed(Routes.auth);
    } else {
      if(await context.read<AuthCubit>().isTokenValidt()){
        Get.offNamed(
        (context.read<AuthCubit>().state as Authenticated).isStudent
            ? Routes.home
            : Routes.parentHome,
      );
      }else{
        Get.offNamed(Routes.auth);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: BlocConsumer<AppConfigurationCubit, AppConfigurationState>(
        listener: (context, appConfigState) {
          if (appConfigState is AppConfigurationFetchSuccess) {
            navigateToNextScreen();
          }
        },
        builder: (context, appConfigState) {
          if (appConfigState is AppConfigurationFetchFailure) {
            return Center(
              child: ErrorContainer(
                onTapRetry: () {
                  context.read<AppConfigurationCubit>().fetchAppConfiguration();
                },
                errorMessageCode: appConfigState.errorMessage,
              ),
            );
          }

          return Center(
            child: Animate(
              effects: customItemZoomAppearanceEffects(
                delay: const Duration(
                  milliseconds: 10,
                ),
                duration: const Duration(
                  seconds: 1,
                ),
              ),
              child: Padding(
                padding: const EdgeInsets.all(25.0),
                child: Image.asset(
                  Utils.getImagePath("appLogo.png"),
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}
