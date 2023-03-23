// @author Matthias Weigt 22.03.23

import 'package:flutter/material.dart';
import 'package:mind_base_manager/domain/use_cases/learning_goal_collection.dart';
import 'package:mind_base_manager/presentation/app_pages/app_page.dart';
import 'package:mind_base_manager/presentation/widgets/buttons/tag_selection_button.dart';

class TagSelectionPage extends StatefulWidget {
  const TagSelectionPage({super.key, required this.learningGoalCollection, required this.onTagPressed});

  /// The [LearningGoalCollection] to extract the tags from.
  final LearningGoalCollection learningGoalCollection;


  /// Executed, when clicked on a tag.
  final void Function(String string) onTagPressed;


  @override
  State<TagSelectionPage> createState() => _TagSelectionPageState();
}

class _TagSelectionPageState extends State<TagSelectionPage> {

  final List<String> tags = [];


  @override
  void initState() {
    tags.addAll(widget.learningGoalCollection.tags());
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    List<Widget> children = [];
    for(var tag in tags) {
      children.add(TagSelectionButton(tag: tag, onPressed: widget.onTagPressed));
    }
    return AppPage(title: "tag - selection", children: children);
  }
}
