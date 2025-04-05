import 'package:cached_network_image/cached_network_image.dart';
import 'package:yocut/data/models/studyMaterial.dart';
import 'package:yocut/ui/screens/playVideo/widgets/videoControlsContainer.dart';
import 'package:yocut/ui/screens/playVideo/widgets/playPauseButton.dart';
import 'package:yocut/ui/widgets/customCircularProgressIndicator.dart';
import 'package:yocut/ui/widgets/svgButton.dart';
import 'package:yocut/utils/utils.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:lottie/lottie.dart';
import 'package:video_player/video_player.dart';
import 'package:youtube_player_flutter/youtube_player_flutter.dart';

class PlayVideoScreen extends StatefulWidget {
  final List<StudyMaterial> relatedVideos;
  final StudyMaterial currentlyPlayingVideo;
  const PlayVideoScreen({
    Key? key,
    required this.relatedVideos,
    required this.currentlyPlayingVideo,
  }) : super(key: key);

  @override
  State<PlayVideoScreen> createState() => _PlayVideoScreenState();

  static Widget routeInstance() {
    final arguments = Get.arguments as Map<String, dynamic>;
    return PlayVideoScreen(
      currentlyPlayingVideo:
          arguments['currentlyPlayingVideo'] as StudyMaterial,
      relatedVideos: arguments['relatedVideos'] as List<StudyMaterial>,
    );
  }
}

