

import 'package:mime/mime.dart';

extension StringExtension on String{

     bool isVideo() {
    final mimeType = lookupMimeType(this);
    return mimeType?.startsWith('video/') ?? false;
  }
}