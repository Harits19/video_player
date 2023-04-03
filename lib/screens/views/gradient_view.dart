import 'package:flutter/material.dart';
import 'package:my_video_player/enums/direction_to_enum.dart';
import 'package:my_video_player/screens/constans/number_constan.dart';

class GradientView extends StatelessWidget {
  const GradientView({
    Key? key,
    this.children = const [],
    required this.directionTo,
  })  : assert(
          directionTo == DirectionToEnum.top ||
              directionTo == DirectionToEnum.bottom,
        ),
        super(key: key);

  final List<Widget> children;
  final DirectionToEnum directionTo;

  @override
  Widget build(BuildContext context) {
    const topCenter = Alignment.topCenter;
    const bottomCenter = Alignment.bottomCenter;
    return Container(
      padding: const EdgeInsets.all(KNumber.s8),
      height: KNumber.s48,
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: directionTo == DirectionToEnum.top ? bottomCenter : topCenter,
          end: directionTo == DirectionToEnum.top ? topCenter : bottomCenter,
          colors: <Color>[
            Colors.black.withOpacity(0.3),
            Colors.transparent,
          ],
        ),
      ),
      child: Row(
        children: children,
      ),
    );
  }
}
