import 'package:flutter/material.dart';
import 'package:my_video_player/enums/directory_type_enum.dart';
import 'package:my_video_player/extensions/directory_extension.dart';
import 'package:my_video_player/screens/views/list_of_file_view.dart';
import 'dart:io';
import 'package:permission_handler/permission_handler.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({
    Key? key,
    this.directoryTypeEnum = DirectoryTypeEnum.video,
     this.onSubtitleSelected,
  }) : super(key: key);

  final DirectoryTypeEnum directoryTypeEnum;
  final ValueChanged<FileSystemEntity>? onSubtitleSelected;


  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  List<Directory> files = [];

  @override
  void initState() {
    super.initState();
    _getPermission();
  }

  void _getPermission() {
    Permission.storage.request().then((value) => _listOfFiles());
  }

  void _listOfFiles() async {
    files = await getRootFiles();
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return ListOfFileView(
      directoryTypeEnum: widget.directoryTypeEnum,
      showParentDirectory: false,
      files: files,
      onSubtitleSelected: widget.onSubtitleSelected,
    );
  }
}
