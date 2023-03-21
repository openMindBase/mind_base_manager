// Author = Matthias Weigt
// Date = 08.04.2022




import 'package:mind_base_manager/domain/entities/math/tuple.dart';

/// Non mutable extension of [Tuple] to use as point.
class MathPoint extends Tuple<num> {
  MathPoint({required num x, required num y}) : super(x, y);

  /// Constructs the [MathPoint] with a [Tuple].
  MathPoint.byTuple({required Tuple t}) : super(t.x1,t.x2);


  /// Adds x to the current XY and returns new [XY].
  MathPoint addX(int x) => MathPoint(x: x1 + x, y: x2);

  /// Adds y to the current XY and returns new [XY].
  MathPoint addY(int y) => MathPoint(x: x1, y: x2 + y);

  /// Adds x and y to the current XY and returns new [XY].
  MathPoint add({required int x, required int y}) => MathPoint(x: x + x1, y: x2 + y);
  /// Adds a tuple to point.
  MathPoint addTuple(Tuple t) => MathPoint(x: x+t.x1, y: y+t.x2);

  /// Getter for x.
  num get x => x1;

  /// Getter for y.
  num get y => x2;

  @override
  String toString() {
    return "(" + x.toString() + "," + y.toString() + ")";
  }
}
