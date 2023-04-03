import 'dart:io';

extension FileSystemExtension on FileSystemEntity {
  String getFileName() {
    final listPath = path.split('/');
    return listPath.last;
  }
}
