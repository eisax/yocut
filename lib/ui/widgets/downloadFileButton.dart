import 'package:yocut/data/models/studyMaterial.dart';

import 'package:yocut/utils/utils.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

class DownloadFileButton extends StatelessWidget {
  final StudyMaterial studyMaterial;
  const DownloadFileButton({super.key, required this.studyMaterial});

  @override
  Widget build(BuildContext context) {
    return InkWell(
      borderRadius: BorderRadius.circular(15),
      onTap: () async {
        Utils.openDownloadBottomsheet(
          context: context,
          storeInExternalStorage: true,
          studyMaterial: studyMaterial,
        );
      },
      child: Container(
        width: 30,
        height: 30,
        padding: const EdgeInsets.all(8.0),
        decoration: BoxDecoration(
          color: Theme.of(context).colorScheme.primary,
          shape: BoxShape.circle,
        ),
        child: SvgPicture.asset(Utils.getImagePath("download_icon.svg")),
      ),
    );
  }
}
