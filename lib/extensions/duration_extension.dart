
extension DurationExtension on Duration {
  String durationToTime() {
    return toString().split('.').first;
  }
}
