import 'package:flutter/services.dart';

class OverlayUtil {
  static Future hideStatusBar() async {
    await SystemChrome.setEnabledSystemUIMode(SystemUiMode.immersiveSticky);
  }

  static Future defaultOverlay() async {
    await SystemChrome.setEnabledSystemUIMode(SystemUiMode.edgeToEdge);
  }
}
