import 'package:yocut/ui/widgets/customAppbar.dart';
import 'package:yocut/utils/labelKeys.dart';
import 'package:yocut/utils/utils.dart';
import 'package:flutter/material.dart';

class FaqsScreen extends StatelessWidget {
  const FaqsScreen({super.key});

  static Widget routeInstance() {
    return const FaqsScreen();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          SingleChildScrollView(
            padding: EdgeInsets.only(
              top: Utils.getScrollViewTopPadding(
                context: context,
                appBarHeightPercentage: Utils.appBarSmallerHeightPercentage,
              ),
            ),
            child: const Column(
              children: [Center(child: Text("About us data"))],
            ),
          ),
          CustomAppBar(title: Utils.getTranslatedLabel(faqsKey))
        ],
      ),
    );
  }
}
