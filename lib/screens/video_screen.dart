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
import 'package:my_video_player/utils/overlay_util.dart';
import 'package:video_player/video_player.dart';

class VideoScreen extends StatefulWidget {
  const VideoScreen({Key? key, required this.file}) : super(key: key);
  final FileSystemEntity file;

  @override
  State<VideoScreen> createState() => _VideoScreenState();
}

class _VideoScreenState extends State<VideoScreen> {
  late final _controller = VideoPlayerController.file(
    File(widget.file.path),
  );
  late final file = widget.file;
  bool _showOverlay = true;
  Timer? _overlayTimer, _savePlaybackTimer;
  var _playbackSpeed = SharedPrefService.getPlaybackSpeed();

  @override
  void initState() {
    super.initState();
    OverlayUtil.hideStatusBar();
    _initVideo().then((value) {
      _savePlaybackTimer = Timer.periodic(const Duration(seconds: 1), (timer) {
        SharedPrefService.saveVideoPlayback(
          _controller.value.position,
          file,
        );
      });
    });
    _initOverlayTimer();
  }

  @override
  void dispose() {
    super.dispose();
    _controller.dispose();
    _overlayTimer?.cancel();
    _savePlaybackTimer?.cancel();
  }

  Future<void> _initVideo() async {
    await _controller.initialize();
    await _controller.setPlaybackSpeed(_playbackSpeed);
    await _controller.seekTo(SharedPrefService.getLastVideoPlayback(file));
    final useLandscape = _controller.value.aspectRatio > 1;
    if (useLandscape) {
      await OrientationUtil.landscapeOrientation();
    }
    await _controller.play();
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
    return WillPopScope(
      onWillPop: () async {
        await OrientationUtil.defaultOrientation();
        await OverlayUtil.defaultOverlay();
        return true;
      },
      child: Scaffold(
        backgroundColor: Colors.black,
        body: Center(
          child: Listener(
            onPointerDown: (_) => _resetTimer(),
            child: ValueListenableBuilder(
                valueListenable: _controller,
                builder: (context, videoVal, child) {
                  return Stack(
                    children: [
                      SizedBox.expand(
                        child: VideoPlayerView(controller: _controller),
                      ),
                      Positioned.fill(
                        child: AnimatedOpacity(
                          opacity: _showOverlay ? 1 : 0,
                          duration: KNumber.kAnimationDuration,
                          child: Column(
                            children: [
                              TopGradientView(widget: widget),
                              VideoControllerView(
                                controller: _controller,
                                videoVal: videoVal,
                              ),
                              BottomGradientView(
                                videoValue: videoVal,
                                controller: _controller,
                                playbackSpeed: _playbackSpeed,
                                onTapSeek: () {
                                  PlaybackDialogView.showPlaybackDialog(
                                    context,
                                    playbackSpeed: _playbackSpeed,
                                    onChangedPlayback: (val) async {
                                      _playbackSpeed = val;
                                      _controller.setPlaybackSpeed(
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
                      )
                    ],
                  );
                }),
          ),
        ),
      ),
    );
  }
}
