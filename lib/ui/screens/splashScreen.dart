import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:yocut/utils/animationConfiguration.dart';
import 'package:flutter_svg/svg.dart';
import 'package:yocut/utils/utils.dart';

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
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Animate(
          effects: customItemZoomAppearanceEffects(
            delay: const Duration(milliseconds: 10),
            duration: const Duration(seconds: 1),
          ),
          child: Padding(
            padding: const EdgeInsets.all(25.0),
            child: SvgPicture.asset(Utils.getImagePath("appLogo.svg"),),
          ),
        ),
      ),
    );
  }
}
