// Author = Matthias Weigt
// Date = 12.04.2022

import 'dart:math';

/// Converts some important math formats.
class Convert{
  /// Converts degree to radiant.
  static num degToRad(num deg) => deg * pi / 180;
  /// Converts radiant to degree.
  static num radToDeg(num rad) => rad / pi * 180;
}