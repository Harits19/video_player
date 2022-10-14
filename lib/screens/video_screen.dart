import 'dart:async';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:my_video_player/screens/constans/number_constan.dart';
import 'package:my_video_player/screens/views/icon_shadow_view.dart';
import 'package:video_player/video_player.dart';

class VideoScreen extends StatefulWidget {
  const VideoScreen({Key? key, required this.path}) : super(key: key);
  final String path;

  @override
  State<VideoScreen> createState() => _VideoScreenState();
}

class _VideoScreenState extends State<VideoScreen> {
  late final _controller = VideoPlayerController.file(
    File(widget.path),
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
    return ValueListenableBuilder(
        valueListenable: _controller,
        builder: (_, videoVal, child) {
          final currentPosition = videoVal.position;

          final isPlaying = videoVal.isPlaying;
          final size = videoVal.size;
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
                          duration: const Duration(milliseconds: 300),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              _SeekWidget(
                                radius: size.height,
                                onDoubleTap: () {
                                  _controller
                                      .seekTo(currentPosition - kSeekDuration);
                                },
                                direction: Direction.right,
                              ),
                              space,
                              Material(
                                color: Colors.transparent,
                                child: InkWell(
                                  onTap: () {
                                    isPlaying
                                        ? _controller.pause()
                                        : _controller.play();
                                  },
                                  customBorder: const CircleBorder(),
                                  child: IconShadowView(
                                    isPlaying ? Icons.pause : Icons.play_arrow,
                                    color: Colors.white,
                                    size: 56,
                                  ),
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
                                direction: Direction.left,
                              )
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
        });
  }
}

enum Direction { left, right }

class _SeekWidget extends StatelessWidget {
  const _SeekWidget({
    Key? key,
    required this.onDoubleTap,
    this.direction = Direction.left,
    required this.radius,
  }) : super(key: key);

  final VoidCallback onDoubleTap;
  final Direction direction;
  final double radius;

  @override
  Widget build(BuildContext context) {
    final color = Colors.white.withOpacity(0.1);

    return Expanded(
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onDoubleTap: onDoubleTap,
          hoverColor: color,
          splashColor: color,
          focusColor: color,
          highlightColor: color,
          borderRadius: () {
            final radius = Radius.circular(this.radius);
            final left = BorderRadius.horizontal(left: radius);
            final right = BorderRadius.horizontal(right: radius);
            if (direction == Direction.left) {
              return left;
            }
            if (direction == Direction.right) {
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
      ),
    );
  }
}
