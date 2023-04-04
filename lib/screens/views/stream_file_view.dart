import 'dart:io';

import 'package:flutter/material.dart';
import 'package:my_video_player/enums/directory_type_enum.dart';
import 'package:my_video_player/screens/views/list_of_file_view.dart';

class StreamFileView extends StatefulWidget {
  const StreamFileView({
    Key? key,
    this.file,
    required this.directoryTypeEnum,
    this.onSubtitleSelected,
  }) : super(key: key);

  /// to get list of file using stream
  final FileSystemEntity? file;
  final DirectoryTypeEnum directoryTypeEnum;
  final ValueChanged<FileSystemEntity>? onSubtitleSelected;

  @override
  State<StreamFileView> createState() => _StreamFileViewState();
}

class _StreamFileViewState extends State<StreamFileView> {
  final List<FileSystemEntity> listStreamFile = [];

  @override
  void initState() {
    super.initState();
    final file = widget.file;
    if (file is Directory) {
      file.list().listen((event) {
        listStreamFile.add(event);
        setState(() {});
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return ListOfFileView(
      onSubtitleSelected: widget.onSubtitleSelected,
      files: listStreamFile,
      directoryTypeEnum: widget.directoryTypeEnum,
    );
  }
}
