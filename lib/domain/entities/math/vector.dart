// Author = Matthias Weigt
// Date = 10.04.2022

import 'dart:math';


import 'package:mind_base_manager/domain/entities/math/tuple.dart';
import 'package:mind_base_manager/domain/entities/math/xy_coordinates.dart';



/// A 2-dimensional vector.
class Vector2d extends Tuple<num> {
  Vector2d({required num x, required num y}) : super(x, y);
  /// Constructs a [Vector2d] with a [XY] obj.
  Vector2d.byXY({required XY xy}) : super(xy.x, xy.y);

  /// Getter for x.
  num get x => x1;

  /// Getter for y.
  num get y => x2;

  /// Computes the amount of the vector.
  num getAmount() => sqrt(x * x + y * y);

  /// Rotates the vector the given angle.
  Vector2d rotate(num angle) {
    angle = angle * pi / -180;
    num newX = x * cos(angle) - y * sin(angle);
    num newY = x * sin(angle) + y * cos(angle);
    return Vector2d(x: newX, y: newY);
  }

  /// Rotates the vector the given angle.
  Vector2d rotateRad(num angle) {
    num newX = x * cos(angle) - y * sin(angle);
    num newY = x * sin(angle) + y * cos(angle);
    return Vector2d(x: newX, y: newY);
  }

  /// Normalizes the vector to an [getAmount] of 1.
  Vector2d norm() {
    num a = getAmount();
    return Vector2d(x: x / a, y: y / a);
  }

  /// Adds another tuple.
  Vector2d add(Tuple t) {
    return Vector2d(x: x + x1, y: y + x2);
  }

  /// Shortens the vector by a given total amount.
  Vector2d shorten(num amount) {
    num percentage = 1 - (amount / getAmount());
    return Vector2d(x: x * percentage, y: y * percentage);
  }
  /// Inverts the vector.
  Vector2d invert() {
    return Vector2d(x: x * -1, y: y * -1);
  }

  @override
  String toString() {
    return "(" + x.toString() + "," + y.toString() + ")";
  }
}
