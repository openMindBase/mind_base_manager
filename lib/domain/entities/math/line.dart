// Author = Matthias Weigt
// Date = 10.04.2022




import 'package:mind_base_manager/domain/entities/math/point.dart';

/// Simple representation of a [Line] with a [start] and an [end].
class Line {
  /// Starting-point.
  final MathPoint start;
  /// Ending-point.
  final MathPoint end;

  Line({required this.start, required this.end});

  @override
  String toString() {
    return '{start: $start, end: $end}';
  }
}