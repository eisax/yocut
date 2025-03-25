import 'package:yocut/app/routes.dart';
import 'package:yocut/cubits/authCubit.dart';
import 'package:yocut/cubits/subjectLessonsCubit.dart';
import 'package:yocut/data/models/lesson.dart';
import 'package:yocut/ui/widgets/customShimmerContainer.dart';
import 'package:yocut/ui/widgets/errorContaineer.dart';
import 'package:yocut/ui/widgets/noDataContainer.dart';
import 'package:yocut/ui/widgets/shimmerLoadingContainer.dart';
import 'package:yocut/utils/animationConfiguration.dart';
import 'package:yocut/utils/labelKeys.dart';
import 'package:yocut/utils/utils.dart';
import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get/get.dart';

class ChaptersContainer extends StatefulWidget {
  final String classSubjectId;
  const ChaptersContainer(
      {super.key, required this.classSubjectId, this.childId});

  @override
  State<ChaptersContainer> createState() => _ChaptersContainerState();
}

class _ChaptersContainerState extends State<ChaptersContainer> {
  Widget _buildChapterDetailsContainer({required Lesson lesson}) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 20),
      child: InkWell(
        borderRadius: BorderRadius.circular(10.0),
        onTap: () {
          Get.toNamed(
            Routes.chapterDetails,
            arguments: {"lesson": lesson, "childId": widget.childId},
          );
        },
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 15.0),
          decoration: BoxDecoration(
            color: Theme.of(context).colorScheme.surface,
            borderRadius: BorderRadius.circular(10.0),
          ),
          width: MediaQuery.of(context).size.width * (0.85),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                Utils.getTranslatedLabel(chapterNameKey),
                style: TextStyle(
                  color: Theme.of(context).colorScheme.onSurface,
                  fontWeight: FontWeight.w400,
                  fontSize: 12.0,
                ),
                textAlign: TextAlign.start,
              ),
              const SizedBox(
                height: 2.5,
              ),
              Text(
                lesson.name,
                style: TextStyle(
                  color: Theme.of(context).colorScheme.secondary,
                  fontWeight: FontWeight.w600,
                  fontSize: 14.0,
                ),
                textAlign: TextAlign.start,
              ),
              const SizedBox(
                height: 15,
              ),
              Text(
                Utils.getTranslatedLabel(chapterDescriptionKey),
                style: TextStyle(
                  color: Theme.of(context).colorScheme.onSurface,
                  fontWeight: FontWeight.w400,
                  fontSize: 12.0,
                ),
                textAlign: TextAlign.start,
              ),
              const SizedBox(
                height: 2.5,
              ),
              Text(
                lesson.description,
                style: TextStyle(
                  color: Theme.of(context).colorScheme.secondary,
                  fontWeight: FontWeight.w600,
                  fontSize: 14.0,
                ),
                textAlign: TextAlign.start,
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildChapterDetailsShimmerContainer() {
    return Padding(
      padding: const EdgeInsets.only(bottom: 20),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 15.0),
        width: MediaQuery.of(context).size.width * (0.85),
        child: LayoutBuilder(
          builder: (context, boxConstraints) {
            return Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                ShimmerLoadingContainer(
                  child: CustomShimmerContainer(
                    margin: EdgeInsetsDirectional.only(
                      end: boxConstraints.maxWidth * (0.7),
                    ),
                  ),
                ),
                const SizedBox(
                  height: 5,
                ),
                ShimmerLoadingContainer(
                  child: CustomShimmerContainer(
                    margin: EdgeInsetsDirectional.only(
                      end: boxConstraints.maxWidth * (0.5),
                    ),
                  ),
                ),
                const SizedBox(
                  height: 15,
                ),
                ShimmerLoadingContainer(
                  child: CustomShimmerContainer(
                    margin: EdgeInsetsDirectional.only(
                      end: boxConstraints.maxWidth * (0.7),
                    ),
                  ),
                ),
                const SizedBox(
                  height: 5,
                ),
                ShimmerLoadingContainer(
                  child: CustomShimmerContainer(
                    margin: EdgeInsetsDirectional.only(
                      end: boxConstraints.maxWidth * (0.5),
                    ),
                  ),
                ),
              ],
            );
          },
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<SubjectLessonsCubit, SubjectLessonsState>(
      builder: (context, state) {
        if (state is SubjectLessonsFetchSuccess) {
          return state.lessons.isEmpty
              ? const NoDataContainer(titleKey: noChaptersKey)
              : Column(
                  children: List.generate(
                    state.lessons.length,
                    (index) => Animate(
                      effects: listItemAppearanceEffects(
                        itemIndex: index,
                        totalLoadedItems: state.lessons.length,
                      ),
                      child: _buildChapterDetailsContainer(
                        lesson: state.lessons[index],
                      ),
                    ),
                  ),
                );
        }
        if (state is SubjectLessonsFetchFailure) {
          return ErrorContainer(
            errorMessageCode: state.errorMessage,
            onTapRetry: () {
              // context.read<SubjectLessonsCubit>().fetchSubjectLessons(
              //       classSubjectId: widget.classSubjectId,
              //       useParentApi: context.read<AuthCubit>().isParent(),
              //       childId: widget.childId,
              //     );
            },
          );
        }
        return Column(
          children: List.generate(5, (index) => index)
              .map(
                (e) => _buildChapterDetailsShimmerContainer(),
              )
              .toList(),
        );
      },
    );
  }
}
