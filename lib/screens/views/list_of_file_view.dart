import 'dart:io';

import 'package:flutter/material.dart';
import 'package:my_video_player/extensions/file_system_extension.dart';
import 'package:my_video_player/screens/video_screen.dart';
import 'package:my_video_player/screens/views/stream_file_view.dart';
import 'package:my_video_player/utils/file_extension.dart';
import 'package:my_video_player/extensions/context_extension.dart';

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
                            title: Text(e.getFileName()),
                          ),
                          onTap: () {
                            if (e is Directory) {
                              context.push(StreamFileView(file: e));
                            } else if (e is File && FileUtil.isVideo(e.path)) {
                              context.push(
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
