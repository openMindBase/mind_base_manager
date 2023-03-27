// @author Matthias Weigt 15.02.23
// All rights reserved ©2023

import 'package:flutter/material.dart';
import 'package:lean_ui_kit/other/lean_navigator.dart';
import 'package:lean_ui_kit/presentation/widgets/lean_spaced_column.dart';
import 'package:mind_base_manager/domain/entities/learning_goals_and_structures/learning_goal.dart';

import '../../../domain/entities/exercise.dart';
import '../../../domain/entities/learning_goals_and_structures/learning_tree.dart';
import '../../../domain/entities/persons/student_metadata.dart';
import '../../app_pages/test_procedure_page.dart';
import '../../old_widgets/learning_tree_visual.dart';
import '../../old_widgets/learning_tree_visual_theme.dart';
import '../buttons/app_card_menu_button.dart';
import '../buttons/floating_action_button_extended.dart';
import '../text/mark_down.dart';

class AssessmentViewWidget extends StatefulWidget {
  const AssessmentViewWidget(
      {super.key,
      required this.learningTree,
      this.currentlyActive,
      required this.studentMetadata});

  final LearningTree learningTree;
  final StudentMetadata studentMetadata;
  final LearningGoal? currentlyActive;

  @override
  _AssessmentViewWidgetState createState() => _AssessmentViewWidgetState();
}

class _AssessmentViewWidgetState extends State<AssessmentViewWidget> {
  late LearningGoal currentlyActive;

  @override
  void initState() {
    currentlyActive = widget.currentlyActive ?? widget.learningTree.trunkGoal;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        return LeanSpacedColumn(children: [
          _learningTreeVisualWidget(constraints.maxWidth * 0.9,
              MediaQuery.of(context).size.height * 0.6),
          MBFloatingActionButtonExtended(
              onPressed: () {
                widget.learningTree.resetControlLevelIf(
                    (learningGoal) => learningGoal.isControlled() == false);
                //TODO: not great continue button functionality
                if (Navigator.canPop(context)) {
                  LeanNavigator.pop(context);
                }
                if (Navigator.canPop(context)) {
                  LeanNavigator.pop(context);
                }
                LeanNavigator.push(
                    context,
                    Scaffold(
                      body: TestProcedurePage(
                          learningTree: widget.learningTree,
                          title: widget.learningTree.title,
                          onTestingComplete: (learningTree) {
                            // DatabaseAccess().addAssessmentToStudent(
                            //     widget.studentMetadata.id, learningTree);
                          },
                          studentMetadata: widget.studentMetadata),
                    ));
              },
              iconData: Icons.school,
              title: "Einschätzung fortfahren"),
          Wrap(
            children: [
              MBAppCardMenuButton(
                  tooltipMessage: "Diese Lernziele werden schon gut gekonnt.",
                  onPressed: () {},
                  iconData:
                      LearningTreeVisualTheme.defaultStyle.controlled.iconData,
                  text:
                      "${(learningTree.computePercentageControlled() * 100).round()} %",
                  iconColor: Colors.green),
              MBAppCardMenuButton(
                  tooltipMessage:
                      "Diese Lernziele sollten nochmal geübt werden.",
                  onPressed: () {},
                  iconData: LearningTreeVisualTheme
                      .defaultStyle.shouldImprove.iconData,
                  text:
                      "${(learningTree.computePercentageShouldBeImproved() * 100).round()} %",
                  iconColor: const Color.fromARGB(255, 255, 193, 61)),
              MBAppCardMenuButton(
                  tooltipMessage:
                      "Diese Lernziele werden noch nicht gekonnt, es sind aber alle Voraussetzungen für sie erfüllt.",
                  onPressed: () {},
                  iconData: LearningTreeVisualTheme
                      .defaultStyle.keyLearningGoal.iconData,
                  text:
                      "${(learningTree.computePercentageKeyLearningGoal() * 100).round()} %",
                  iconColor: Colors.orange),
              MBAppCardMenuButton(
                  tooltipMessage:
                      "Diese Lernziele sind leider noch zu schwierig.",
                  onPressed: () {},
                  iconData: LearningTreeVisualTheme
                      .defaultStyle.unControlled.iconData,
                  text:
                      "${(learningTree.computePercentageUncontrolled() * 100).round()} %",
                  iconColor: Colors.red),
              // if (widget.assessmentData != null)
              //   KNKAppCardMenuButton(
              //       tooltipMessage:
              //           "Datum: ${widget.assessmentData!.dateTime.day}.${widget.assessmentData!.dateTime.month}.${widget.assessmentData!.dateTime.year}",
              //       onPressed: () {},
              //       iconData: Icons.calendar_month,
              //       text: widget.assessmentData!.daysAgoString)
            ],
          ),
          Text(
            "Schlüssellernziele: (${learningTree.keyLearningGoals.length})",
            style: Theme.of(context).textTheme.headlineLarge,
          ),
          Card(
            child: Container(
              padding: const EdgeInsets.all(20),
              width: constraints.maxWidth * 0.9,
              child: Markdown(
                  left: true,
                  texData: _getKeyLearningGoalTex(learningTree),
                  height: learningTree.keyLearningGoals.length * 300),
            ),
          )
        ]);
      },
    );
  }

  String _getKeyLearningGoalTex(LearningTree learningTree) {
    String output = "";

    for (var v in learningTree.filter(
        (learningGoal) => learningTree.isKeyLearningGoal(learningGoal))) {
      output += v.title;
      output += "<br>";
      if (v.randomExercise() != null) {
        Exercise e = v.randomExercise() as Exercise;
        output += e.question;
      } else {
        output += v.description ?? "";
      }
      output += "<br>";
      output += "<br>";
      output += "<br>";
      output += "<br>";
    }

    return output;
  }

  Widget _learningTreeVisualWidget(double width, double height) {
    return LearningTreeVisualWidget(
      white: true,
      currentlyTesting: currentlyActive,
      width: width,
      height: height,
      learningTree: widget.learningTree,
      learningGoalCallback: (l) {
        currentlyActive = l;
        setState(() {});
      },
    );
  }

  LearningTree get learningTree => widget.learningTree;
}
