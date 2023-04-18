// @author Matthias Weigt 23.03.23

import 'package:flutter/material.dart';
import 'package:mind_base_manager/domain/use_cases/learning_goal_collection.dart';
import 'package:mind_base_manager/presentation/app_pages/tag_selection_page.dart';

/// Used in [TagSelectionPage].
class TagSelectionButton extends StatelessWidget {
  const TagSelectionButton(
      {super.key,
      required this.tag,
      required this.onPressed,
      required this.learningGoalCollection});

  /// The name of the tag.
  final String tag;
  final void Function(String tag) onPressed;

  final LearningGoalCollection learningGoalCollection;

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
        onPressed: () => onPressed(tag),
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Column(
            children: [
              Text("#$tag"),
              const SizedBox(
                height: 10,
              ),
              SizedBox(
                width: _Bar.widthBar,
                child: Row(
                  children: [
                    _Bar(
                        percent: learningGoalCollection.percentControlled,
                        color: Colors.green,
                        text:
                            learningGoalCollection.countControlled.toString()),
                    _Bar(
                        percent:
                            learningGoalCollection.percentMaybeNotControlled,
                        color: Colors.limeAccent,
                        text: learningGoalCollection.countMaybeNotControlled
                            .toString()),
                    _Bar(
                        percent: learningGoalCollection.percentNeverControlled,
                        color: Colors.red,
                        text: learningGoalCollection.countNeverControlled
                            .toString()),
                  ],
                ),
              )
            ],
          ),
        ));
  }
}

class _Bar extends StatelessWidget {
  static const double widthBar = 200;

  const _Bar(
      {super.key,
      required this.percent,
      required this.color,
      required this.text});

  final double percent;
  final Color color;
  final String text;

  @override
  Widget build(BuildContext context) {
    return Tooltip(
      message: text,
      child: Container(width: percent * widthBar, height: 7.5, color: color),
    );
  }
}
