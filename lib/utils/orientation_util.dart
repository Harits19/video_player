import 'package:flutter/services.dart';

class OrientationUtil {
  static Future<void> defaultOrientation() async {
    await SystemChrome.setPreferredOrientations(DeviceOrientation.values);
  }

  static Future<void> landscapeOrientation() async {
    await SystemChrome.setPreferredOrientations([
      DeviceOrientation.landscapeRight,
      DeviceOrientation.landscapeLeft,
    ]);
  }
}
