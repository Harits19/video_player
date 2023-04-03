import 'package:mime/mime.dart';

class FileUtil {
  static bool isVideo(String path) {
    final mimeType = lookupMimeType(path);
    return mimeType?.startsWith('video/') ?? false;
  }
}
