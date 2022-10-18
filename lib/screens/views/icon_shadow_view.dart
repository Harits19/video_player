import 'package:flutter/material.dart';


class IconShadowView extends Icon {
  const IconShadowView(super.icon,
      {super.key,
      super.color,
      super.semanticLabel,
      super.shadows,
      super.size,
      super.textDirection});

  @override
  Widget build(BuildContext context) {
    return Stack(
      alignment: Alignment.center,
      children: <Widget>[
        Container(
          width: size,
          height: size,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.1),
                blurRadius: 5.0,
              ),
            ],
          ),
        ),
        super.build(context),
      ],
    );
  }
}
