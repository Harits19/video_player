import 'dart:async';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:my_video_player/screens/constans/number_constan.dart';
import 'package:my_video_player/screens/views/bottom_gradient_view.dart';
import 'package:my_video_player/screens/views/top_gradient_view.dart';
import 'package:my_video_player/screens/views/video_controller_view.dart';
import 'package:my_video_player/services/shared_pref_service.dart';
import 'package:my_video_player/extensions/double_extension.dart';
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

  bool _showOverlay = true;
  Timer? _timer;
  double _playbackSpeed = SharedPrefService.getPlaybackSpeed();

  // TODO upload to playstore
  // TODO fix issue subtitle not showing

  @override
  void initState() {
    super.initState();
    OverlayUtil.hideStatusBar();
    _controller.initialize().then((value) => _initVideo());
    _initTimer();
  }

  @override
  void dispose() {
    super.dispose();
    _controller.dispose();
    _timer?.cancel();
  }

  void _initVideo() async {
    await _controller.setPlaybackSpeed(_playbackSpeed);
    final useLandscape = _controller.value.aspectRatio > 1;
    if (useLandscape) {
      await OrientationUtil.landscapeOrientation();
    }
    _controller.play();
  }

  void _resetTimer() {
    _showOverlay = true;
    setState(() {});
    _timer?.cancel();
    _initTimer();
  }

  void _initTimer() {
    _timer = Timer(const Duration(seconds: 2), () {
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
        // floatingActionButton: FloatingActionButton(onPressed: () {
        //   NavUtil.push(
        //       context,
        //       Scaffold(
        //         body: VideoPlayer(_controller),
        //       ));
        // }),
        body: Center(
          child: Listener(
            onPointerDown: (_) => _resetTimer(),
            child: ValueListenableBuilder(
                valueListenable: _controller,
                builder: (context, videoVal, child) {
                  return Stack(
                    children: [
                      SizedBox.expand(
                        child: FittedBox(
                          fit: BoxFit.contain,
                          child: SizedBox(
                            width: videoVal.size.width,
                            height: videoVal.size.height,
                            child: VideoPlayer(_controller),
                          ),
                        ),
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
                                onTapSeek: _showPlaybackDialog,
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

  void _showPlaybackDialog() {
    showDialog(
      context: context,
      builder: (context) {
        return StatefulBuilder(builder: (context, localState) {
          return Dialog(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                const SizedBox(
                  height: KNumber.s16,
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: List.generate(
                        KNumber.playbackDivisions.toInt(),
                        (index) => Text(((index + 1) /
                            KNumber.playbackDivisions *
                            KNumber.maxPlaybackSpeed).displayPlayback)),
                  ),
                ),
                Slider(
                    max: KNumber.maxPlaybackSpeed,
                    value: _playbackSpeed,
                    min: KNumber.minPlaybackSpeed,
                    label: _playbackSpeed.displayPlayback,
                    divisions: (KNumber.playbackDivisions - 1),
                    onChanged: (val) async {
                      _playbackSpeed = val;
                      _controller.setPlaybackSpeed(_playbackSpeed);
                      await SharedPrefService.savePlaybackSpeed(_playbackSpeed);
                      localState(() {});
                      setState(() {});
                    }),
              ],
            ),
          );
        });
      },
    );
  }
}
