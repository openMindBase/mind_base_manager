// @author Matthias Weigt 27.07.2022
// All rights reserved ©2022
import 'latex_builder.dart';

/// This class represents the body of a latex document.
class LatexBuilderBody extends LatexBuilder {
  int _stackDepth = 1;

  void increaseStackDepth() => _stackDepth++;

  void decreaseStackDepth() => _stackDepth--;

  @override
  void addLine(VoidCallback builder) {
    _addTab();
    super.addLine(builder);
  }

  /// Adds: \item [txt]
  void addItem(String txt) {
    addLine(() {
      addBackSlashCommand("item ");
      add(txt);
    });
  }

  void _addTab() {
    for (int i = 0; i < _stackDepth; i++) {
      add("    ");
    }
  }

  void addTikzpictureEnvironment({required VoidCallback builder}) {
    addEnvironment(environment: "tikzpicture", builder: builder);
    // add("\\\\");
    // addLinebreak();
  }


  void addTikRect(
          {required String texTextColor,
          required String minWidth,
          required String minHeight,
            required double xOffset,
            required double yOffset,
            required String text,
          required String texFillColor}) =>
      addTikNode(
          txt:
              "[rectangle,text = $texTextColor,minimum width = $minWidth cm,minimum height = $minHeight cm,fill = $texFillColor] (r) at ($xOffset,$yOffset) {$text};");

  void addTikNode({required String txt}) => addLine(() {
        addBackSlashCommand("node");
        add(txt);
      });

  void addCenterEnvironment({required VoidCallback builder}) =>
      addEnvironment(environment: "center", builder: builder);

  void addEnvironment(
      {required String environment, required VoidCallback builder}) {
    addLine(() {
      addCommandWithCurl(command: "begin", curlTxt: environment);
    });
    increaseStackDepth();
    builder();
    decreaseStackDepth();
    addLine(() {
      addCommandWithCurl(command: "end", curlTxt: environment);
    });
  }

  @override
  void addLineString(String s) {
    _addTab();
    super.addLineString(s);
  }

  /// Adds [s] to the latex code and a line break after that.
  void addSentence(String s) => addLineString(s);

  /// Adds "\title{[title]}", a line break and "\maketitle".
  void addTitle(String title) {
    addLine(() {
      addCommandWithCurl(command: "title", curlTxt: title);
    });
    addLine(() {
      addBackSlashCommand("maketitle");
    });
  }

  /// Adds "\section{[title]}" and a line break after.
  void addSectionCommand(String title) {
    addLine(() {
      addCommandWithCurl(command: "section", curlTxt: title);
    });
  }

  /// Adds "\subsection{[title]}" and a line break after.
  void addSubSectionCommand(String title) {
    addLine(() {
      addCommandWithCurl(command: "subsection", curlTxt: title);
    });
  }

  /// Adds "\section{title}" and a line break after.
  /// Calls [builder] after the line break.
  void addSection(String title, VoidCallback builder) {
    addSectionCommand(title);
    builder();
  }

  /// Adds "\subsection{title}" and a line break after.
  /// Calls [builder] after the line break.
  void addSubSection(String title, VoidCallback builder) {
    addSubSectionCommand(title);
    builder();
  }
}
