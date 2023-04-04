import 'dart:io';

import 'package:flutter/material.dart';
import 'package:my_video_player/extensions/context_extension.dart';
import 'package:my_video_player/extensions/file_system_extension.dart';
import 'package:my_video_player/screens/constans/number_constan.dart';
import 'package:my_video_player/screens/video_screen.dart';
import 'package:my_video_player/screens/views/video_player_view.dart';
import 'package:my_video_player/services/shared_pref_service.dart';
import 'package:video_player/video_player.dart';

class ThumbnailView extends StatefulWidget {
  const ThumbnailView({
    super.key,
    required this.file,
  });

  final FileSystemEntity file;

  @override
  State<ThumbnailView> createState() => _ThumbnailViewState();
}

class _ThumbnailViewState extends State<ThumbnailView> {
  late final file = widget.file;
  late final videoController = VideoPlayerController.file(File(file.path));

  int totalPlayed = 0, totalDuration = 0;

  @override
  void initState() {
    super.initState();
    initVideo();
  }

  void initVideo() async {
    await videoController.initialize();
    final videoVal = videoController.value;
    final halfVideo = Duration(
      seconds: videoVal.duration.inSeconds ~/ 2,
    );
    await videoController.seekTo(halfVideo);
    totalDuration = videoVal.duration.inSeconds;
    updateLastPlayback();
    setState(() {});
  }

  void updateLastPlayback() {
    totalPlayed = SharedPrefService.getLastVideoPlayback(file).inSeconds;
    setState(() {});
  }

  @override
  void dispose() {
    super.dispose();
    videoController.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () {
        Navigator.of(context)
            .push(MaterialPageRoute(
          builder: (_) {
            return VideoScreen(
              file: file,
            );
          },
          settings: const RouteSettings(
            name: VideoScreen.routeName,
          ),
        ))
            .then(
          (value) {
            updateLastPlayback();
          },
        );
      },
      child: Padding(
        padding: const EdgeInsets.all(KNumber.s16),
        child: Row(
          children: [
            Container(
              color: Colors.black,
              height: 80,
              width: 100,
              child: Column(
                children: [
                  Expanded(
                    child: VideoPlayerView(controller: videoController),
                  ),
                  Row(
                    children: [
                      Bar(color: Colors.green, flex: totalPlayed),
                      Bar(
                          color: Colors.grey,
                          flex: totalDuration - totalPlayed),
                    ],
                  )
                ],
              ),
            ),
            const SizedBox(
              width: KNumber.s16,
            ),
            Expanded(child: Text(widget.file.getFileName())),
          ],
        ),
      ),
    );
  }
}

class Bar extends StatelessWidget {
  const Bar({
    super.key,
    required this.color,
    required this.flex,
  });

  final Color color;
  final int flex;

  @override
  Widget build(BuildContext context) {
    return Expanded(
      flex: flex,
      child: Container(
        height: KNumber.s4,
        color: color,
      ),
    );
  }
}
