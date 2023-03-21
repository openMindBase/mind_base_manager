// Author = Matthias Weigt
// Date = 12.04.2022

import 'dart:math';

import 'package:mind_base_manager/domain/entities/math/point.dart';

import 'convert.dart';





/// This class represents a circle.
class Circle {
  /// [center] represents the [MathPoint] of the center of the circle.
  final MathPoint _center;

  /// Represents the radius of the given [Circle] as [num].
  final num _radius;

  Circle(this._center, this._radius);

  /// Computes the [MathPoint] at the border of the circle with the given degree.
  MathPoint getPoint(num degree) {
    num rad = Convert.degToRad(degree);
    return MathPoint(
        x: sin(rad) * _radius + _center.x,
        y: cos(rad) * _radius * -1 + _center.y);
  }

  MathPoint get center => _center;

  num get radius => _radius;

  @override
  String toString() {
    return 'Circle{_center: $_center, _radius: $_radius}';
  }
}
