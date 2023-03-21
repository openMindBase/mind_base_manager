// @author Matthias Weigt 27.07.2022
// All rights reserved ©2022
import 'package:flutter/material.dart';
import 'learning_goal_widget.dart';
import 'learning_tree_visual_theme.dart';
import 'learning_goal_button.dart';
import 'package:lean_ui_kit/presentation/widgets/lean_container.dart';

import '../../../domain/entities/math/tuple.dart';
import '../../domain/entities/learning_goals_and_structures/learning_goal.dart';
import '../../domain/entities/learning_goals_and_structures/learning_tree.dart';
import '../../domain/entities/learning_goals_and_structures/learning_tree_coordinates_generator.dart';
import 'line.dart';

class LearningTreeVisualWidget extends StatelessWidget {
  LearningTreeVisualWidget(
      {super.key,
      required this.width,
      required this.height,
      required this.learningTree,
      this.currentlyTesting,
      this.style,
      this.backGround = false,
      this.learningGoalCallback,
      this.showExerciseCounts,
      this.highlightSubtree = false,
      this.white = false})
      : coordinates = LearningTreeCoordinatesGenerator(
                radius: learningTree == null
                    ? 65
                    : height ~/ (learningTree.maxGrade + 2),
                learningTree?.signature(),
                xOffset: width / 2,
                yOffset: 40)
            .getCartesian();

  final double width;
  final double height;
  final LearningTree? learningTree;
  final Map<String, Tuple<double>> coordinates;
  final LearningGoal? currentlyTesting;
  final LearningTreeVisualTheme? style;
  final bool backGround;
  final LearningGoalCallback? learningGoalCallback;
  final bool? showExerciseCounts;
  final bool white;

  /// Tells of the [LearningGoal]s dependent of [currentlyTesting] should be highlighted.
  final bool highlightSubtree;

  @override
  Widget build(BuildContext context) {
    BoxDecoration? boxDecoration;
    if (!backGround) {
      boxDecoration = const BoxDecoration();
    }
    if (white) {
      return Container(
        width: width,
        height: height,
        color: Colors.white,
        child: Stack(
          children: children(context),
        ),
      );
    }

    return LeanContainer(
      width: width,
      height: height,
      boxDecoration: boxDecoration,
      child: Stack(
        children: children(context),
      ),
    );
  }

  List<Widget> children(BuildContext context) {
    List<Widget> output = [];
    if (learningTree == null) {
      return output;
    }
    _addLines(output);

    _addGoals(output);

    return output;
  }

  void _addLines(List<Widget> output) {
    for (var e in learningTree!.signature().edges) {
      var fromT = coordinates[e.x1];
      Offset from = Offset(fromT!.x1, fromT.x2);
      var toT = coordinates[e.x2];
      Offset to = Offset(toT!.x1, toT.x2);
      output.add(_VisualEdge(
        highlightSubtree: highlightSubtree,
        isDependentFromCurrent: isDependentFromCurrent(
            learningTree!.getNodeById(e.x1),
            isEdge: true),
        from: to,
        to: from,
        learningGoal: learningTree!.getNodeById(e.x2),
        style: style,
        isKeyLearningGoal: learningTree!.untestedLearningGoals.isEmpty
            ? learningTree!.isKeyLearningGoal(learningTree!.getNodeById(e.x2))
            : false,
      ));
    }
  }

  void _addGoals(List<Widget> output) {
    for (var list in learningTree!.signature().learningGoalsByGrade.values) {
      for (var learningGoal in list) {
        output.add(LearningGoalWidget(
          index: white
              ? ((learningTree!.untestedLearningGoals.isEmpty
                      ? learningTree!.isKeyLearningGoal(learningGoal)
                      : false)
                  ? learningTree!.keyLearningGoalIndex(learningGoal)
                  : learningTree!.improvementLearningGoalIndex(learningGoal))
              : null,
          showExerciseCount: showExerciseCounts,
          coordinates: coordinates[learningGoal.id]!,
          learningGoal: learningGoal,
          styleOverride: style,
          currentlyTesting: currentlyTesting == null
              ? false
              : currentlyTesting == learningGoal,
          isKeyLearningGoal: learningTree!.untestedLearningGoals.isEmpty
              ? learningTree!.isKeyLearningGoal(learningGoal)
              : false,
          learningGoalCallback: learningGoalCallback,
          highlightSubtree: highlightSubtree,
          isDependentFromCurrent: isDependentFromCurrent(learningGoal),
        ));
      }
    }
  }

  /// Checks if [learningGoal] is dependent to the [currentlyTesting].
  bool isDependentFromCurrent(LearningGoal learningGoal,
      {bool isEdge = false}) {
    if (currentlyTesting == null || learningTree == null) {
      return false;
    }

    LearningTree subTreeOfCurrentlyTesting =
        learningTree!.getTreeBySuccessors(currentlyTesting!);

    if (subTreeOfCurrentlyTesting.trunk == learningGoal.id && !isEdge) {
      return false;
    }
    return subTreeOfCurrentlyTesting.contains(learningGoal.id);
  }
}

class _VisualEdge extends StatelessWidget {
  const _VisualEdge(
      {required this.from,
      required this.to,
      required this.learningGoal,
      this.style,
      required this.isKeyLearningGoal,
      required this.highlightSubtree,
      required this.isDependentFromCurrent});

  final Offset from;
  final Offset to;
  final LearningGoal learningGoal;
  final LearningTreeVisualTheme? style;
  final bool isKeyLearningGoal;
  final bool highlightSubtree;
  final bool isDependentFromCurrent;

  @override
  Widget build(BuildContext context) {
    return LeanLine(from: from, to: to, color: _color);
  }

  LearningTreeVisualTheme get _style {
    if (style == null) {
      return LearningTreeVisualTheme.defaultStyle;
    }
    return style!;
  }

  Color get _color {
    if (learningGoal.isControlled() ||
        isDependentFromCurrent && highlightSubtree) {
      return _style.controlled.backgroundColor;
    }
    if (isKeyLearningGoal) {
      return _style.keyLearningGoal.backgroundColor;
    }
    if (learningGoal.shouldBeImproved()) {
      return _style.shouldImprove.backgroundColor;
    }
    if (learningGoal.isAlreadyTested() && !learningGoal.isControlled()) {
      return _style.unControlled.backgroundColor;
    }
    return _style.defaultLineColor;
  }
}
