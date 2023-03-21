// Author = Matthias Weigt
// Date = 08.04.2022



import 'package:mind_base_manager/domain/entities/math/point.dart';
import 'package:mind_base_manager/domain/entities/math/tuple.dart';

/// Non mutable extension of [Tuple] to use as coordinates.
class XY extends Tuple<int> {
  XY({required int x, required int y}) : super(x, y);


  XY.byTuple(Tuple t): super(t.x1, t.x2);

  /// Constructor by [MathPoint] rounds x and y of [MathPoint] to int.
  XY.byMathPoint(MathPoint mathPoint) : this(x:mathPoint.x.round(),y:mathPoint.y.round());

  /// Adds x to the current XY and returns new [XY].
  XY addX(int x) => XY(x: x1 + x, y: x2);

  /// Adds y to the current XY and returns new [XY].
  XY addY(int y) => XY(x: x1, y: x2 + y);

  /// Adds x and y to the current XY and returns new [XY].
  XY add({required int x, required int y}) => XY(x: x + x1, y: x2 + y);

  /// Getter for x.
  int get x => x1;

  /// Getter for y.
  int get y => x2;

  @override
  String toString() {
    return '(' + x.toString() + "," + y.toString() + ")";
  }
}
