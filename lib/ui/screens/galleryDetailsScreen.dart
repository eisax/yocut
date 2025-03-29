import 'package:cached_network_image/cached_network_image.dart';
import 'package:yocut/app/routes.dart';
import 'package:yocut/data/models/gallery.dart';
import 'package:yocut/data/models/sessionYear.dart';
import 'package:yocut/data/models/studyMaterial.dart';
import 'package:yocut/ui/widgets/customAppbar.dart';
import 'package:yocut/utils/labelKeys.dart';
import 'package:yocut/utils/utils.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';
import 'package:readmore/readmore.dart';
import 'package:youtube_player_flutter/youtube_player_flutter.dart';

class GalleryDetailsScreen extends StatefulWidget {
  final Gallery gallery;
  final SessionYear sessionYear;

  GalleryDetailsScreen(
      {Key? key, required this.gallery, required this.sessionYear})
      : super(key: key);

  static Widget routeInstance() {
    final arguments = Get.arguments as Map<String, dynamic>;
    return GalleryDetailsScreen(
      gallery: arguments['gallery'] as Gallery,
      sessionYear: arguments['sessionYear'] as SessionYear,
    );
  }

  @override
  State<GalleryDetailsScreen> createState() => _GalleryDetailsScreenState();
}

class _GalleryDetailsScreenState extends State<GalleryDetailsScreen> {
  String selectedTabTitleKey = photosKey;

  Duration tabChangeAnimationDuration = const Duration(milliseconds: 400);

