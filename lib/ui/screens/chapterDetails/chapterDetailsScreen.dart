import 'package:yocut/data/models/lesson.dart';
import 'package:yocut/data/models/studyMaterial.dart';
import 'package:yocut/ui/widgets/filesContainer.dart';
import 'package:yocut/ui/screens/chapterDetails/widgets/topicsContainer.dart';
import 'package:yocut/ui/widgets/videosContainer.dart';
import 'package:yocut/ui/widgets/customAppbar.dart';
import 'package:yocut/utils/labelKeys.dart';
import 'package:yocut/utils/utils.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class ChapterDetailsScreen extends StatefulWidget {
  final Lesson lesson;

  final int? childId;
  const ChapterDetailsScreen({super.key, required this.lesson, this.childId});

  @override
  State<ChapterDetailsScreen> createState() => _ChapterDetailsScreenState();

  static Widget routeInstance() {
    final arguments = Get.arguments as Map<String, dynamic>;

    return ChapterDetailsScreen(
      lesson: arguments['lesson'],
      childId: arguments['childId'],
    );
  }
}

class _ChapterDetailsScreenState extends State<ChapterDetailsScreen> {
  late String _selectedTabTitleKey = topicsKey;
  late List<String> chapterContentTitles = [topicsKey, filesKey, videosKey];

  Widget _buildAppBar() {
    return CustomAppBar(title: widget.lesson.name);
  }

  Widget _buildChapterContentTitles() {
    return Container(
      padding: EdgeInsets.symmetric(
        horizontal: MediaQuery.of(context).size.width * (0.1),
      ),
      height: 40,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: chapterContentTitles
            .map(
              (title) => GestureDetector(
                onTap: () {
                  setState(() {
                    _selectedTabTitleKey = title;
                  });
                },
                child: Container(
                  margin: const EdgeInsets.symmetric(horizontal: 10),
                  decoration: BoxDecoration(
                    color: _selectedTabTitleKey == title
                        ? Theme.of(context).colorScheme.primary
                        : Colors.transparent,
                    borderRadius: BorderRadius.circular(10),
                  ),
                  padding: const EdgeInsets.symmetric(horizontal: 15),
                  alignment: Alignment.center,
                  child: Text(
                    Utils.getTranslatedLabel(title),
                    style: TextStyle(
                      color: _selectedTabTitleKey == title
                          ? Theme.of(context).scaffoldBackgroundColor
                          : Theme.of(context).colorScheme.onSurface,
                    ),
                  ),
                ),
              ),
            )
            .toList(),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          Align(
            alignment: Alignment.topCenter,
            child: SingleChildScrollView(
              padding: EdgeInsets.only(
                top: Utils.getScrollViewTopPadding(
                  context: context,
                  appBarHeightPercentage: Utils.appBarSmallerHeightPercentage,
                ),
              ),
              child: Column(
                children: [
                  _buildChapterContentTitles(),
                  SizedBox(
                    height: MediaQuery.of(context).size.height * (0.025),
                  ),
                  _selectedTabTitleKey == topicsKey
                      ? TopicsContainer(
                          topics: widget.lesson.topics,
                          childId: widget.childId,
                        )
                      : _selectedTabTitleKey == filesKey
                          ? FilesContainer(
                              files: widget.lesson.studyMaterials
                                  .where(
                                    (element) =>
                                        element.studyMaterialType ==
                                        StudyMaterialType.file,
                                  )
                                  .toList(),
                            )
                          : VideosContainer(
                              studyMaterials: widget.lesson.studyMaterials
                                  .where(
                                    (element) =>
                                        element.studyMaterialType ==
                                            StudyMaterialType.youtubeVideo ||
                                        element.studyMaterialType ==
                                            StudyMaterialType.uploadedVideoUrl,
                                  )
                                  .toList(),
                            )
                ],
              ),
            ),
          ),
          Align(
            alignment: Alignment.topCenter,
            child: _buildAppBar(),
          ),
        ],
      ),
    );
  }
}
