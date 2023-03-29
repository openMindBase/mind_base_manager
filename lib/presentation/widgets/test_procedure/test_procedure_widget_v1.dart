// @author Matthias Weigt 15.02.23
// All rights reserved ©2023

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:lean_ui_kit/other/lean_navigator.dart';
import 'package:lean_ui_kit/presentation/widgets/lean_space.dart';
import 'package:lean_ui_kit/presentation/widgets/lean_spaced_column.dart';
import 'package:lean_ui_kit/presentation/widgets/lean_spaced_row.dart';
import '../../../database/mind_base.dart';
import '../../../domain/entities/learning_goals_and_structures/learning_goal.dart';
import '../../../domain/entities/learning_goals_and_structures/learning_tree.dart';
import '../../../domain/entities/persons/student_metadata.dart';
import '../../../domain/use_cases/test_procedure_report/test_procedure_report_by_learning_tree_latex_v1.dart';
import '../../../domain/use_cases/test_procedures/test_procedure.dart';
import '../../../domain/use_cases/tree_construction/tree_builder.dart';
import '../../app_pages/test_procedure_page.dart';
import '../../old_widgets/learning_tree_visual.dart';
import '../assessments/assessment_view.dart';
import '../buttons/test_procedure_controller_button.dart';
import '../learning_goal_displays/learning_goal_display_v1.dart';

class TestProcedureWidgetV1 extends StatefulWidget {
  const TestProcedureWidgetV1(
      {super.key,
      required this.testProcedure,
      required this.onTestingComplete,
      required this.studentMetadata});

  final TestProcedure testProcedure;
  final TestedLearningTreeCallback onTestingComplete;
  final StudentMetadata studentMetadata;

  @override
  _TestProcedureWidgetV1State createState() => _TestProcedureWidgetV1State();
}

class _TestProcedureWidgetV1State extends State<TestProcedureWidgetV1> {
  @override
  void initState() {
    super.initState();
  }

  bool showFront = true;
  bool testingActive = true;

  @override
  Widget build(BuildContext context) {
    if (!widget.testProcedure.testingActive && testingActive) {
      testingActive = false;
      widget.onTestingComplete(widget.testProcedure.learningTree);
      _createAnalysis();
      _saveTestedTreeState();
      // DatabaseAccess().writeExerciseIndexList(studentId, exerciseIndexList)
    }

    if (!testingActive) {
      return LayoutBuilder(builder: (context, constraints) {
        return AssessmentViewWidget(
            studentMetadata: widget.studentMetadata,
            currentlyActive: widget.testProcedure.currentLearningGoal,
            learningTree: widget.testProcedure.learningTree);
      });
    }

    return LayoutBuilder(builder: (context, constraints) {
      return LeanSpacedColumn(
        children: [
          _learningTreeVisualWidget(constraints.maxWidth * 0.9,
              MediaQuery.of(context).size.height * 0.6),
          Text(
            widget.testProcedure.currentLearningGoal.title,
            style: Theme.of(context).textTheme.headlineMedium,
          ),
          _learningGoalDisplay(constraints.maxWidth * 0.9,
              MediaQuery.of(context).size.height * 0.4),
          _buttonRow(),
          const LeanDY(y: 50)
        ],
      );
    });
  }

  Widget _learningTreeVisualWidget(double width, double height) {
    return LearningTreeVisualWidget(
      currentlyTesting: widget.testProcedure.currentLearningGoal,
      width: width,
      height: height,
      learningTree: widget.testProcedure.learningTree,
      learningGoalCallback: (l) {
        widget.testProcedure.setCurrentLearningGoal(l);
        setState(() {});
      },
    );
  }

  Widget _learningGoalDisplay(double width, double height) {
    return LearningGoalDisplayV1(
      height: height,
      learningGoal: widget.testProcedure.currentLearningGoal,
      width: width,
    );
  }

  void _saveTestedTreeState(){
    MindBase.instance.writeTestedTree(
        widget.testProcedure.learningTree,widget.studentMetadata
    );
  }

  void _createAnalysis() {
    var t = TestProcedureReportByLearningTreeLatexV1(
        name: widget.studentMetadata.name ?? "",
        widget.testProcedure.learningTree);

    Clipboard.setData(ClipboardData(
        text:
        "${widget.testProcedure.learningTree.title.replaceAll(":", " ")}||||${widget.studentMetadata.name ?? "Max Muster"}||||${t.get()}")
    );
  }

  Widget _buttonRow() {
    return LeanSpacedRow(spaceDx: 20, children: [
      TestProcedureControllerButton(
        onPressed: () {
          showFront = true;
          widget.testProcedure.submitCurrentLearningGoal(1);
          setState(() {});
        },
        iconData: Icons.check,
        title: 'gekonnt',
        iconColor: Colors.green,
      ),
      TestProcedureControllerButton(
          onPressed: () {
            showFront = true;
            widget.testProcedure.submitCurrentLearningGoal(0.5);
            setState(() {});
          },
          iconData: Icons.pending_actions,
          title: 'üben',
          iconColor: const Color.fromARGB(255, 255, 193, 61)),
      TestProcedureControllerButton(
        onPressed: () {
          showFront = true;
          widget.testProcedure.submitCurrentLearningGoal(0);
          setState(() {});
        },
        iconData: Icons.close,
        title: 'nicht gekonnt',
        iconColor: Colors.red,
      ),
      TestProcedureControllerButton(
        onPressed: () => _onNotRelevant(context),
        iconData: Icons.not_interested,
        title: 'nicht relevant',
        iconColor: Colors.grey,
      ),
    ]);
  }


  void _onNotRelevant(BuildContext context) {
    setState(() {
      LeanNavigator.pop(context);
      LeanNavigator.push(
          context,
          Scaffold(
            body: TestProcedurePage(
              studentMetadata: widget.studentMetadata,
              learningTree:_removeCurrentLearningGoal(),
              title: widget.testProcedure.learningTree.title,
              onTestingComplete: (learningTree) {
                // DatabaseAccess().addAssessmentToStudent(
                //     widget.studentMetadata.id, learningTree);
              },
            ),
          ));
    });
  }

  LearningTree _removeCurrentLearningGoal() {
    TreeBuilder treeBuilder =
    TreeBuilder.byTree(learningTree: widget.testProcedure.learningTree);
    treeBuilder.removeGoal(
        learningGoal: widget.testProcedure.currentLearningGoal);
    treeBuilder.sort(10000);
    return treeBuilder.get();
  }
}
