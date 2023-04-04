import 'package:flutter/services.dart';

class WindowUtil {
  static Future<void> defaultOrientation() async {
    await SystemChrome.setPreferredOrientations(DeviceOrientation.values);
  }

  static Future<void> landscapeOrientation() async {
    await SystemChrome.setPreferredOrientations([
      DeviceOrientation.landscapeRight,
      DeviceOrientation.landscapeLeft,
    ]);
  }

  static Future hideStatusBar() async {
    await SystemChrome.setEnabledSystemUIMode(SystemUiMode.immersiveSticky);
  }

  static Future defaultOverlay() async {
    await SystemChrome.setEnabledSystemUIMode(SystemUiMode.edgeToEdge);
  }

  static Future backToDefault() async {
    await defaultOrientation();
    await defaultOverlay();
  }
}
