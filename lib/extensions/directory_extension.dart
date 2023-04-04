import 'dart:io';

import 'package:path_provider/path_provider.dart';

extension ListDirectoryExtension on List<Directory> {
  
}


Future<List<Directory>> getRootFiles() async {
    final directories = (await getExternalStorageDirectories())!;
    final files = directories.map((Directory e) {
      final List<String> splitPath = e.path.split("/");
      return Directory(splitPath
          .sublist(0, splitPath.indexWhere((element) => element == "Android"))
          .join("/"));
    }).toList();
    return files;
  }