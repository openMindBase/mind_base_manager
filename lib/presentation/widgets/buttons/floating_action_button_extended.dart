// @author Matthias Weigt 23.03.23

import 'package:flutter/material.dart';
import 'package:knowledge_dependency_graph_manager/domain/entities/random/random_generators.dart';

class MBFloatingActionButtonExtended extends StatelessWidget {
  const MBFloatingActionButtonExtended({super.key, this.onPressed, required this.iconData, required this.title, this.iconColor, this.heroTag});

  final VoidCallback? onPressed;
  final IconData iconData;
  final String title;
  final Color? iconColor;
  final Object? heroTag;
  @override
  Widget build(BuildContext context) {
    return FloatingActionButton.extended(
      elevation: 4,
      isExtended: true,
      backgroundColor: onPressed == null ? Colors.grey : null,
      onPressed: onPressed,
      heroTag: heroTag ?? RandomHashGenerator().get(),
      label: Text(title),
      icon: Icon(
        iconData,
        color: iconColor,
      ),
    );
  }
}
