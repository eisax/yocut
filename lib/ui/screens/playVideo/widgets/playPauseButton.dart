import 'package:flutter/material.dart';
import 'package:video_player/video_player.dart';
import 'package:youtube_player_flutter/youtube_player_flutter.dart';

class PlayPauseButtonContainer extends StatefulWidget {
  final AnimationController controlsAnimationController;
  final bool isYoutubeVideo;
  final VideoPlayerController? videoPlayerController;
  final YoutubePlayerController? youtubePlayerController;
  const PlayPauseButtonContainer({
    Key? key,
    this.youtubePlayerController,
    this.videoPlayerController,
    required this.isYoutubeVideo,
    required this.controlsAnimationController,
  }) : super(key: key);

  @override
  State<PlayPauseButtonContainer> createState() =>
      _PlayPauseButtonContainerState();
}

class _PlayPauseButtonContainerState extends State<PlayPauseButtonContainer> {
  bool _isPlaying = false;
  bool _isCompleted = false;

  void listener() {
    _isPlaying = widget.isYoutubeVideo
        ? widget.youtubePlayerController!.value.isPlaying
        : widget.videoPlayerController!.value.isPlaying;

    if (widget.isYoutubeVideo) {
      if (widget.youtubePlayerController!.value.position.inSeconds != 0) {
        _isCompleted = widget
                .youtubePlayerController!.value.position.inSeconds ==
            widget.youtubePlayerController!.value.metaData.duration.inSeconds;
      }
    } else {
      if (widget.videoPlayerController!.value.position.inSeconds != 0) {
        _isCompleted = widget.videoPlayerController!.value.position.inSeconds ==
            widget.videoPlayerController!.value.duration.inSeconds;
      }
    }

    setState(() {});
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
    return Center(
      child: IconButton(
        iconSize: 40,
        color: Theme.of(context).scaffoldBackgroundColor,
        onPressed: () async {
          //if control menu is not opened then open the menu
          if (!widget.controlsAnimationController.isCompleted) {
            widget.controlsAnimationController.forward();
            return;
          }

          if (_isCompleted) {
            if (widget.isYoutubeVideo) {
              widget.youtubePlayerController!.seekTo(Duration.zero);
              widget.youtubePlayerController!.play();
              return;
            } else {
              widget.videoPlayerController!.seekTo(Duration.zero);
              widget.videoPlayerController!.play();
              return;
            }
          }

          if (_isPlaying) {
            widget.isYoutubeVideo
                ? widget.youtubePlayerController!.pause()
                : widget.videoPlayerController!.pause();
            await Future.delayed(const Duration(milliseconds: 500));
            widget.controlsAnimationController.reverse();
          } else {
            widget.isYoutubeVideo
                ? widget.youtubePlayerController!.play()
                : widget.videoPlayerController!.play();
            await Future.delayed(const Duration(milliseconds: 500));
            widget.controlsAnimationController.reverse();
          }
        },
        icon: _isCompleted
            ? const Icon(Icons.restart_alt)
            : _isPlaying
                ? const Icon(
                    Icons.pause,
                  )
                : const Icon(Icons.play_arrow),
      ),
    );
  }
}
