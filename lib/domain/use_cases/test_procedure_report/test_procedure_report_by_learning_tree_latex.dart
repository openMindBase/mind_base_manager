// @author Matthias Weigt 27.07.2022
// All rights reserved ©2022



import 'package:mind_base_manager/domain/use_cases/test_procedure_report/report_builder/latex_builder_body.dart';
import 'package:mind_base_manager/domain/use_cases/test_procedure_report/report_builder/latex_builder_test_procedure_report.dart';
import 'package:mind_base_manager/domain/use_cases/test_procedure_report/test_procedure_report_by_learning_tree.dart';

import '../../entities/exercise.dart';
import '../../entities/learning_goals_and_structures/learning_goal.dart';

/// This is a abstract class that represents a [TestProcedureReportByLearningTree] in latex.
abstract class TestProcedureReportByLearningTreeLatex
    extends TestProcedureReportByLearningTree {
  TestProcedureReportByLearningTreeLatex(super.learningTree, {super.name});

  /// The [builder] for the [TestProcedureReportByLearningTree] in latex.
  final LatexBuilderTestProcedureReport builder =
      LatexBuilderTestProcedureReport();

  @override
  String get() {
    addTitle(name);
    addTreeVisualSection();
    addTopicSection();
    addLearningGoalsToImproveSection();
    addKeyLearningGoalSection();
    body.addBackSlashCommand("newpage");
    body.addLinebreak();
    addImprovementGoals();
    addKeyLearningGoalSolution();
    addEndSection();
    return outputString;
  }

  /// Adds [name] as the title of [TestProcedureReportByLearningTreeLatex].
  void addTitle(String name);

  void addEndSection() {
    body.addSection("Gut orientiert?", () {
      body.addLineString("Hallo $name,\n\\\\dir hat unsere Analyse gefallen?");
      body.addLineString("Dann empfiehl uns gern einem/einer Freund:in! :)");
      body.add("\\\\");
      body.addLineString(
          "Unser Ziel ist es, möglichst viele Menschen zu erreichen und ihnen transparent bei ihrer Klausurvorbereitung zu helfen.");
      body.add("\\\\");
      body.addLineString(
          "Wir wünschen dir viel Erfolg beim Lernen und freuen uns über einen erneuten Besuch! :D");
      body.add("\\\\");
      body.add("\\\\");
      body.addLineString("Viele Grüße");
      body.add("\\\\");
      body.addLineString("Team Lernzweige");
    });
  }

  void addTreeVisualSectionBody();

  /// Adds a section in [TestProcedureReportByLearningTreeLatex] where key [LearningGoal]s can be displayed.
  void addKeyLearningGoalSectionBody();

  /// Adds the body to the section where the [LearningGoal]s, which should be improved are displayed.
  void addLearningGoalsToImproveSectionBody();

  /// The explanation of the tree types of goals.
  void addExplanationSectionBody();

  void addKeyLearningGoalSolutionBody();

  void addImprovementGoalsSolutionBody();

  /// Adds a section for the topic of [TestProcedureReportByLearningTreeLatex].
  void addTopicBody();

  /// Gets [LatexBuilderDoc.body].
  LatexBuilderBody get body => builder.body;

  /// Gets [TestProcedureReportByLearningTree] as a string.
  String get outputString => builder.toString();

  /// Prints "Schlüssellernziele" and adds a section in [TestProcedureReportByLearningTreeLatex] where key [LearningGoal]s can be displayed.
  void addKeyLearningGoalSection() {
    body.addSection(
        "Schlüssellernziele (Orange)", addKeyLearningGoalSectionBody);
  }

  void addLearningGoalsToImproveSection() {
    body.addSection(
        "Verbesserungsziele (Gelb)", addLearningGoalsToImproveSectionBody);
  }

  void addKeyLearningGoalSolution() {
    body.addSection(
        "Schlüssellernziele (Orange) Lösungen", addKeyLearningGoalSolutionBody);
  }

  void addImprovementGoals() {
    body.addSection(
        "Verbesserungsziele (Gelb) Lösungen", addImprovementGoalsSolutionBody);
  }

  void addExplanationSection() {
    body.addSubSection("Info", addExplanationSectionBody);
  }

  /// Adds a set of [LearningGoal] to the doc.
  void addLearningGoalList(
      List<LearningGoal> list,
      String Function(Exercise exercise) exerciseStringExtractor,
      bool increaseExerciseIndex) {
    body.addEnvironment(
        environment: "enumerate",
        builder: () {
          for (var learningGoal in list) {
            Exercise? exercise = learningGoal.randomExercise();

            if (exercise == null) {
              body.addItem(
                  "\\textbf{${learningGoal.title}}\\\\ ${learningGoal.description}");
            } else {
              body.addItem(
                  "\\textbf{${learningGoal.title}}\\\\ ${exerciseStringExtractor(exercise)}");
            }
          }
        });
  }

  void addTreeVisualSection() {
    body.addSection(learningTree.title, addTreeVisualSectionBody);
  }

  /// Prints "Schlüssellernziele" and adds a section for the topic of [TestProcedureReportByLearningTreeLatex].
  void addTopicSection() {
    body.addSection("Dein Lernfortschritt", addTopicBody);
  }
}
