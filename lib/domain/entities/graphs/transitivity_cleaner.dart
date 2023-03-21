// @author Matthias Weigt 27.07.2022
// All rights reserved ©2022
import 'edge.dart';
import 'node.dart';

/// Use this class to clean all transitive [Edge]s in a set of [Edge]s.
/// If there are two or more ways between two [LearningGoal]s the shorter ways will be deleted.
/// The shorter ways are called transitive [Edge]s.
class TransitivityCleaner {
  TransitivityCleaner(this._input);

  /// A set of [Edge]s in [Graph].
  final Set<Edge> _input;

  /// Easy access to all transitive [Edge]s in [_input].
  final Set<Edge> _transitives = {};

  /// Returns a set of all non-transitive [Edges] in [_input].
  Set<Edge> get() {
    for (Edge edge in _input) {
      if (_checkTupleForTransitivity(edge)) {
        break;
      }
    }
    if (_transitives.isEmpty) {
      return _input;
    }
    Set<Edge> output = {};
    for (Edge edge in _input) {
      for (Edge edge2 in _transitives) {
        if (edge.x1 != edge2.x1 || edge.x2 != edge2.x2) {
          output.add(edge);
        }
      }
    }
    return TransitivityCleaner(output).get();
  }

  /// Returns [true] and adds the input [edge] to [_transitives] if the input [edge] is transitive.
  /// Returns [false] if the input [edge] is not transitive.
  bool _checkTupleForTransitivity(Edge edge) {
    Set<String> directSuccessors = _get(edge.x1);
    directSuccessors.removeWhere((element) => element == edge.x2);
    try {
      _generatePaths(directSuccessors, edge.x2);
    } catch (e) {
      print("cleans tuple: $edge");
      _transitives.add(edge);
      return true;
    }
    return false;
  }

  /// Takes a set of strings that represent the [Node.id] of [Node]s and throws if one of these [Node]s or one of their successors is equal to the input [start].
  void _generatePaths(Set<String> startingPoints, String start) {
    if (startingPoints.isEmpty) {
      return;
    }
    for (String s in startingPoints) {
      if (s == start) {
        // Transitive candidate.
        throw Error();
      }
      _generatePaths(_get(s), start);
    }
  }

  /// Gets a set of strings that represent the [Node.id] of the [Node]s that are direct successors of the [Node] represented by the input [s].
  Set<String> _get(String s) {
    Set<String> output = {};
    for (var e in _input) {
      if (e.x1 == s) {
        output.add(e.x2);
      }
    }
    return output;
  }
}
