import 'package:flutter/material.dart';
import 'package:my_video_player/enums/direction_to_enum.dart';
import 'package:my_video_player/screens/constans/number_constan.dart';
import 'package:my_video_player/screens/views/gradient_view.dart';
import 'package:my_video_player/screens/views/ink_well_view.dart';
import 'package:my_video_player/extensions/double_extension.dart';
import 'package:my_video_player/extensions/duration_extension.dart';
import 'package:my_video_player/utils/orientation_util.dart';
import 'package:video_player/video_player.dart';

class BottomGradientView extends StatelessWidget {
  const BottomGradientView({
    Key? key,
    required this.playbackSpeed,
    required this.onTapSeek,
    required this.videoValue,
    required this.controller,
  }) : super(key: key);

  final double playbackSpeed;
  final VoidCallback onTapSeek;
  final VideoPlayerValue videoValue;
  final VideoPlayerController controller;

  @override
  Widget build(BuildContext context) {
    final position = videoValue.position;
    final duration = videoValue.duration;
    const kColorPrimaryVideoScreen = Colors.white;
    return GradientView(
      directionTo: DirectionToEnum.top,
      children: [
        Text(
          position.durationToTime(),
          style: const TextStyle(
            color: kColorPrimaryVideoScreen,
          ),
        ),
        Expanded(
          child: Slider(
            value: position.inSeconds.toDouble(),
            max: duration.inSeconds.toDouble(),
            onChanged: (val) {
              controller.seekTo(Duration(seconds: val.toInt()));
            },
          ),
        ),
        Text(
          duration.durationToTime(),
          style: const TextStyle(
            color: kColorPrimaryVideoScreen,
          ),
        ),
        const SizedBox(
          width: KNumber.s8,
        ),
        InkWellView(
          onTap: onTapSeek,
          child: Text((playbackSpeed.displayPlayback)),
        ),
        const SizedBox(
          width: KNumber.s8,
        ),
        () {
          final isLandscape =
              MediaQuery.of(context).orientation == Orientation.landscape;
          return InkWellView(
            child: RotatedBox(
              quarterTurns: isLandscape ? 1 : 0,
              child: const Icon(
                Icons.rectangle_outlined,
                color: kColorPrimaryVideoScreen,
              ),
            ),
            onTap: () {
              if (isLandscape) {
                OrientationUtil.defaultOrientation();
              } else {
                OrientationUtil.landscapeOrientation();
              }
            },
          );
        }(),
      ],
    );
  }
}
