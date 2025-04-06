import 'package:yocut/ui/styles/colors.dart';
import 'package:yocut/utils/utils.dart';
import 'package:flutter/material.dart';

class CustomShimmerContainer extends StatelessWidget {
  final double? height;
  final double? width;
  final double? borderRadius;
  final EdgeInsetsGeometry? margin;
  const CustomShimmerContainer({
    super.key,
    this.height,
    this.width,
    this.borderRadius,
    this.margin,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: width,
      margin: margin,
      height: height ?? Utils.shimmerLoadingContainerDefaultHeight,
      decoration: BoxDecoration(
        color: shimmerContentColor,
        borderRadius: BorderRadius.circular(borderRadius ?? 10),
      ),
    );
  }
}
