// @author Matthias Weigt 27.07.2022
// All rights reserved ©2022
import 'package:mind_base_manager/domain/use_cases/test_procedure_report/test_procedure_report_by_learning_tree_latex.dart';

/// This class represents a [TestProcedureReportByLearningTree] in latex.
class TestProcedureReportByLearningTreeLatexV1
    extends TestProcedureReportByLearningTreeLatex {
  TestProcedureReportByLearningTreeLatexV1(super.learningTree, {super.name});

  @override
  void addTitle(String name) {
    body.addTitle(
        "Deine persönliche Analyse\\\\$name\\\\${learningTree.title}");
    body.addEnvironment(
      environment: "center",
      builder: () {
        body.add("Geschafft! :)");
      },
    );
    body.addLinebreak();
    body.addEnvironment(
      environment: "center",
      builder: () {
        body.add(
            "Anbei findest du eine Aufschlüsselung deines persönlichen Kenntnisstands und deine Schlüssellernziele.");
      },
    );
    body.add("\\\\");
    body.add("\\\\");
    body.addCenterEnvironment(
      builder: () {
        body.addCommandWithCurl(command: "textbf", curlTxt: "Kontakt");
      },
    );
    body.add("\\\\");
    body.addCenterEnvironment(
      builder: () {
        body.addLineString("www.lernzweige.de");
      },
    );
    body.add("\\\\");
    body.addCenterEnvironment(
      builder: () {
        body.addLineString("kontakt@lernzweige.de");
      },
    );
    body.add("\\\\");
    body.addCenterEnvironment(
      builder: () {
        body.addLineString("+49 157 3573 6411");
      },
    );

    body.add("\\\\");
    body.addBackSlashCommand("newpage");
    body.addLinebreak();
  }

  @override
  void addKeyLearningGoalSectionBody() {
    // body.addLineString(
    //     "Diese Lernziele kannst du noch nicht, aber du kannst bereits alle vorausgesetzten Lernziele.");
    // body.addLineString(
    //     "Lerne diese Lernziele, um im Baum weiter zu kommen. :D");

    // List<LearningGoal> keyLearningGoalList = keyLearningGoals.toList().sort();
    addLearningGoalList(learningTree.sortedKeyLearningGoals,
        (exercise) => "Aufgabe: \\\\${exercise.question}", false);
  }

  @override
  void addTopicBody() {
    const int maxBarWidth = 16;
    const double barHeightDouble = 0.3;
    final String barHeight = barHeightDouble.toString();
    const double widthShowPercent = 1;
    final int totalCount = learningTree.learningGoals.length;
    final int countGreen = learningTree.controlledGoals.length;
    final int countYellow = learningTree.shouldBeImprovedGoal.length;
    final int countOrange = learningTree.keyLearningGoals.length;
    final int countRed = totalCount-countGreen-countYellow-countOrange;

    final String formattedPercentGreen = (countGreen/totalCount*100).round().toString() + "\\%";
    final String formattedPercentYellow = (countYellow/totalCount*100).round().toString() + "\\%";
    final String formattedPercentOrange = (countOrange/totalCount*100).round().toString() + "\\%";
    final String formattedPercentRed = (countRed/totalCount*100).round().toString() + "\\%";



    final double sizeGreen = maxBarWidth*(countGreen/totalCount);
    final double sizeYellow = maxBarWidth*(countYellow/totalCount);
    final double sizeOrange = maxBarWidth*(countOrange/totalCount);
    final double sizeRed = maxBarWidth*(countRed/totalCount);



    body.addTikzpictureEnvironment(builder: () {
      body.addTikRect(texTextColor: "grey", minWidth: sizeGreen.toString(), minHeight: barHeight, yOffset: 0,xOffset: 0, text: sizeGreen>widthShowPercent?formattedPercentGreen:"", texFillColor: "green");
    });
    body.addTikzpictureEnvironment(builder: () {
      body.addTikRect(
          texTextColor: "grey",
          minWidth: sizeYellow.toString(),
          minHeight: barHeight,
          yOffset: 0,
          xOffset: 0,
          text: sizeYellow > widthShowPercent ? formattedPercentYellow : "",
          texFillColor: "yellow");
    });
    body.addTikzpictureEnvironment(builder: () {
      body.addTikRect(
          texTextColor: "white",
          minWidth: sizeOrange.toString(),
          minHeight: barHeight,
          yOffset: 0,
          xOffset: 0,
          text: sizeOrange > widthShowPercent ? formattedPercentOrange : "",
          texFillColor: "orange");
    });
    body.addTikzpictureEnvironment(builder: () {
      body.addTikRect(
          texTextColor: "white",
          minWidth: sizeRed.toString(),
          minHeight: barHeight,
          yOffset: 0,
          xOffset: 0,
          text: sizeRed > widthShowPercent ? formattedPercentRed : "",
          texFillColor: "red");
    });
    body.add("\\\\");
    body.addLinebreak();
    body.addSubSection("Typen von Lernzielen", () {
      body.addEnvironment(
          environment: "itemize",
          builder: () {
            body.addItem("\\textbf{Grün}: Lernziele, die du schon beherrscht.");
            body.addItem(
                "\\textbf{Gelb (Vertiefungslernziele)}: Lernziele, die du zwar kannst, aber noch nicht sicher beherrschst. Übe sie noch etwas, um sie souverän lösen zu können. :)");
            body.addItem(
                "\\textbf{Orange (Schlüssellernziele)}: Deine sogenannten Schlüssellernziele sind die Lernziele, die du zwar noch nicht kannst, für die du aber alle nötigen Vorkenntnisse besitzt. Also genau die Aufgabentypen, die du als nächstes lernen kannst. :D");
            body.addItem(
                "\\textbf{Rot}: Lernziele, die du noch nicht lernen kannst, weil du noch nicht alle nötigen Vorkenntnisse besitzt.");
          });
    });

    body.add("\\newpage");
    body.addLinebreak();
  }

  @override
  void addTreeVisualSectionBody() {
    body.addLineString("\\includegraphics[width=\\textwidth,height=\\textheight,keepaspectratio]{recent_tree}");
  }

  @override
  void addLearningGoalsToImproveSectionBody() {
    // body.addLineString(
    //     "Diese Lernziele solltest du noch etwas üben, sie sollten aber nicht allzu schwer sein. :)");
    addLearningGoalList(learningTree.sortedImprovementGoals,
        (exercise) => "Aufgabe: \\\\${exercise.question}", false);
  }

  @override
  void addExplanationSectionBody() {}

  @override
  void addKeyLearningGoalSolutionBody() {
    addLearningGoalList(learningTree.sortedKeyLearningGoals,
        (exercise) => exercise.answer, true);
  }

  @override
  void addImprovementGoalsSolutionBody() {
    addLearningGoalList(learningTree.sortedImprovementGoals,
        (exercise) => exercise.answer, true);
  }
}
