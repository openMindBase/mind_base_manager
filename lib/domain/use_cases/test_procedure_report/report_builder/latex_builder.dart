// @author Matthias Weigt 27.07.2022
// All rights reserved ©2022
/// Use this class to build latex code.
class LatexBuilder {

  /// The latex code.
  String output = "";

  /// Adds [s] to the latex code.
  void add(String s) => output += s;

  /// Adds [s] to the latex code and a line break after that.
  void addLineString(String s) {
    add(s);
    addLinebreak();
  }

  /// Use this class to add a line break after calling [builder].
  void addLine(VoidCallback builder) {
    builder();
    addLinebreak();
  }

  void addLinebreak() => add("\n");

  /// Takes [s] ,[m] and [e] and adds them to a new string.
  void addBordered(String s, String m, String e) => add(s + m + e);

  /// Puts the input [m] in brackets.
  void addBrackes(String m) => addBordered('[', m, ']');

  /// Puts the input [m] in braces.
  void addBraces(String m) => addBordered('{', m, '}');

  /// Puts the input [m] in parentheses.
  void addParentheses(String m) => addBordered('(', m, ')');

  /// Puts a backslash before the input [s].
  void addBackSlashCommand(String s) => add('\\$s');

  /// Adds "\[command]{[curlTxt]}".
  void addCommandWithCurl({required String command, required String curlTxt}) {
    addBackSlashCommand(command);
    addBraces(curlTxt);
  }

  @override
  String toString() {
    output = output.replaceAll("<br>", "\\\\");

    return output;
  }
}

/// Use this type definition for a builder function.
typedef VoidCallback = void Function();
