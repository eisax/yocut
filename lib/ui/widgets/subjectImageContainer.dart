import 'package:cached_network_image/cached_network_image.dart';

import 'package:yocut/data/models/subject.dart';
import 'package:yocut/ui/widgets/subjectFirstLetterContainer.dart';
import 'package:yocut/utils/animationConfiguration.dart';
import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter_svg/svg.dart';

import '../../data/models/Student.dart';

class SubjectImageContainer extends StatelessWidget {
  final Module subject;
  final double height;
  final double width;
  final double radius;
  final BoxBorder? border;
  final bool showShadow;
  final bool animate;
  const SubjectImageContainer({
    super.key,
    this.border,
    required this.showShadow,
    required this.height,
    required this.radius,
    required this.subject,
    required this.width,
    this.animate = true,
  });

  @override
  Widget build(BuildContext context) {
    return Animate(
      effects: animate ? customItemFadeAppearanceEffects() : null,
      child: Container(
        decoration: BoxDecoration(
          border: border,
          image: DecorationImage(
                  fit: BoxFit.cover,
                  image: CachedNetworkImageProvider(subject.moduleName ?? ""),
                ),
          color: Theme.of(context).colorScheme.primary,
          borderRadius: BorderRadius.circular(radius),
        ),
        height: height,
        width: width,
        child: (subject.moduleCode).isNotEmpty
            ? SubjectCodeContainer(
              subjectCode: subject.moduleCode,
              )
            : Padding(
                    padding: EdgeInsets.symmetric(
                      horizontal: width * (0.25),
                      vertical: height * 0.25,
                    ),
                    child: SvgPicture.network(subject.moduleName),
                  ),
      ),
    );
  }
}
