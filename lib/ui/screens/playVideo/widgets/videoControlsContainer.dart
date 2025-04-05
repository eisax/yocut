import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:video_player/video_player.dart';
import 'package:youtube_player_flutter/youtube_player_flutter.dart';

class VideoControlsContainer extends StatefulWidget {
  final bool isYoutubeVideo;
  final AnimationController controlsAnimationController;
  final YoutubePlayerController? youtubePlayerController;
  final VideoPlayerController? videoPlayerController;
  const VideoControlsContainer({
    Key? key,
    required this.isYoutubeVideo,
    this.videoPlayerController,
    required this.controlsAnimationController,
    this.youtubePlayerController,
  }) : super(key: key);

  @override
  State<VideoControlsContainer> createState() => _VideoControlsContainerState();
}

class _VideoControlsContainerState extends State<VideoControlsContainer> {
  late Duration currentVideoDuration = Duration.zero;
  final double sliderHeight = 4.0;

  void listener() {
    currentVideoDuration = widget.isYoutubeVideo
        ? widget.youtubePlayerController!.value.position
        : widget.videoPlayerController!.value.position;
    setState(() {});
  }

  bool _allowGesture() {
    return widget.controlsAnimationController.isCompleted;
  }

  String _buildCurrentVideoDurationInHMS() {
    String time = "";
    if (currentVideoDuration.inHours != 0) {
      time = "${currentVideoDuration.inHours.toString().padLeft(2, '0')}:";
    }
    if (currentVideoDuration.inMinutes != 0) {
      time =
          "$time${(currentVideoDuration.inMinutes - (24 * currentVideoDuration.inHours)).toString().padLeft(2, '0')}:";
    }
    if (currentVideoDuration.inSeconds != 0) {
      time =
          "$time${(currentVideoDuration.inSeconds - (60 * currentVideoDuration.inMinutes)).toString().padLeft(2, '0')}";
    }
    return time;
  }

  String _buildVideoDurationInHMS() {
    Duration videoDuration = widget.isYoutubeVideo
        ? widget.youtubePlayerController!.metadata.duration
        : widget.videoPlayerController!.value.duration;
    String time = "";
    if (videoDuration.inHours != 0) {
      time = "${(videoDuration.inHours).toString().padLeft(2, '0')}:";
    }
    if (videoDuration.inMinutes != 0) {
      time =
          "$time${(videoDuration.inMinutes - (24 * videoDuration.inHours)).toString().padLeft(2, '0')}:";
    }
    if (videoDuration.inSeconds != 0) {
      time =
          "$time${(videoDuration.inSeconds - (60 * videoDuration.inMinutes)).toString().padLeft(2, '0')}";
    }
    return time;
  }

  @override
  void initState() {
    widget.youtubePlayerController?.addListener(listener);
    widget.videoPlayerController?.addListener(listener);
    super.initState();
  }

  @override
  void dispose() {
    widget.youtubePlayerController?.removeListener(listener);
    widget.videoPlayerController?.removeListener(listener);
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(
        bottom: 15,
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Row(
              children: [
                Text(
                  _buildCurrentVideoDurationInHMS().isEmpty
                      ? ""
                      : "${_buildCurrentVideoDurationInHMS()} / ${_buildVideoDurationInHMS()}",
                  style: const TextStyle(color: Colors.white),
                ),
                const Spacer(),
                IconButton(
                  color: Colors.white,
                  padding: EdgeInsets.zero,
                  onPressed: () {
                    if (_allowGesture()) {
                      if (MediaQuery.of(context).orientation ==
                          Orientation.portrait) {
                        SystemChrome.setPreferredOrientations([
                          DeviceOrientation.landscapeRight,
                          DeviceOrientation.landscapeLeft
                        ]);
                      } else {
                        SystemChrome.setPreferredOrientations(
                          [DeviceOrientation.portraitUp],
                        );
                      }
                    } else {
                      //if control menu is not open then open here
                      widget.controlsAnimationController.forward();
                    }
                  },
                  icon: const Icon(Icons.fullscreen),
                )
              ],
            ),
          ),
          SizedBox(
            height: sliderHeight,
            width: MediaQuery.of(context).size.width,
            child: SliderTheme(
              data: Theme.of(context).sliderTheme.copyWith(
                    overlayShape:
                        const RoundSliderOverlayShape(overlayRadius: 0.0),
                    trackHeight: sliderHeight,
                    trackShape: CustomTrackShape(),
                    thumbShape: const RoundSliderThumbShape(
                      enabledThumbRadius: 7,
                    ),
                  ),
              child: Slider(
                max: widget.isYoutubeVideo
                    ? widget.youtubePlayerController!.value.metaData.duration
                        .inSeconds
                        .toDouble()
                    : widget.videoPlayerController!.value.duration.inSeconds
                        .toDouble(),
                activeColor: Colors.white,
                inactiveColor: Colors.white38,
                value: currentVideoDuration.inSeconds.toDouble(),
                thumbColor: Theme.of(context).colorScheme.primary,
                onChanged: (value) {
                  if (_allowGesture()) {
                    setState(() {
                      currentVideoDuration = Duration(
                        seconds: value.toInt(),
                      );
                    });
                    widget.isYoutubeVideo
                        ? widget.youtubePlayerController!
                            .seekTo(currentVideoDuration)
                        : widget.videoPlayerController!
                            .seekTo(currentVideoDuration);
                  } else {
                    //if control menu is not open then open here
                    widget.controlsAnimationController.forward();
                  }
                },
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class CustomTrackShape extends RectangularSliderTrackShape {
  @override
  Rect getPreferredRect({
    required RenderBox parentBox,
    Offset offset = Offset.zero,
    required SliderThemeData sliderTheme,
    bool isEnabled = false,
    bool isDiscrete = false,
  }) {
    return Offset(offset.dx, offset.dy) &
        Size(parentBox.size.width, sliderTheme.trackHeight!);
  }
}
