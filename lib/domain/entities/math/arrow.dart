// Author = Matthias Weigt
// Date = 10.04.2022


import 'package:mind_base_manager/domain/entities/math/point.dart';
import 'package:mind_base_manager/domain/entities/math/vector.dart';

import 'line.dart';

/// This class represents three vectors building an arrow and the coordinates of the [Lines]s.
class Arrow{
  /// The vector which tells the orientation of the [Arrow].
  final Vector2d baseVector;
  /// The [startingPoint] [MathPoint] of the arrow.
  final MathPoint startingPoint;
  /// The size of the arrowhead.
  final num arrowheadSize;
  /// One of the head vectors.
  late final Vector2d _headVector1;
  /// One of the head vectors.
  late final Vector2d _headVector2;
  /// The main (base) [Line] of the arrow.
  late final Line baseLine;
  /// One of the arrowhead-lines.
  late final Line arrowHeadLine1;
  /// One of the arrowhead-lines.
  late final Line arrowHeadLine2;
  Arrow({required this.baseVector,required this.startingPoint, this.arrowheadSize = 25}) {
    _computeHeadVectors();
    _computeLines();
  }
  /// Computes the head vectors.
  _computeHeadVectors() {
    _headVector1 = baseVector.rotate(25).shorten(baseVector.getAmount() - arrowheadSize).invert();
    _headVector2 = baseVector.rotate(-25).shorten(baseVector.getAmount() - arrowheadSize).invert();

  }
  /// Computes the actual lines with coordinates.
  _computeLines() {
    baseLine = Line(start: startingPoint, end: startingPoint.addTuple(baseVector));
    arrowHeadLine1 = Line(start: startingPoint.addTuple(baseVector), end: baseLine.end.addTuple(_headVector1));
    arrowHeadLine2 = Line(start: startingPoint.addTuple(baseVector), end: baseLine.end.addTuple(_headVector2));
  }
  @override
  String toString() {
    return 'Arrow{baseLine: $baseLine, arrowHeadLine1: $arrowHeadLine1, arrowHeadLine2: $arrowHeadLine2}';
  }
}