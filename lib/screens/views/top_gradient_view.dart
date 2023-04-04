import 'package:flutter/material.dart';
import 'package:my_video_player/enums/direction_to_enum.dart';
import 'package:my_video_player/enums/directory_type_enum.dart';
import 'package:my_video_player/extensions/context_extension.dart';
import 'package:my_video_player/extensions/file_system_extension.dart';
import 'package:my_video_player/screens/home_screen.dart';
import 'package:my_video_player/screens/video_screen.dart';
import 'package:my_video_player/screens/views/gradient_view.dart';
import 'package:video_player/video_player.dart';

class TopGradientView extends StatelessWidget {
  const TopGradientView({
    Key? key,
    required this.widget,
    required this.videoPlayerController,
  }) : super(key: key);

  final VideoScreen widget;
  final VideoPlayerController videoPlayerController;

  @override
  Widget build(BuildContext context) {
    return GradientView(
      directionTo: DirectionToEnum.bottom,
      children: [
        Expanded(
          child: Text(
            widget.file.getFileName(),
            overflow: TextOverflow.ellipsis,
            maxLines: 1,
            style: const TextStyle(
              color: Colors.white,
            ),
          ),
        ),
        IconButton(
          icon: const Icon(
            Icons.subtitles,
          ),
          onPressed: () {
            videoPlayerController.pause();
            context.push(
              HomeScreen(
                directoryTypeEnum: DirectoryTypeEnum.subtitle,
                onSubtitleSelected: (subtitle) {
                  print(subtitle);
                },
              ),
            );
          },
        )
      ],
    );
  }
}
