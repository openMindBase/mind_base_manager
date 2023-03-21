// Author = Matthias Weigt
// Date = 06.04.2022


import 'package:mind_base_manager/domain/entities/math/tuple.dart';

/// This is a simple representation of a mathematical relation.
class Relation<T> {
  /// The relation is stored as a [Set] of [Tuple].
  Set<Tuple<T>> _tuples = {};

  /// The primary constructor.
  Relation(Set<Tuple<T>> tuples) {
    Relation<T> relation = Relation<T>._private(tuples);
    for (Tuple<T> tuple in relation._tuples) {
      add(tuple);
    }
  }

  /// The private constructor only for inner class use.
  Relation._private(this._tuples);

  /// Adds a tuple to the relation.
  void add(Tuple<T> tuple) {
    Set<T> set = get(tuple.x1);
    if (!set.contains(tuple.x2)) {
      _tuples.add(tuple);
    }
  }

  /// Gets a T [value] and returns a about_us_list of all values where the tuple starts with [value].
  /// Like f(x)=[y,...,z] with x as input and [y,...,z] as output.
  Set<T> get(T value) {
    Set<T> output = {};
    for (var element in _tuples) {
      if (element.x1 == value) output.add(element.x2);
    }
    return output;
  }

  /// The inverse method to get(...).
  Set<T> getInverted(T value) {
    Set<T> output = {};
    for (var element in _tuples) {
      if (element.x2 == value) output.add(element.x1);
    }
    return output;
  }

  /// Gets a about_us_list of all first elements of the tuples.
  Set<T> getX1() {
    Set<T> output = {};
    for (var element in _tuples) {
      output.add(element.x1);
    }
    return output;
  }

  /// Gets a about_us_list of all second elements of the tuples.
  Set<T> getX2() {
    Set<T> output = {};
    for (var element in _tuples) {
      output.add(element.x2);
    }
    return output;
  }

  /// Getter for the tuples.
  Set<Tuple<T>> get tuples => _tuples;

  @override
  String toString() {
    return 'Relation{_tuples: $_tuples}';
  }
}
