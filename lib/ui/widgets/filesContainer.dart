import 'package:yocut/data/models/studyMaterial.dart';
import 'package:yocut/ui/widgets/downloadFileButton.dart';
import 'package:yocut/ui/widgets/noDataContainer.dart';
import 'package:yocut/utils/animationConfiguration.dart';
import 'package:yocut/utils/labelKeys.dart';
import 'package:yocut/utils/utils.dart';

import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';

class FilesContainer extends StatefulWidget {
  final List<StudyMaterial> files;
  const FilesContainer({Key? key, required this.files}) : super(key: key);

  @override
  State<FilesContainer> createState() => _FilesContainerState();
}

class _FilesContainerState extends State<FilesContainer> {
  Widget _buildFileDetailsContainer(StudyMaterial file) {
    return Animate(
      effects: customItemFadeAppearanceEffects(),
      child: GestureDetector(
        onTap: () {
          Utils.openDownloadBottomsheet(
            context: context,
            storeInExternalStorage: false,
            studyMaterial: file,
          );
        },
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 10.0, vertical: 15.0),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(10),
            color: Theme.of(context).scaffoldBackgroundColor,
            boxShadow: [
              BoxShadow(
                color: Theme.of(context).colorScheme.secondary.withValues(alpha: 0.1),
                offset: const Offset(5, 5),
                blurRadius: 10,
              )
            ],
          ),
          height: 60,
          width: MediaQuery.of(context).size.width * (0.85),
          child: LayoutBuilder(
            builder: (context, boxConstraints) {
              return Row(
                children: [
                  SizedBox(
                    width: boxConstraints.maxWidth * (0.6),
                    child: Text(
                      "${file.fileName}.${file.fileExtension}",
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                      style: TextStyle(
                        color: Theme.of(context).colorScheme.onSurface,
                        fontWeight: FontWeight.w500,
                        fontSize: 13.0,
                      ),
                    ),
                  ),
                  const Spacer(),
                  DownloadFileButton(
                    studyMaterial: file,
                  ),
                ],
              );
            },
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: widget.files.isEmpty
          ? [const NoDataContainer(titleKey: noFilesUploadedKey)]
          : widget.files
              .map((file) => _buildFileDetailsContainer(file))
              .toList(),
    );
  }
}
