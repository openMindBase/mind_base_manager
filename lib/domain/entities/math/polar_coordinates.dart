import 'dart:math';


import 'package:mind_base_manager/domain/entities/math/tuple.dart';

class PolarCoordinates{
  final double radius;
  final double angle;

  PolarCoordinates({required this.radius,required this.angle});

  Tuple<double> toCartesian({double xOffset=0,double yOffset=0}) {
    final double angleRad = (angle+90)*pi/180;
    final double x = radius * cos(angleRad);
    final double y = radius * sin(angleRad);
    return Tuple<double>(x+xOffset,y+yOffset);
  }

  @override
  String toString() {
    return 'PC{r: $radius, a: $angle}';
  }
}