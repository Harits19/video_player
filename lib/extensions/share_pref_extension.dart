import 'package:my_video_player/enums/share_pref_key_enum.dart';
import 'package:shared_preferences/shared_preferences.dart';

extension SharePrefExtension on SharedPreferences {
  double? getDoubleV2(SharePrefKeyEnum key) {
    return getDouble(key.name);
  }

  Future<void> setDoubleV2(SharePrefKeyEnum key, double value) {
    return setDouble(key.name, value);
  }
}
