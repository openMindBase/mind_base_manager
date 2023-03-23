// @author Matthias Weigt 27.07.2022

import 'latex_builder.dart';
import 'latex_builder_body.dart';

/// This class represents a latex document.
class LatexBuilderDoc extends LatexBuilder {

  /// The body of the latex document.
  final LatexBuilderBody body = LatexBuilderBody();

  /// Adds "\documentclass[[font]]{[type]}" and a line break after that.
  void addDocumentClass(String font, String type) {
    addBackSlashCommand("documentclass");
    addBrackes(font);
    addBraces(type);
    addLinebreak();
  }

  /// Adds "\documentclass[11pt]{article}" and a line break after that.
  void addArticleClass() => addDocumentClass("11pt", "article");

  /// Adds "\usepackage{[name]}" and a line break after that.
  void addUsePackage(String name) {
    addBackSlashCommand("usepackage");
    addBraces(name);
    addLinebreak();
  }

  @override
  String toString() {
    _addBeginDoc();
    add(body.toString());
    _addEndDoc();
    return super.toString();
  }

  /// Adds "\begin{document}" and a line break after that.
  void _addBeginDoc() {
    addCommandWithCurl(command: "begin", curlTxt: "document");
    addLinebreak();
  }

  /// Adds "\end{document}" and a line break after that.
  void _addEndDoc() {
    addCommandWithCurl(command: "end", curlTxt: "document");
    addLinebreak();
  }
}
