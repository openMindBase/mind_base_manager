// @author Matthias Weigt 15.02.23
// All rights reserved ©2023

import 'package:flutter/material.dart';
import 'package:lean_ui_kit/presentation/widgets/lean_spaced_column.dart';

import 'app_card_button.dart';

class MBAppCardMenuButton extends StatelessWidget {
  const MBAppCardMenuButton(
      {super.key,
      required this.onPressed,
      required this.iconData,
      required this.text,
      this.sizeXMultiplikator = 1,
      this.sizeYMultiplikator = 1,
      this.size = 200,
      this.iconColor,
      this.tooltipMessage});

  final VoidCallback? onPressed;
  final IconData iconData;
  final String text;
  final double size;
  final double sizeXMultiplikator;
  final double sizeYMultiplikator;
  final Color? iconColor;
  final String? tooltipMessage;

  @override
  Widget build(BuildContext context) {
    Widget button = MBAppCardButton(
        sizeXMultiplikator: sizeXMultiplikator,
        sizeYMultiplikator: sizeYMultiplikator,
        size: size,
        onPressed: onPressed,
        child: LeanSpacedColumn(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(iconData, size: 45, color: iconColor),
              Text(
                text,
                style: Theme.of(context).textTheme.headlineSmall,
                textAlign: TextAlign.center,
              )
            ]));

    if (tooltipMessage == null) {
      return button;
    }

    return Tooltip(
      message: tooltipMessage,
      waitDuration: const Duration(milliseconds: 300),
      textStyle: const TextStyle(fontSize: 20,color: Colors.white),
      child: button,
    );
  }
}
