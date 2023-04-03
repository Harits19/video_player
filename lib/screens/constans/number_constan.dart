class KNumber {
  const KNumber._();

  static const kSeekDuration = Duration(seconds: 5);
  static const kAnimationDuration = Duration(milliseconds: 300);
  static const double s2 = 2,
      s4 = 4,
      s8 = 8,
      s32 = 32,
      s48 = 48,
      s16 = 16,
      maxPlaybackSpeed = 2,
      minPlaybackSpeed = maxPlaybackSpeed / playbackDivisions,
      defaultPlaybackSpeed = 1;
  static const playbackDivisions = 8;
}
