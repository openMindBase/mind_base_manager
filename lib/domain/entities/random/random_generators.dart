// Author = Matthias Weigt
// Date = 16.05.2022

import 'dart:math';
class RandomHashGenerator {
  static const int defaultLength = 20;

  RandomHashGenerator({this.length = defaultLength}):charSet=_CharSet.charSet;


  final int length;
  final List<String> charSet;
  final randomGenerator = Random();

  /// Gets the random hash.
  String get() {
    String output = "";
    for(int i = 0; i < length; i++) {
      output += charSet[randomGenerator.nextInt(charSet.length-1)];
    }
    return output;
  }


  @override
  String toString() {
    return get();
  }
}

/// All Chars within the created hash.
class _CharSet{
  static const List<String> charSet = [
    "a",
    "b",
    "c",
    "d",
    "e",
    "f",
    "g",
    "h",
    "i",
    "j",
    "k",
    "l",
    "m",
    "n",
    "o",
    "p",
    "q",
    "r",
    "s",
    "t",
    "u",
    "v",
    "w",
    "x",
    "y",
    "z",
    "A",
    "B",
    "C",
    "D",
    "E",
    "F",
    "G",
    "H",
    "I",
    "J",
    "K",
    "L",
    "M",
    "N",
    "O",
    "P",
    "Q",
    "R",
    "S",
    "T",
    "U",
    "V",
    "W",
    "X",
    "Y",
    "Z",
    "0",
    "1",
    "2",
    "3",
    "4",
    "5",
    "6",
    "7",
    "8",
    "9"
  ];
}