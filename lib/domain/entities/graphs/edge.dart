// @author Matthias Weigt 27.07.2022
// All rights reserved ©2022
import 'node.dart';

/// This class represents an edge between two [Node]s in [Graph].
class Edge {

  /// Use this constructor if you want to initialize an [Edge] with two [Node]s.
  /// This constructor validates the input with [_validate] and throws if input is not valid.
  Edge.fromNodes({required Node node1, required Node node2})
      : x1 = node1.id,
        x2 = node2.id {
    _validate();
  }

  /// Use this constructor if you want to initialize an [Edge] with two ids that represent [Node]s.
  /// This constructor validates the input with [_validate] and throws if input is not valid.
  Edge({required this.x1, required this.x2}) {
    _validate();
  }

  /// [x1] is the id of a [Node] that represents the starting point of this [Edge].
  final String x1;

  /// [x2] is the id of a [Node] that represents the ending point of this [Edge].
  final String x2;

  /// Throws if [x1] == [x2].
  void _validate() {
    if (x1 == x2) {
      throw ArgumentError("Edge: x1($x1) should not equal x2($x2)");
    }
  }

  /// == can be used to consistently check the equality of two [Edge]s.
  @override
  bool operator ==(covariant Edge other) {
    return x1 == other.x1 && other.x2 == x2;
  }

  @override
  int get hashCode => (x1.toString() + x2.toString()).hashCode;

  @override
  String toString() {
    return '($x1, $x2)';
  }
}
