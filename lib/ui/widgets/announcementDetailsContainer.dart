import 'package:yocut/data/models/announcement.dart';
import 'package:yocut/ui/widgets/studyMaterialWithDownloadButtonContainer.dart';
import 'package:flutter/material.dart';

import 'package:timeago/timeago.dart' as timeago;

class AnnouncementDetailsContainer extends StatelessWidget {
  final Announcement announcement;
  const AnnouncementDetailsContainer({super.key, required this.announcement});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 20),
      padding: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 15.0),
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.surface,
        borderRadius: BorderRadius.circular(10.0),
      ),
      width: MediaQuery.of(context).size.width * (0.85),
      child: LayoutBuilder(
        builder: (context, boxConstraints) {
          return Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                announcement.title,
                style: TextStyle(
                  height: 1.2,
                  color: Theme.of(context).colorScheme.secondary,
                  fontSize: 15.0,
                ),
              ),
              SizedBox(
                height: announcement.description.isEmpty ? 0 : 5,
              ),
              announcement.description.isEmpty
                  ? const SizedBox()
                  : Text(
                      announcement.description,
                      style: TextStyle(
                        height: 1.2,
                        color: Theme.of(context).colorScheme.secondary,
                        fontWeight: FontWeight.w400,
                        fontSize: 11.5,
                      ),
                    ),
              ...announcement.files
                  .map(
                    (studyMaterial) => StudyMaterialWithDownloadButtonContainer(
                      boxConstraints: boxConstraints,
                      studyMaterial: studyMaterial,
                    ),
                  )
                  ,
              SizedBox(
                height: announcement.files.isNotEmpty ? 0 : 5,
              ),
              Text(
                timeago.format(announcement.createdAt),
                style: TextStyle(
                  color:
                      Theme.of(context).colorScheme.onSurface.withValues(alpha: 0.75),
                  fontWeight: FontWeight.w400,
                  fontSize: 10,
                ),
                textAlign: TextAlign.start,
              )
            ],
          );
        },
      ),
    );
  }
}
