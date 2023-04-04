import 'package:flutter/material.dart';
import 'package:video_player/video_player.dart';

class VideoPlayerView extends StatelessWidget {
  const VideoPlayerView({
    super.key,
    required this.controller,
  });

  final VideoPlayerController controller;

  @override
  Widget build(BuildContext context) {
    if (controller.value.isInitialized) {
      return FittedBox(
        fit: BoxFit.contain,
        child: SizedBox(
          width: controller.value.size.width,
          height: controller.value.size.height,
          child: VideoPlayer(controller),
        ),
      );
    }
    return const SizedBox();
  }
}
