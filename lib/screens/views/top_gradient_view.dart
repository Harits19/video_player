import 'package:flutter/material.dart';
import 'package:my_video_player/enums/direction_to_enum.dart';
import 'package:my_video_player/extensions/file_system_extension.dart';
import 'package:my_video_player/screens/video_screen.dart';
import 'package:my_video_player/screens/views/gradient_view.dart';

class TopGradientView extends StatelessWidget {
  const TopGradientView({
    Key? key,
    required this.widget,
  }) : super(key: key);

  final VideoScreen widget;

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
      ],
    );
  }
}
