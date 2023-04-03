import 'package:flutter/material.dart';
import 'package:my_video_player/enums/direction_to_enum.dart';
import 'package:my_video_player/screens/constans/number_constan.dart';
import 'package:my_video_player/screens/views/ink_well_view.dart';

class SeekWidget extends StatelessWidget {
  const SeekWidget({
    Key? key,
    required this.onDoubleTap,
    this.directionTo = DirectionToEnum.left,
    required this.radius,
  })  : assert(
          directionTo == DirectionToEnum.left ||
              directionTo == DirectionToEnum.right,
        ),
        super(key: key);

  final VoidCallback onDoubleTap;
  final DirectionToEnum directionTo;
  final double radius;

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: InkWellView(
        onDoubleTap: onDoubleTap,
        borderRadius: () {
          final radius = Radius.circular(this.radius);
          final left = BorderRadius.horizontal(left: radius);
          final right = BorderRadius.horizontal(right: radius);
          if (directionTo == DirectionToEnum.left) {
            return left;
          }
          if (directionTo == DirectionToEnum.right) {
            return right;
          }
        }(),
        child: Container(
          alignment: Alignment.center,
          height: double.infinity,
          width: double.infinity,
          child: Text(
            '${KNumber.kSeekDuration.inSeconds} seconds',
            style: const TextStyle(
              color: Colors.white,
            ),
          ),
        ),
      ),
    );
  }
}
