import 'dart:io';

import 'package:flutter/material.dart';
import 'package:my_video_player/screens/video_screen.dart';
import 'package:my_video_player/screens/views/stream_file_view.dart';
import 'package:my_video_player/utils/file_util.dart';
import 'package:my_video_player/utils/nav_util.dart';

class ListOfFileView extends StatelessWidget {
  const ListOfFileView({
    super.key,
    required this.files,
    this.showParentDirectory = true,
  });

  final List<FileSystemEntity> files;
  final bool showParentDirectory;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: showParentDirectory
            ? Text(files.isEmpty ? '' : files.first.parent.path)
            : null,
      ),
      body: SafeArea(
        child: files.isEmpty
            ? const Center(
                child: Text('Empty Directory'),
              )
            : ListView(
                children: [
                  ...files.map(
                    (e) {
                      if (FileUtil.isVideo(e.path) || e is Directory) {
                        return InkWell(
                          child: ListTile(
                            title: Text(FileUtil.getFileName(e)),
                          ),
                          onTap: () {
                            if (e is Directory) {
                              NavUtil.push(context, StreamFileView(file: e));
                            } else if (e is File && FileUtil.isVideo(e.path)) {
                              NavUtil.push(
                                context,
                                VideoScreen(file: e),
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
