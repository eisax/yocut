import 'package:yocut/app/routes.dart';
import 'package:yocut/data/models/topic.dart';
import 'package:yocut/ui/widgets/noDataContainer.dart';
import 'package:yocut/utils/animationConfiguration.dart';
import 'package:yocut/utils/labelKeys.dart';
import 'package:yocut/utils/utils.dart';
import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:get/get.dart';

class TopicsContainer extends StatelessWidget {
  final List<Topic> topics;
  final int? childId;
  const TopicsContainer({Key? key, required this.topics, this.childId})
      : super(key: key);

  Widget _buildTopicDetailsContainer({
    required Topic topic,
    required BuildContext context,
  }) {
    return Animate(
      effects: customItemFadeAppearanceEffects(),
      child: Padding(
        padding: const EdgeInsets.only(bottom: 20),
        child: InkWell(
          borderRadius: BorderRadius.circular(10.0),
          onTap: () {
            Get.toNamed(
              Routes.topicDetails,
              arguments: {"topic": topic, "childId": childId},
            );
          },
          child: Container(
            padding:
                const EdgeInsets.symmetric(horizontal: 20.0, vertical: 15.0),
            decoration: BoxDecoration(
              color: Theme.of(context).colorScheme.surface,
              borderRadius: BorderRadius.circular(10.0),
            ),
            width: MediaQuery.of(context).size.width * (0.85),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  Utils.getTranslatedLabel(topicNameKey),
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
                  topic.name,
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
                  Utils.getTranslatedLabel(topicDescriptionKey),
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
                  topic.description,
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
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: topics.isEmpty
          ? [
              const NoDataContainer(
                titleKey: noTopicsKey,
              )
            ]
          : topics
              .map(
                (topic) =>
                    _buildTopicDetailsContainer(topic: topic, context: context),
              )
              .toList(),
    );
  }
}
