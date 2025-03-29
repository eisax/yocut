import 'package:flutter/material.dart';

class CustomRefreshIndicator extends StatelessWidget {
  final Widget child;
  final Function onRefreshCallback;
  final double displacment;
  const CustomRefreshIndicator({
    Key? key,
    required this.child,
    required this.displacment,
    required this.onRefreshCallback,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return RefreshIndicator(
      displacement: displacment,
      onRefresh: () async {
        onRefreshCallback();
      },
      child: child,
    );
  }
}
