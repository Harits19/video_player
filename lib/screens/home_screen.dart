import 'package:file_manager/file_manager.dart';
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
      final List<String> splitedPath = e.path.split("/");
      return Directory(splitedPath
          .sublist(0, splitedPath.indexWhere((element) => element == "Android"))
          .join("/"));
    }).toList();

    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    print(files);
    return ListOfFileView(
      files: files,
    );

    return FileManager(
      controller: FileManagerController(),
      builder: ((context, snapshot) => const SizedBox()),
    );
  }
}
