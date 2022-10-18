import 'package:flutter/material.dart';
import 'package:my_video_player/screens/views/list_of_file_view.dart';
import 'dart:io';
import 'package:path_provider/path_provider.dart';
import 'package:permission_handler/permission_handler.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({Key? key}) : super(key: key);

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
    var directories = (await getExternalStorageDirectories())!;
    files = directories.map((Directory e) {
      final List<String> splitPath = e.path.split("/");
      return Directory(splitPath
          .sublist(0, splitPath.indexWhere((element) => element == "Android"))
          .join("/"));
    }).toList();

    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return ListOfFileView(
      showParentDirectory: false,
      files: files,
    );

  }
}
