import 'dart:async';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:my_video_player/screens/constans/number_constan.dart';
import 'package:my_video_player/screens/views/bottom_gradient_view.dart';
import 'package:my_video_player/screens/views/playback_dialog_view.dart';
import 'package:my_video_player/screens/views/top_gradient_view.dart';
import 'package:my_video_player/screens/views/video_controller_view.dart';
import 'package:my_video_player/screens/views/video_player_view.dart';
import 'package:my_video_player/services/shared_pref_service.dart';
import 'package:my_video_player/utils/orientation_util.dart';
import 'package:video_player/video_player.dart';
import 'package:subtitle_wrapper_package/subtitle_wrapper_package.dart';

class VideoScreen extends StatefulWidget {
  static const routeName = 'video-screen';
  const VideoScreen({Key? key, required this.file}) : super(key: key);
  final FileSystemEntity file;

  @override
  State<VideoScreen> createState() => _VideoScreenState();
}

class _VideoScreenState extends State<VideoScreen> {
  late final videoPlayerController = VideoPlayerController.file(
    File(widget.file.path),
  );
  late final file = widget.file;
  bool _showOverlay = true;
  Timer? _overlayTimer, _savePlaybackTimer;
  var _playbackSpeed = SharedPrefService.getPlaybackSpeed();

  SubtitleController? subtitleController;

  @override
  void initState() {
    super.initState();
    WindowUtil.hideStatusBar();
    _initVideo().then((value) {
      _savePlaybackTimer = Timer.periodic(const Duration(seconds: 1), (timer) {
        SharedPrefService.saveVideoPlayback(
          videoPlayerController.value.position,
          file,
        );
      });
    });
    _initOverlayTimer();
  }

  @override
  void dispose() {
    super.dispose();
    videoPlayerController.dispose();
    _overlayTimer?.cancel();
    _savePlaybackTimer?.cancel();
  }

  Future<void> _initVideo() async {
    await videoPlayerController.initialize();
    await videoPlayerController.setPlaybackSpeed(_playbackSpeed);
    await videoPlayerController
        .seekTo(SharedPrefService.getLastVideoPlayback(file));
    final useLandscape = videoPlayerController.value.aspectRatio > 1;
    if (useLandscape) {
      await WindowUtil.landscapeOrientation();
    }
    await videoPlayerController.play();
  }

  void _resetTimer() {
    _showOverlay = true;
    setState(() {});
    _overlayTimer?.cancel();
    _initOverlayTimer();
  }

  void _initOverlayTimer() {
    _overlayTimer = Timer(const Duration(seconds: 2), () {
      _showOverlay = false;
      setState(() {});
    });
  }

  @override
  Widget build(BuildContext context) {
    final videoPlayer = VideoPlayerView(
      controller: videoPlayerController,
    );
    return WillPopScope(
      onWillPop: () async {
        WindowUtil.backToDefault();
        return true;
      },
      child: Scaffold(
        backgroundColor: Colors.black,
        body: Center(
          child: Listener(
            onPointerDown: (_) => _resetTimer(),
            child: ValueListenableBuilder(
                valueListenable: videoPlayerController,
                builder: (context, videoVal, child) {
                  return Stack(
                    children: [
                      SizedBox.expand(
                        child: subtitleController == null
                            ? videoPlayer
                            : SubtitleWrapper(
                                subtitleController: subtitleController!,
                                videoPlayerController: videoPlayerController,
                                videoChild: videoPlayer,
                                subtitleStyle: const SubtitleStyle(
                                  textColor: Colors.white,
                                  hasBorder: true,
                                ),
                              ),
                      ),
                      Positioned.fill(
                        child: AnimatedOpacity(
                          opacity: _showOverlay ? 1 : 0,
                          duration: KNumber.kAnimationDuration,
                          child: Column(
                            children: [
                              TopGradientView(
                                widget: widget,
                                videoPlayerController: videoPlayerController,
                                onAddSubtitle: (val) {
                                  subtitleController = SubtitleController(
                                    subtitlesContent: val,
                                    subtitleType: SubtitleType.srt,
                                  );
                                  setState(() {});
                                },
                              ),
                              VideoControllerView(
                                controller: videoPlayerController,
                                videoVal: videoVal,
                              ),
                              BottomGradientView(
                                videoValue: videoVal,
                                controller: videoPlayerController,
                                playbackSpeed: _playbackSpeed,
                                onTapSeek: () {
                                  PlaybackDialogView.showPlaybackDialog(
                                    context,
                                    playbackSpeed: _playbackSpeed,
                                    onChangedPlayback: (val) async {
                                      _playbackSpeed = val;
                                      videoPlayerController.setPlaybackSpeed(
                                        _playbackSpeed,
                                      );
                                      await SharedPrefService.savePlaybackSpeed(
                                        _playbackSpeed,
                                      );
                                      setState(() {});
                                    },
                                  );
                                },
                              ),
                            ],
                          ),
                        ),
                      ),
                    ],
                  );
                }),
          ),
        ),
      ),
    );
  }
}
