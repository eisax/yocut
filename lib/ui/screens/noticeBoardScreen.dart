import 'package:yocut/ui/widgets/noticeBoardContainer.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class NoticeBoardScreen extends StatelessWidget {
  final int? childId;
  const NoticeBoardScreen({Key? key, this.childId}) : super(key: key);

  static Widget routeInstance() {
    return NoticeBoardScreen(
      childId: Get.arguments as int?,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: NoticeBoardContainer(
        childId: childId,
        showBackButton: true,
      ),
    );
  }
}
