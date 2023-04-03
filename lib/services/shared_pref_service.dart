import 'package:my_video_player/screens/constans/number_constan.dart';
import 'package:shared_preferences/shared_preferences.dart';

enum _Key {
  kPlaybackSpeed,
}

class SharedPrefService {
  static SharedPreferences? prefs;

  static Future<void> initPref() async {
    prefs = await SharedPreferences.getInstance();
  }

  static Future<void> savePlaybackSpeed(double playbackSpeed) async {
    await prefs!.setDouble(_Key.kPlaybackSpeed.name, playbackSpeed);
  }

  static double getPlaybackSpeed() {
    return prefs!.getDoubleV2(_Key.kPlaybackSpeed) ?? KNumber.defaultPlaybackSpeed;
  }
}

extension on SharedPreferences? {
  double? getDoubleV2(_Key key) {
    return this?.getDouble(key.name);
  }
}
