// @author Matthias Weigt 22.03.23

import 'package:flutter/material.dart';
import 'package:mind_base_manager/domain/use_cases/learning_goal_collection.dart';
import 'package:mind_base_manager/presentation/app_pages/app_page.dart';
import 'package:mind_base_manager/presentation/widgets/buttons/tag_selection_button.dart';

class TagSelectionPage extends StatefulWidget {
  const TagSelectionPage(
      {super.key,
      required this.learningGoalCollection,
      required this.onTagPressed});

  /// The [LearningGoalCollection] to extract the tags from.
  final LearningGoalCollection learningGoalCollection;

  /// Executed, when clicked on a tag.
  /// [collection] is the already by [tag] filtered [LearningGoalCollection].
  final void Function(String tag, LearningGoalCollection collection)
      onTagPressed;

  @override
  State<TagSelectionPage> createState() => _TagSelectionPageState();
}

class _TagSelectionPageState extends State<TagSelectionPage> {
  final List<String> tags = [];

  @override
  void initState() {
    tags.addAll(widget.learningGoalCollection.tags());
    tags.removeWhere((element) => element.contains("root"));
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    List<Widget> children = [];
    for (var tag in tags) {
      LearningGoalCollection collection =
          widget.learningGoalCollection.filterByTag(tag);

      children.add(TagSelectionButton(
        learningGoalCollection: collection,
        tag: tag,
        onPressed: (tag) {
          widget.onTagPressed(tag, collection);
        },
      ));
    }
    return AppPage(showBackButton: true, title: "tag - selection", children: [
      Wrap(
        children: children,
      )
    ]);
  }
}