  Widget _buildTabBarContainer() {
    return Container(
      width: MediaQuery.of(context).size.width,
      height: 60,
      decoration: BoxDecoration(
          color: Theme.of(context).colorScheme.primary.withValues(alpha: 0.08),
          borderRadius:
              BorderRadius.circular(Utils.bottomSheetTopRadius * (0.5))),
      child: LayoutBuilder(builder: (context, boxConstraints) {
        return Stack(
          children: [
            AnimatedAlign(
              duration: tabChangeAnimationDuration,
              curve: Curves.easeInOut,
              alignment: selectedTabTitleKey == photosKey
                  ? AlignmentDirectional.centerStart
                  : AlignmentDirectional.centerEnd,
              child: Container(
                margin: EdgeInsetsDirectional.all(10),
                width: boxConstraints.maxWidth * (0.5),
                height: boxConstraints.maxHeight,
                decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(
                        Utils.bottomSheetTopRadius * (0.5)),
                    color: Theme.of(context).scaffoldBackgroundColor),
                alignment: Alignment.center,
              ),
            ),
            Align(
              alignment: AlignmentDirectional.centerStart,
              child: GestureDetector(
                onTap: () {
                  setState(() {
                    selectedTabTitleKey = photosKey;
                  });
                },
                child: Container(
                  width: boxConstraints.maxWidth * (0.5),
                  height: boxConstraints.maxHeight,
                  decoration: BoxDecoration(
                      border: Border.all(color: Colors.transparent)),
                  alignment: Alignment.center,
                  child: Text(
                    Utils.getTranslatedLabel(photosKey),
                    style:
                        TextStyle(fontSize: 16.0, fontWeight: FontWeight.w600),
                  ),
                ),
              ),
            ),
            Align(
              alignment: AlignmentDirectional.centerEnd,
              child: GestureDetector(
                onTap: () {
                  setState(() {
                    selectedTabTitleKey = videosKey;
                  });
                },
                child: Container(
                  alignment: Alignment.center,
                  width: boxConstraints.maxWidth * (0.5),
                  height: boxConstraints.maxHeight,
                  decoration: BoxDecoration(
                      border: Border.all(color: Colors.transparent)),
                  child: Text(
                    Utils.getTranslatedLabel(videosKey),
                    style:
                        TextStyle(fontSize: 16.0, fontWeight: FontWeight.w600),
                  ),
                ),
              ),
            ),
          ],
        );
      }),
    );
  }

  Widget _buildPhotosContainer() {
    return LayoutBuilder(builder: (context, boxConstraints) {
      return Wrap(
        runSpacing: 20,
        spacing: boxConstraints.maxWidth * (0.04),
        children: widget.gallery
            .getImages()
            .map((galleryFile) => GestureDetector(
                  onTap: () {
                    Get.toNamed(Routes.galleryImages, arguments: {
                      "currentImageIndex": widget.gallery
                          .getImages()
                          .indexWhere(
                              (element) => element.id == galleryFile.id),
                      "images": widget.gallery.getImages(),
                    });
                  },
                  child: Container(
                    decoration: BoxDecoration(
                        image: galleryFile.isSvgImage()
                            ? null
                            : DecorationImage(
                                image: CachedNetworkImageProvider(
                                    galleryFile.fileUrl ?? ""),
                                fit: BoxFit.cover),
                        borderRadius: BorderRadius.circular(
                          Utils.bottomSheetTopRadius,
                        )),
                    child: galleryFile.isSvgImage()
                        ? ClipRRect(
                            borderRadius: BorderRadius.circular(
                              Utils.bottomSheetTopRadius,
                            ),
                            child: SvgPicture.network(galleryFile.fileUrl ?? "",
                                fit: BoxFit.cover),
                          )
                        : null,
                    width: boxConstraints.maxWidth * (0.48),
                    height: boxConstraints.maxWidth * (0.48),
                  ),
                ))
            .toList(),
      );
    });
  }

  Widget _buildVideosContainer() {
    return Column(
      children: widget.gallery
          .getVideos()
          .map((galleryFile) => Container(
                margin: EdgeInsets.only(bottom: 15),
                width: MediaQuery.of(context).size.width,
                height: 175,
                decoration: BoxDecoration(
                    color: Theme.of(context)
                        .colorScheme
                        .secondary
                        .withValues(alpha: 0.1),
                    borderRadius:
                        BorderRadius.circular(Utils.bottomSheetTopRadius)),
                child: Stack(
                  children: [
                    ClipRRect(
                      borderRadius:
                          BorderRadius.circular(Utils.bottomSheetTopRadius),
                      child: YoutubePlayer(
                          controller: YoutubePlayerController(
                        initialVideoId: YoutubePlayer.convertUrlToId(
                              galleryFile.fileUrl ?? "",
                            ) ??
                            "",
                        flags: const YoutubePlayerFlags(
                          autoPlay: false,
                          hideThumbnail: true,
                          hideControls: true,
                        ),
                      )),
                    ),
                    GestureDetector(
                      onTap: () {
                        final StudyMaterial currentPlayingVideo = StudyMaterial(
                            fileExtension: "",
                            fileUrl: galleryFile.fileUrl ?? "",
                            fileThumbnail: "",
                            fileName: "",
                            id: galleryFile.id ?? 0,
                            studyMaterialType: StudyMaterialType.youtubeVideo);

                        Get.toNamed(Routes.playVideo, arguments: {
                          "currentlyPlayingVideo": currentPlayingVideo,
                          "relatedVideos": List<StudyMaterial>.from([]),
                        });
                      },
                      child: Container(
                        color: Colors.transparent,
                        width: MediaQuery.of(context).size.width,
                        height: 175,
                      ),
                    ),
                  ],
                ),
              ))
          .toList(),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: Stack(
      children: [
        SingleChildScrollView(
          padding: EdgeInsets.only(
            left: Utils.screenContentHorizontalPadding,
            right: Utils.screenContentHorizontalPadding,
            bottom: 25,
            top: 200 +
                MediaQuery.of(context).size.height *
                    (Utils.appBarSmallerHeightPercentage * (0.7)),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(
                height: 25,
              ),
              Text(
                widget.gallery.title ?? "",
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
              ),
              const SizedBox(
                height: 2.5,
              ),
              ReadMoreText(
                widget.gallery.description ?? "",
                trimLines: 3,
                trimMode: TrimMode.Line,
                trimCollapsedText: Utils.getTranslatedLabel(showMoreKey),
                style: TextStyle(
                    color: Theme.of(context)
                        .colorScheme
                        .secondary
                        .withValues(alpha: 0.65)),
                trimExpandedText: '',
                moreStyle: TextStyle(fontWeight: FontWeight.bold),
              ),
              const SizedBox(
                height: 25,
              ),
              _buildTabBarContainer(),
              const SizedBox(
                height: 25,
              ),
              AnimatedSwitcher(
                duration: tabChangeAnimationDuration,
                child: selectedTabTitleKey == photosKey
                    ? _buildPhotosContainer()
                    : _buildVideosContainer(),
              ),
              const SizedBox(
                height: 25,
              ),
            ],
          ),
        ),
        CustomAppBar(
          title: widget.sessionYear.name ?? "",
        ),
        Padding(
          padding: EdgeInsets.only(
              top: MediaQuery.of(context).size.height *
                  (Utils.appBarSmallerHeightPercentage * (0.7))),
          child: Container(
            height: 200,
            width: MediaQuery.of(context).size.width,
            decoration: BoxDecoration(
              color: Theme.of(context).scaffoldBackgroundColor,
              borderRadius: BorderRadius.circular(Utils.bottomSheetTopRadius),
            ),
            margin: EdgeInsets.symmetric(
              horizontal: Utils.screenContentHorizontalPadding,
            ),
            child: widget.gallery.isThumbnailSvg()
                ? SvgPicture.network(
                    widget.gallery.thumbnail ?? "",
                    fit: BoxFit.cover,
                  )
                : ClipRRect(
                    borderRadius:
                        BorderRadius.circular(Utils.bottomSheetTopRadius),
                    child: CachedNetworkImage(
                      imageUrl: widget.gallery.thumbnail ?? "",
                      fit: BoxFit.cover,
                    ),
                  ),
          ),
        ),
      ],
    ));
  }
}
