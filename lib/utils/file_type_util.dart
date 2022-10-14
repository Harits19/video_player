import 'dart:io';

import 'package:mime/mime.dart';


class FileUtil {
  static String getFileName(FileSystemEntity e) {
    
    final listPath = e.path.split('/');
    return listPath.last;
  }

  static bool isVideo(String path) {
  final mimeType = lookupMimeType(path);
  return mimeType?.startsWith('video/') ?? false;
}

}
