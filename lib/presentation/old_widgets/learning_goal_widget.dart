// @author Matthias Weigt 27.07.2022
// All rights reserved ©2022
import 'package:flutter/material.dart';


import '../../../../domain/entities/math/tuple.dart';
import '../../domain/entities/learning_goals_and_structures/learning_goal.dart';
import 'learning_goal_button.dart';
import 'learning_tree_visual_theme.dart';

class LearningGoalWidget extends _LearningGoalWidget {
  const LearningGoalWidget(
      {super.key,
      this.index,
      this.showExerciseCount,
      required super.coordinates,
      required super.learningGoal,
      this.isKeyLearningGoal = false,
      this.currentlyTesting = false,
      this.styleOverride,
      this.learningGoalCallback,
      required this.highlightSubtree,
      this.size = 35,
      required this.isDependentFromCurrent});

  final bool isKeyLearningGoal;
  final bool currentlyTesting;
  final LearningGoalCallback? learningGoalCallback;
  final LearningTreeVisualTheme? styleOverride;
  final bool? showExerciseCount;
  final bool highlightSubtree;
  final bool isDependentFromCurrent;
  final double size;
  final int? index;

  bool get isImprovementGoal => learningGoal.shouldBeImproved();

  @override
  Widget buildChild(BuildContext context) {
    VoidCallback onPressed = () {
      if (learningGoalCallback != null) {
        learningGoalCallback!(learningGoal);
      }
    };

    if (showExerciseCount ?? false) {
      return IconButton(
        constraints: BoxConstraints(maxHeight: size, maxWidth: size),
        iconSize: size / 2,
        onPressed: onPressed,
        tooltip: learningGoal.title,
        icon: Text(
            style: currentlyTesting
                ? const TextStyle(color: Colors.black)
                : TextStyle(
              //todo 21.03.23 16:15 von @Matthias: .
                    // color: MyApp.of(context).darkMode
                    color: true
                        ? Colors.white
                        : Colors.white),
            learningGoal.shouldTest
                ? learningGoal.exercises.length.toString()
                : "x"),
        style: IconButton.styleFrom(
            backgroundColor: style.backgroundColor,
            foregroundColor: style.iconColor),
      );
    }

    if ((isKeyLearningGoal || isImprovementGoal) && index != null) {
      return Row(
        children: [
          IconButton(
            constraints: BoxConstraints(maxHeight: size, maxWidth: size),
            iconSize: size / 2,
            onPressed: onPressed,
            tooltip: learningGoal.title,
            icon: Icon(style.iconData),
            style: IconButton.styleFrom(
                backgroundColor: style.backgroundColor,
                foregroundColor: style.iconColor),
          ),
          const SizedBox(
            width: 5,
          ),
          Text(
            "$index*",
            style: const TextStyle(
              fontSize: 15,
              color: Colors.black,
            ),
          )
        ],
      );
    }
  // print(style.backgroundColor);
    return IconButton(
      constraints: BoxConstraints(maxHeight: size, maxWidth: size),
      iconSize: size / 2,
      onPressed: onPressed,
      tooltip: learningGoal.title,
      icon: Icon(style.iconData),
      style: IconButton.styleFrom(
          backgroundColor: style.backgroundColor,
          foregroundColor: style.iconColor),
    );
  }

  LearningGoalWidgetTheme _extractStyle(LearningTreeVisualTheme input) {
    if (highlightSubtree && isDependentFromCurrent) {
      return input.controlled;
    }
    if (highlightSubtree) {
      if (currentlyTesting) {
        return input.currentlyActive;
      }
    }

    if (!learningGoal.isAlreadyTested()) {
      if (currentlyTesting) {
        return input.currentlyActive;
      }
      return input.unTested;
    }
    if (learningGoal.shouldBeImproved()) {
      return input.shouldImprove;
    }
    if (learningGoal.isControlled()) {
      return input.controlled;
    }
    if (isKeyLearningGoal) {
      return input.keyLearningGoal;
    }
    return input.unControlled;
  }

  LearningGoalWidgetTheme get style {
    if (styleOverride == null) {
      return _extractStyle(LearningTreeVisualTheme.defaultStyle);
    }
    return _extractStyle(styleOverride as LearningTreeVisualTheme);
  }
}

abstract class _LearningGoalWidget extends StatelessWidget {
  const _LearningGoalWidget(
      {super.key, required this.coordinates, required this.learningGoal});

  final Tuple<double> coordinates;
  final LearningGoal learningGoal;

  @override
  Widget build(BuildContext context) {
    return Positioned(
      child: buildChild(context),
      left: coordinates.x1 - xOffset,
      bottom: coordinates.x2 - yOffset,
    );
  }

  double get xOffset => 17;

  double get yOffset => 16;

  Widget buildChild(BuildContext context);
}
