// @author Matthias Weigt 27.07.2022
// All rights reserved ©2022
import 'dart:math';

import 'package:flutter/material.dart';

import '../../../domain/entities/math/vector.dart';

class LeanLine extends StatelessWidget {
  const LeanLine(
      {Key? key, required this.from, required this.to, required this.color})
      : super(key: key);

  final Offset from;
  final Offset to;
  final Color color;

  @override
  Widget build(BuildContext context) {
    Offset offset = Offset(to.dx - from.dx, to.dy - from.dy);
    double width = sqrt(offset.dx * offset.dx + offset.dy * offset.dy);

    Container lineBase = Container(
      height: 3,
      color: color,
      width: width,
    );
    double alpha = asin(offset.dy / width);

    if ((offset.dx < 0) && (offset.dy > 0)) {
      alpha *= -1;
    }

    var vec =
    Vector2d(x: width, y: 0).rotateRad(offset.dy > 0 ? alpha : -alpha);

    Widget line = Transform.rotate(
      angle: offset.dy > 0
          ? alpha
          : offset.dx > 0
          ? alpha
          : -alpha,
      child: lineBase,
    );
    double left = -(width - vec.x) / 2 + from.dx;
    if (offset.dx < 0) {
      left -= vec.x;
    }
    double top = vec.y / 2 + from.dy;

    if ((offset.dx < 0) && (offset.dy > 0)) {
      top -= vec.y;
    }

    if (offset.dy < 0) {
      top -= vec.y;
    }
    return Positioned(
      child: Transform(
        alignment: Alignment.center,
        transform: Matrix4.rotationY(pi),
        child: line,
      ),
      bottom: top,
      left: left,
    );
  }
}