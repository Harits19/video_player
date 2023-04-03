import 'package:my_video_player/enums/share_pref_key_enum.dart';
import 'package:my_video_player/extensions/share_pref_extension.dart';
import 'package:my_video_player/screens/constans/number_constan.dart';
import 'package:shared_preferences/shared_preferences.dart';

class SharedPrefService {
  static SharedPreferences? prefs;

  static Future<void> initPref() async {
    prefs = await SharedPreferences.getInstance();
  }

  static Future<void> savePlaybackSpeed(double playbackSpeed) async {
    await prefs?.setDoubleV2(SharePrefKeyEnum.playbackSpeed, playbackSpeed);
  }

  static double getPlaybackSpeed() {
    return prefs?.getDoubleV2(SharePrefKeyEnum.playbackSpeed) ??
        KNumber.defaultPlaybackSpeed;
  }
}
