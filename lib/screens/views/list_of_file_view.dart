import 'dart:io';

import 'package:flutter/material.dart';
import 'package:my_video_player/screens/video_screen.dart';
import 'package:my_video_player/screens/views/stream_file_view.dart';
import 'package:my_video_player/utils/file_type_utils.dart';
import 'package:my_video_player/utils/navigation_util.dart';

class ListOfFileView extends StatelessWidget {
  const ListOfFileView({
    super.key,
    required this.files,
  });

  final List<FileSystemEntity> files;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: files.isEmpty
            ? const Center(
                child: Text('Empty Directory'),
              )
            : ListView(
                children: [
                  ...files.map(
                    (e) {
                      if (isVideo(e.path) || e is Directory) {
                        return InkWell(
                          child: ListTile(
                            title: Text(e.toString()),
                          ),
                          onTap: () {
                            if (e is Directory) {
                              push(context, StreamFileView(file: e));
                            } else if (e is File && isVideo(e.path)) {
                              push(
                                context,
                                VideoScreen(path: e.path),
                              );
                            }
                          },
                        );
                      }
                      return const SizedBox();
                    },
                  ),
                ],
              ),
      ),
    );
  }
}
