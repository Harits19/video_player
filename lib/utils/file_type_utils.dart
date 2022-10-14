import 'package:mime/mime.dart';

bool isVideo(String path) {
  final mimeType = lookupMimeType(path);
  return mimeType?.startsWith('video/') ?? false;
}
