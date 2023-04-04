import 'dart:io';

import 'package:flutter/material.dart';
import 'package:my_video_player/enums/directory_type_enum.dart';
import 'package:my_video_player/extensions/file_system_extension.dart';
import 'package:my_video_player/screens/video_screen.dart';
import 'package:my_video_player/screens/views/stream_file_view.dart';
import 'package:my_video_player/extensions/context_extension.dart';
import 'package:my_video_player/screens/views/thumbnail_view.dart';

class ListOfFileView extends StatelessWidget {
  const ListOfFileView({
    super.key,
    required this.files,
    this.showParentDirectory = true,
    this.directoryTypeEnum = DirectoryTypeEnum.video,
    this.onSubtitleSelected,
  });

  final List<FileSystemEntity> files;
  final bool showParentDirectory;
  final DirectoryTypeEnum directoryTypeEnum;
  final ValueChanged<FileSystemEntity>? onSubtitleSelected;

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
                    (file) {
                      final showVideo =
                          directoryTypeEnum == DirectoryTypeEnum.video;
                      final showSubtitle =
                          directoryTypeEnum == DirectoryTypeEnum.subtitle;
                      final isDirectory = file is Directory;
                      final isSubtitle = (file.isSubtitle() && showSubtitle);

                      if (file.isVideo() && showVideo) {
                        return ThumbnailView(file: file);
                      }

                      if (isDirectory || isSubtitle) {
                        return InkWell(
                          child: ListTile(
                            title: Text(file.getFileName()),
                          ),
                          onTap: () {
                            if (isDirectory) {
                              context.push(
                                StreamFileView(
                                  file: file,
                                  directoryTypeEnum: directoryTypeEnum,
                                  onSubtitleSelected: onSubtitleSelected,
                                ),
                              );
                            } else if (isSubtitle) {
                              assert(onSubtitleSelected != null);
                              onSubtitleSelected!(file);
                              Navigator.of(context).popUntil(
                                (route) {
                                  return route.settings.name ==
                                      VideoScreen.routeName;
                                },
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