class _PlayVideoScreenState extends State<PlayVideoScreen>
    with TickerProviderStateMixin {
  late StudyMaterial currentlyPlayingStudyMaterialVideo =
      widget.currentlyPlayingVideo;

  final double _videoContainerPotraitHeightPercentage = 0.3;

  //need to use this to ensure youtube/video controller disposed properlly
  //When user changed the video so for 100 milliseconds we set assignedVideoController
  //to false
  late bool assignedVideoController = false;

  YoutubePlayerController? _youtubePlayerController;
  VideoPlayerController? _videoPlayerController;

  late final AnimationController controlsMenuAnimationController =
      AnimationController(
    vsync: this,
    duration: const Duration(milliseconds: 500),
  );

  late Animation<double> controlsMenuAnimation =
      Tween<double>(begin: 0.0, end: 1.0).animate(
    CurvedAnimation(
      parent: controlsMenuAnimationController,
      curve: Curves.easeInOut,
    ),
  );

  @override
  void initState() {
    if (currentlyPlayingStudyMaterialVideo.studyMaterialType ==
        StudyMaterialType.youtubeVideo) {
      loadYoutubeController();
    } else {
      loadVideoController();
    }
    super.initState();
  }

  //To load non youtube video
  void loadVideoController() {
    _videoPlayerController = VideoPlayerController.networkUrl(
      Uri.parse(currentlyPlayingStudyMaterialVideo.fileUrl),
      videoPlayerOptions: VideoPlayerOptions(mixWithOthers: true),
    )..initialize().then((value) {
        setState(() {});
        _videoPlayerController?.play();
      });
    assignedVideoController = true;
  }

  //to load youtube video
  void loadYoutubeController() {
    String youTubeId = YoutubePlayer.convertUrlToId(
          currentlyPlayingStudyMaterialVideo.fileUrl,
        ) ??
        "";

    _youtubePlayerController = YoutubePlayerController(
      initialVideoId: youTubeId,
      flags: const YoutubePlayerFlags(
        hideThumbnail: true,
        hideControls: true,
      ),
    );
    assignedVideoController = true;
  }

  @override
  void dispose() {
    controlsMenuAnimationController.dispose();
    _youtubePlayerController?.dispose();
    _videoPlayerController?.dispose();
    super.dispose();
  }

  //To show play/pause button and and other control related details
  Widget _buildVideoControlMenuContainer(Orientation orientation) {
    return AnimatedBuilder(
      animation: controlsMenuAnimationController,
      builder: (context, child) {
        return Opacity(
          opacity: controlsMenuAnimation.value,
          child: GestureDetector(
            onTap: () {
              if (controlsMenuAnimationController.isCompleted) {
                controlsMenuAnimationController.reverse();
              } else {
                controlsMenuAnimationController.forward();
              }
            },
            child: Container(
              color: Colors.black45,
              child: Stack(
                children: [
                  Align(
                    alignment: AlignmentDirectional.topStart,
                    child: Padding(
                      padding: EdgeInsetsDirectional.only(
                        top: orientation == Orientation.landscape
                            ? Utils.screenContentHorizontalPadding
                            : 0,
                        start: Utils.screenContentHorizontalPadding,
                      ),
                      child: SvgButton(
                        onTap: () {
                          if (orientation == Orientation.landscape) {
                            SystemChrome.setPreferredOrientations(
                              [DeviceOrientation.portraitUp],
                            );
                            return;
                          }
                          Get.back();
                        },
                        svgIconUrl: Utils.getBackButtonPath(context),
                      ),
                    ),
                  ),
                  //
                  Center(
                    child: PlayPauseButtonContainer(
                      isYoutubeVideo: currentlyPlayingStudyMaterialVideo
                              .studyMaterialType ==
                          StudyMaterialType.youtubeVideo,
                      controlsAnimationController:
                          controlsMenuAnimationController,
                      youtubePlayerController: _youtubePlayerController,
                      videoPlayerController: _videoPlayerController,
                    ),
                  ),
                  Align(
                    alignment: Alignment.bottomCenter,
                    child: Padding(
                      padding: orientation == Orientation.landscape
                          ? EdgeInsets.only(bottom: 15, left: 10, right: 10)
                          : EdgeInsets.all(0),
                      child: VideoControlsContainer(
                        isYoutubeVideo: currentlyPlayingStudyMaterialVideo
                                .studyMaterialType ==
                            StudyMaterialType.youtubeVideo,
                        youtubePlayerController: _youtubePlayerController,
                        videoPlayerController: _videoPlayerController,
                        controlsAnimationController:
                            controlsMenuAnimationController,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }

  //To display the video and it's controls
  Widget _buildPlayVideoContainer(Orientation orientation) {
    return Align(
      alignment: Alignment.topCenter,
      child: Container(
        color: Colors.black,
        padding: EdgeInsets.only(top: MediaQuery.of(context).padding.top),
        child: SizedBox(
          width: MediaQuery.of(context).size.width,
          //changed the height of video container based on orientation
          height: orientation == Orientation.landscape
              ? MediaQuery.of(context).size.height
              : MediaQuery.of(context).size.height *
                  _videoContainerPotraitHeightPercentage,
          child: Stack(
            children: [
              Positioned.fill(
                child: currentlyPlayingStudyMaterialVideo.studyMaterialType ==
                        StudyMaterialType.youtubeVideo
                    ? YoutubePlayerBuilder(
                        player: YoutubePlayer(
                          actionsPadding: EdgeInsets.zero,
                          controller: _youtubePlayerController!,
                        ),
                        builder: (context, player) {
                          return player;
                        },
                      )
                    : _videoPlayerController!.value.isInitialized
                        ? VideoPlayer(
                            _videoPlayerController!,
                          )
                        : Container(
                            decoration: BoxDecoration(
                              image: DecorationImage(
                                fit: BoxFit.cover,
                                image: CachedNetworkImageProvider(
                                  currentlyPlayingStudyMaterialVideo
                                      .fileThumbnail,
                                ),
                              ),
                            ),
                            child: CustomCircularProgressIndicator(
                              indicatorColor:
                                  Theme.of(context).scaffoldBackgroundColor,
                            ),
                          ),
              ),

              //show controls
              _buildVideoControlMenuContainer(orientation),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildVideoDetailsContainer({
    required StudyMaterial studyMaterial,
    required int videoIndex,
  }) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 15),
      child: InkWell(
        borderRadius: BorderRadius.circular(10),
        onTap: () async {
          if (studyMaterial.id == currentlyPlayingStudyMaterialVideo.id) {
            return;
          }

          assignedVideoController = false;

          currentlyPlayingStudyMaterialVideo = studyMaterial;
          setState(() {});

          await Future.delayed(const Duration(milliseconds: 100));
          //disposing controllers
          _youtubePlayerController?.dispose();
          _videoPlayerController?.dispose();
          _youtubePlayerController = null;
          _videoPlayerController = null;

          if (currentlyPlayingStudyMaterialVideo.studyMaterialType ==
              StudyMaterialType.youtubeVideo) {
            loadYoutubeController();
          } else {
            loadVideoController();
          }
          setState(() {});
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
          child: LayoutBuilder(
            builder: (context, boxConstraints) {
              return Row(
                children: [
                  Stack(
                    children: [
                      Container(
                        decoration: BoxDecoration(
                          image: DecorationImage(
                            fit: BoxFit.cover,
                            image: CachedNetworkImageProvider(
                              studyMaterial.fileThumbnail,
                            ),
                          ),
                          color: Theme.of(context).colorScheme.primary,
                          borderRadius: BorderRadius.circular(10),
                        ),
                        height: 65,
                        width: boxConstraints.maxWidth * (0.3),
                      ),
                      currentlyPlayingStudyMaterialVideo.id == studyMaterial.id
                          ? Container(
                              height: 65,
                              width: boxConstraints.maxWidth * (0.3),
                              decoration: BoxDecoration(
                                color: const Color(0xff212121).withValues(alpha: 0.5),
                                borderRadius: BorderRadius.circular(10),
                              ),
                              child: Lottie.asset(
                                "assets/animations/music_playing.json",
                                animate: true,
                              ),
                            )
                          : const SizedBox()
                    ],
                  ),
                  SizedBox(
                    width: boxConstraints.maxWidth * (0.05),
                  ),
                  Flexible(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          studyMaterial.fileName,
                          style: TextStyle(
                            color: Theme.of(context).colorScheme.onSurface,
                            fontWeight: FontWeight.w600,
                            fontSize: 13.0,
                          ),
                        ),
                      ],
                    ),
                  )
                ],
              );
            },
          ),
        ),
      ),
    );
  }

  Widget _buildRelatedVideos() {
    return Align(
      alignment: Alignment.topCenter,
      child: ListView.builder(
        padding: EdgeInsets.only(
          left: MediaQuery.of(context).size.width * (0.075),
          right: MediaQuery.of(context).size.width * (0.075),
          top: MediaQuery.of(context).size.height *
                  _videoContainerPotraitHeightPercentage +
              MediaQuery.of(context).padding.top +
              15,
        ),
        itemCount: widget.relatedVideos.length,
        itemBuilder: (context, index) {
          return _buildVideoDetailsContainer(
            studyMaterial: widget.relatedVideos[index],
            videoIndex: index,
          );
        },
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return OrientationBuilder(
      builder: (context, orientation) {
        return PopScope(
          canPop: orientation == Orientation.portrait,
          onPopInvokedWithResult: (dynamic, _) {
            if (orientation == Orientation.landscape) {
              SystemChrome.setPreferredOrientations(
                  [DeviceOrientation.portraitUp]);
            }
          },
          child: Scaffold(
            body: Stack(
              children: [
                orientation == Orientation.landscape
                    ? const SizedBox()
                    : _buildRelatedVideos(),

                //need to show the container when changing the youtube video or other video
                //It has the same size as youtube player container
                Container(
                  width: MediaQuery.of(context).size.width,
                  height: MediaQuery.of(context).size.height *
                      _videoContainerPotraitHeightPercentage,
                  color: Colors.black45,
                  child: Center(
                    child: CustomCircularProgressIndicator(
                      indicatorColor: Theme.of(context).scaffoldBackgroundColor,
                    ),
                  ),
                ),

                //If controller is availble to play video then
                //show video container
                assignedVideoController
                    ? _buildPlayVideoContainer(orientation)
                    : const SizedBox()
              ],
            ),
          ),
        );
      },
    );
  }
}
