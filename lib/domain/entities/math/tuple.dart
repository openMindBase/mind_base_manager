// Author = Matthias Weigt
// Date = 06.04.2022
/// The representation of a two Tuple (x1,x2).
class Tuple<T> {
  /// The first value.
  final T _x1;
  /// The second value.
  final T _x2;
  /// The obvious constructor.
  Tuple(this._x1, this._x2);
  /// Getter for first component.
  T get x1 => _x1;
  /// Getter for second component.
  T get x2 => _x2;
  /// The [toString] method.
  @override
  String toString() {
    return '($_x1->$_x2)';
  }
}