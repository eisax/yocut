import 'package:yocut/cubits/authCubit.dart';
import 'package:yocut/cubits/subjectAnnouncementsCubit.dart';
import 'package:yocut/data/models/announcement.dart';
import 'package:yocut/ui/widgets/announcementDetailsContainer.dart';
import 'package:yocut/ui/widgets/errorContaineer.dart';
import 'package:yocut/ui/widgets/noDataContainer.dart';
import 'package:yocut/ui/widgets/shimmerLoaders/announcementShimmerLoadingContainer.dart';
import 'package:yocut/utils/animationConfiguration.dart';

import 'package:yocut/utils/labelKeys.dart';
import 'package:yocut/utils/utils.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class AnnouncementContainer extends StatefulWidget {
  final int classSubjectId;
  final int? childId;
  const AnnouncementContainer(
      {Key? key, required this.classSubjectId, this.childId})
      : super(key: key);

  @override
  State<AnnouncementContainer> createState() => _AnnouncementContainerState();
}

class _AnnouncementContainerState extends State<AnnouncementContainer> {
  Widget _buildAnnouncementDetailsContainer({
    required Announcement subjectAnnouncement,
    required int index,
    required int totalAnnouncements,
    required bool hasMoreAnnouncements,
    required bool hasMoreAnnouncementsInProgress,
    required bool fetchMoreAnnouncementsFailure,
  }) {
    return Column(
      children: [
        Animate(
          effects: listItemAppearanceEffects(itemIndex: index),
          child: AnnouncementDetailsContainer(
            announcement: subjectAnnouncement,
          ),
        ),
        //show announcement loading container after last announcement container
        if (index == (totalAnnouncements - 1) &&
            hasMoreAnnouncements &&
            hasMoreAnnouncementsInProgress)
          const AnnouncementShimmerLoadingContainer(),

        if (index == (totalAnnouncements - 1) &&
            hasMoreAnnouncements &&
            fetchMoreAnnouncementsFailure)
          Center(
            child: CupertinoButton(
              child: Text(Utils.getTranslatedLabel(retryKey)),
              onPressed: () {
                context.read<SubjectAnnouncementCubit>().fetchMoreAnnouncements(
                      useParentApi: context.read<AuthCubit>().isParent(),
                      classSubjectId: widget.classSubjectId,
                      childId: widget.childId,
                    );
              },
            ),
          ),
      ],
    );
  }

  //
  @override
  Widget build(BuildContext context) {
    return BlocBuilder<SubjectAnnouncementCubit, SubjectAnnouncementState>(
      builder: (context, state) {
        if (state is SubjectAnnouncementFetchSuccess) {
          return state.announcements.isEmpty
              ? const NoDataContainer(titleKey: noAnnouncementKey)
              : Column(
                  children: List.generate(
                    state.announcements.length,
                    (index) => index,
                  )
                      .map(
                        (index) => _buildAnnouncementDetailsContainer(
                          subjectAnnouncement: state.announcements[index],
                          index: index,
                          totalAnnouncements: state.announcements.length,
                          hasMoreAnnouncements: context
                              .read<SubjectAnnouncementCubit>()
                              .hasMore(),
                          hasMoreAnnouncementsInProgress:
                              state.fetchMoreAnnouncementsInProgress,
                          fetchMoreAnnouncementsFailure:
                              state.moreAnnouncementsFetchError,
                        ),
                      )
                      .toList(),
                );
        }

        if (state is SubjectAnnouncementFetchFailure) {
          return ErrorContainer(
            errorMessageCode: state.errorMessage,
            onTapRetry: () {
              context.read<SubjectAnnouncementCubit>().fetchSubjectAnnouncement(
                    classSubjectId: widget.classSubjectId,
                    useParentApi: context.read<AuthCubit>().isParent(),
                    childId: widget.childId,
                  );
            },
          );
        }

        return Column(
          children: List.generate(
            Utils.defaultShimmerLoadingContentCount,
            (index) => index,
          ).map((e) => const AnnouncementShimmerLoadingContainer()).toList(),
        );
      },
    );
  }
}
