import 'dart:io';

class SubtitleService {
  static Future<String> addSubtitle(FileSystemEntity file) async {
    final pathFile = file.path;
    final jsonFile = File(pathFile);
    final result = await jsonFile.readAsString();
    return result;
  }
}
