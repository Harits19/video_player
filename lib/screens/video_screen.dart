import 'dart:async';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:my_video_player/screens/constans/number_constan.dart';
import 'package:my_video_player/screens/views/icon_shadow_view.dart';
import 'package:my_video_player/screens/views/new_ink_well.dart';
import 'package:my_video_player/utils/file_type_util.dart';
import 'package:my_video_player/utils/orientation_util.dart';
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

  @override
  void initState() {
    super.initState();
    _controller.initialize().then(
      (value) {
        return _controller.play();
      },
    );
    _initTimer();
  }

  @override
  void dispose() {
    super.dispose();
    _controller.dispose();
    _timer?.cancel();
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
    print(_controller.value.aspectRatio);
    return WillPopScope(
      onWillPop: () async {
        await OrientationUtil.defaultOrientation();
        return true;
      },
      child: ValueListenableBuilder(
          valueListenable: _controller,
          builder: (_, videoVal, child) {
            final currentPosition = videoVal.position;

            final isPlaying = videoVal.isPlaying;
            final size = MediaQuery.of(context).size;
            const space = SizedBox(
              width: 56,
            );
            return Scaffold(
              body: Center(
                child: Listener(
                  onPointerDown: (_) => _resetTimer(),
                  child: AspectRatio(
                    aspectRatio: videoVal.aspectRatio,
                    child: Stack(
                      children: [
                        VideoPlayer(
                          _controller,
                        ),
                        Positioned.fill(
                          child: AnimatedOpacity(
                            opacity: _showOverlay ? 1 : 0,
                            duration: kAnimationDuration,
                            child: Column(
                              children: [
                                _GradientView(
                                  directionTo: DirectionTo.bottom,
                                  children: [
                                    Expanded(
                                      child: Text(
                                        FileUtil.getFileName(widget.file),
                                        overflow: TextOverflow.ellipsis,
                                        maxLines: 1,
                                        style: const TextStyle(
                                          color: Colors.white,
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                                Expanded(
                                  child: Row(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      _SeekWidget(
                                        radius: size.height,
                                        onDoubleTap: () {
                                          _controller.seekTo(
                                              currentPosition - kSeekDuration);
                                        },
                                        directionTo: DirectionTo.right,
                                      ),
                                      space,
                                      NewInkWell(
                                        onTap: () {
                                          isPlaying
                                              ? _controller.pause()
                                              : _controller.play();
                                        },
                                        customBorder: const CircleBorder(),
                                        child: IconShadowView(
                                          isPlaying
                                              ? Icons.pause
                                              : Icons.play_arrow,
                                          color: Colors.white,
                                          size: 56,
                                        ),
                                      ),
                                      space,
                                      _SeekWidget(
                                        radius: size.height,
                                        onDoubleTap: () {
                                          _controller.seekTo(
                                            currentPosition + kSeekDuration,
                                          );
                                        },
                                        directionTo: DirectionTo.left,
                                      )
                                    ],
                                  ),
                                ),
                                _GradientView(
                                  directionTo: DirectionTo.top,
                                  children: [
                                    const Spacer(),
                                    () {
                                      final isLandscape =
                                          MediaQuery.of(context).orientation ==
                                              Orientation.landscape;
                                      return NewInkWell(
                                        child: RotatedBox(
                                          quarterTurns: isLandscape ? 1 : 0,
                                          child: const Icon(
                                            Icons.rectangle_outlined,
                                            color: Colors.white,
                                          ),
                                        ),
                                        onTap: () {
                                          if (isLandscape) {
                                            OrientationUtil
                                                .defaultOrientation();
                                          } else {
                                            OrientationUtil
                                                .landscapeOrientation();
                                          }
                                        },
                                      );
                                    }(),
                                  ],
                                ),
                              ],
                            ),
                          ),
                        )
                      ],
                    ),
                  ),
                ),
              ),
            );
          }),
    );
  }
}

class _GradientView extends StatelessWidget {
  const _GradientView({
    Key? key,
    this.children = const [],
    required this.directionTo,
  })  : assert(
          directionTo == DirectionTo.top || directionTo == DirectionTo.bottom,
        ),
        super(key: key);

  final List<Widget> children;
  final DirectionTo directionTo;

  @override
  Widget build(BuildContext context) {
    const topCenter = Alignment.topCenter;
    const bottomCenter = Alignment.bottomCenter;
    return Container(
      padding: const EdgeInsets.all(kS8),
      height: k48,
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: directionTo == DirectionTo.top ? bottomCenter : topCenter,
          end: directionTo == DirectionTo.top ? topCenter : bottomCenter,
          colors: <Color>[
            Colors.black.withOpacity(0.3),
            Colors.transparent,
          ],
        ),
      ),
      child: Row(
        children: children,
      ),
    );
  }
}

enum DirectionTo { left, right, top, bottom }

class _SeekWidget extends StatelessWidget {
  const _SeekWidget({
    Key? key,
    required this.onDoubleTap,
    this.directionTo = DirectionTo.left,
    required this.radius,
  })  : assert(
          directionTo == DirectionTo.left || directionTo == DirectionTo.right,
        ),
        super(key: key);

  final VoidCallback onDoubleTap;
  final DirectionTo directionTo;
  final double radius;

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: NewInkWell(
        onDoubleTap: onDoubleTap,
        borderRadius: () {
          final radius = Radius.circular(this.radius);
          final left = BorderRadius.horizontal(left: radius);
          final right = BorderRadius.horizontal(right: radius);
          if (directionTo == DirectionTo.left) {
            return left;
          }
          if (directionTo == DirectionTo.right) {
            return right;
          }
        }(),
        child: Container(
          alignment: Alignment.center,
          height: double.infinity,
          width: double.infinity,
          child: Text(
            '${kSeekDuration.inSeconds} seconds',
            style: const TextStyle(
              color: Colors.white,
            ),
          ),
        ),
      ),
    );
  }
}
