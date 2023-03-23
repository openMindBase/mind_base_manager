// @author Matthias Weigt 23.03.23

import 'package:flutter/material.dart';
import 'package:mind_base_manager/presentation/app_pages/tag_selection_page.dart';


/// Used in [TagSelectionPage].
class TagSelectionButton extends StatelessWidget {
  const TagSelectionButton({super.key, required this.tag, required this.onPressed});
  /// The name of the tag.
  final String tag;
  final void Function(String tag) onPressed;

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(onPressed: () => onPressed(tag), child: Text("#$tag"));
  }
}
