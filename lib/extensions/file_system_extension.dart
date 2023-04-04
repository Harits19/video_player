import 'dart:io';

import 'package:mime/mime.dart';

extension FileSystemExtension on FileSystemEntity {
  String getFileName() {
    final listPath = path.split('/');
    return listPath.last;
  }

  bool isVideo() {
    final mimeType = lookupMimeType(path);
    print('mimeType : $mimeType');
    return mimeType?.startsWith('video/') ?? false;
  }

  bool isSubtitle() {
    final mimeType = lookupMimeType(path);
    return mimeType?.endsWith('/x-subrip') ?? false;
  }
}
