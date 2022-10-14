import 'dart:io';

import 'package:flutter/material.dart';
import 'package:my_video_player/screens/views/list_of_file_view.dart';

class StreamFileView extends StatefulWidget {
  const StreamFileView({
    Key? key,
    this.file,
  }) : super(key: key);

  /// to get list of file using stream
  final FileSystemEntity? file;

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
        print(event);
        listStreamFile.add(event);
        setState(() {});
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return ListOfFileView(files: listStreamFile);
  }
}
