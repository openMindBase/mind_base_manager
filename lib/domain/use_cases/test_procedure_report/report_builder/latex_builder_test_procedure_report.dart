// @author Matthias Weigt 27.07.2022
// All rights reserved ©2022


import '../test_procedure_report.dart';
import 'latex_builder.dart';
import 'latex_builder_doc.dart';

/// Use this class as a as a [LatexBuilder] for a [TestProcedureReport].
class LatexBuilderTestProcedureReport extends LatexBuilderDoc {

  /// Starts the document by adding "\documentclass[11pt]{article}" and a line break after that.
  /// Followed up by "\usepackage{amsmath}" and a line break after that.
  LatexBuilderTestProcedureReport() {
    addArticleClass();
    addUsePackage("amsmath");
    addUsePackage("graphicx");
    addUsePackage("tikz");
    add("\\usepackage[a4paper, left=2cm, right=2cm, top=2cm]{geometry}");
    add("\\usepackage[ngerman]{babel}");
    addLinebreak();
  }
}
