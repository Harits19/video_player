import 'package:flutter/material.dart';
import 'package:my_video_player/extensions/double_extension.dart';
import 'package:my_video_player/screens/constans/number_constan.dart';

class PlaybackDialogView extends StatefulWidget {
  const PlaybackDialogView({
    super.key,
    required this.playbackSpeed,
    required this.onChangedPlayback,
  });
  final double playbackSpeed;
  final ValueChanged<double> onChangedPlayback;

  static void showPlaybackDialog(
    BuildContext context, {
    required double playbackSpeed,
    required ValueChanged<double> onChangedPlayback,
  }) {
    showDialog(
      context: context,
      builder: (context) {
        return PlaybackDialogView(
          playbackSpeed: playbackSpeed,
          onChangedPlayback: onChangedPlayback,
        );
      },
    );
  }

  @override
  State<PlaybackDialogView> createState() => _PlaybackDialogViewState();
}

class _PlaybackDialogViewState extends State<PlaybackDialogView> {
  late var _playbackSpeed = widget.playbackSpeed;
  @override
  Widget build(BuildContext context) {
    return Dialog(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          const SizedBox(
            height: KNumber.s16,
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: List.generate(
                  KNumber.playbackDivisions.toInt(),
                  (index) => Text(((index + 1) /
                          KNumber.playbackDivisions *
                          KNumber.maxPlaybackSpeed)
                      .displayPlayback)),
            ),
          ),
          Slider(
            max: KNumber.maxPlaybackSpeed,
            value: _playbackSpeed,
            min: KNumber.minPlaybackSpeed,
            label: _playbackSpeed.displayPlayback,
            divisions: (KNumber.playbackDivisions - 1),
            onChanged: (val) {
              widget.onChangedPlayback(val);
              _playbackSpeed = val;
              setState(() {});
            },
          ),
        ],
      ),
    );
  }
}
