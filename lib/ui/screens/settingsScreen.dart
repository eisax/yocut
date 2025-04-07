import 'package:yocut/ui/widgets/settingsContainer.dart';
import 'package:flutter/material.dart';

class SettingsScreen extends StatelessWidget {
  const SettingsScreen({super.key});

  static Widget routeInstance() {
    return const SettingsScreen();
  }

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      body: SettingsContainer(),
    );
  }
}
