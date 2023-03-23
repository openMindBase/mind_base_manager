// @author Matthias Weigt 15.02.23
// All rights reserved ©2023

import 'package:flutter/material.dart';
import 'package:lean_ui_kit/presentation/widgets/lean_spaced_column.dart';

import '../../../domain/entities/exercise.dart';
import '../../../domain/entities/learning_goals_and_structures/learning_goal.dart';
import '../text/mark_down.dart';

class LearningGoalDisplayV1 extends StatefulWidget {
  const LearningGoalDisplayV1(
      {super.key,
      required this.learningGoal,
      required this.width,
      required this.height,
      this.showTitle = false});

  final LearningGoal? learningGoal;
  final double width;
  final double? height;
  final bool showTitle;

  @override
  _LearningGoalDisplayV1State createState() => _LearningGoalDisplayV1State();
}

class _LearningGoalDisplayV1State extends State<LearningGoalDisplayV1> {
  bool showFront = true;

  String goalId = "";

  final TextEditingController titleController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    if (widget.learningGoal != null) {
      if (goalId != widget.learningGoal!.id) {
        showFront = true;
        goalId = widget.learningGoal!.id;
      }
    }

    Widget child = Container(
      padding: const EdgeInsets.all(20),
      width: widget.width,
      height: widget.height,
      child: LeanSpacedColumn(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            if (widget.showTitle)
              widget.learningGoal != null
                  ? Text(
                      widget.learningGoal!.title,
                      style: Theme.of(context).textTheme.headlineMedium,
                    )
                  : const SizedBox(),
            widget.learningGoal != null
                ? Markdown(
                    // height: widget.height!.toInt() - 40,
                    texData: _getTex(),
                  )
                : const SizedBox()
          ]),
    );

    bool hasExercises = widget.learningGoal == null
        ? false
        : widget.learningGoal!.exercises.isEmpty
            ? false
            : true;

    return Card(
      child: hasExercises
          ? InkWell(
              onTap: () => setState(() {
                showFront = !showFront;
              }),
              child: child,
            )
          : child,
    );
  }

  String _getTex() {
    Exercise? e = widget.learningGoal!.randomExercise();
    if (e == null) {
      return "Beschreibung:\n${widget.learningGoal!.description}";
    }

    if (showFront) {
      return "Aufgabe:\n${e.question}";
    }
    return "Lösung:\n${e.answer}";
  }
}


