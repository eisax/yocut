import 'package:flutter/material.dart';

class TabBarBackgroundContainer extends StatelessWidget {
  final BoxConstraints boxConstraints;
  const TabBarBackgroundContainer({Key? key, required this.boxConstraints})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(5),
      decoration: BoxDecoration(
          border: Border.all(color: Theme.of(context).scaffoldBackgroundColor),
          borderRadius: BorderRadius.circular(15.0),),
      margin: EdgeInsets.only(
          left: boxConstraints.maxWidth * (0.1),
          right: boxConstraints.maxWidth * (0.1),
          top: boxConstraints.maxHeight * (0.125),),
      height: boxConstraints.maxHeight * (0.325),
      width: boxConstraints.maxWidth * (0.375),
      child: Container(
        decoration: BoxDecoration(
            color: Theme.of(context).scaffoldBackgroundColor,
            borderRadius: BorderRadius.circular(10.0),),
      ),
    );
  }
}
