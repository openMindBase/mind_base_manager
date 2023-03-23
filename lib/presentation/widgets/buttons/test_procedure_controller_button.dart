// @author Matthias Weigt 23.03.23

import 'package:flutter/material.dart';
import 'package:mind_base_manager/presentation/widgets/buttons/floating_action_button_extended.dart';

class TestProcedureControllerButton extends StatelessWidget {
  const TestProcedureControllerButton(
      {super.key,
      required this.onPressed,
      required this.iconData,
      required this.title,
      this.iconColor,
      this.heroTag});

  final VoidCallback? onPressed;
  final IconData iconData;
  final String title;
  final Color? iconColor;
  final Object? heroTag;

  @override
  Widget build(BuildContext context) {
    return MBFloatingActionButtonExtended(
      iconData: iconData,
      title: title,
      heroTag: heroTag,
      iconColor: iconColor,
      onPressed: onPressed,
      key: key,
    );
  }
}
