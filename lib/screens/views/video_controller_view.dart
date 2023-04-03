import 'package:flutter/material.dart';
import 'package:my_video_player/enums/direction_to_enum.dart';
import 'package:my_video_player/screens/constans/number_constan.dart';
import 'package:my_video_player/screens/views/icon_shadow_view.dart';
import 'package:my_video_player/screens/views/ink_well_view.dart';
import 'package:my_video_player/screens/views/seek_view.dart';
import 'package:video_player/video_player.dart';

class VideoControllerView extends StatelessWidget {
  const VideoControllerView({
    Key? key,
    required this.videoVal,
    required this.controller,
  }) : super(key: key);

  final VideoPlayerController controller;
  final VideoPlayerValue videoVal;

  @override
  Widget build(BuildContext context) {
    final currentPosition = videoVal.position;
    final isPlaying = videoVal.isPlaying;
    final size = MediaQuery.of(context).size;
    return Expanded(
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          SeekWidget(
            radius: size.height,
            onDoubleTap: () {
              controller.seekTo(currentPosition - KNumber.kSeekDuration);
            },
            directionTo: DirectionToEnum.right,
          ),
          InkWellView(
            onTap: () {
              isPlaying ? controller.pause() : controller.play();
            },
            customBorder: const CircleBorder(),
            child: IconShadowView(
              isPlaying ? Icons.pause : Icons.play_arrow,
              color: Colors.white,
              size: 56,
            ),
          ),
          SeekWidget(
            radius: size.height,
            onDoubleTap: () {
              controller.seekTo(
                currentPosition + KNumber.kSeekDuration,
              );
            },
            directionTo: DirectionToEnum.left,
          )
        ],
      ),
    );
  }
}
