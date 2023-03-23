// @author Matthias Weigt 15.02.23
// All rights reserved ©2023

import 'package:flutter/material.dart';

class MBAppCardButton extends StatelessWidget {
  const MBAppCardButton(
      {super.key,
      required this.onPressed,
      this.size = 200,
      this.sizeXMultiplikator = 1,
      this.sizeYMultiplikator = 1,
      this.padding = 10,
      required this.child, this.elevation});

  final VoidCallback? onPressed;

  final double size;

  final double sizeXMultiplikator;
  final double sizeYMultiplikator;

  final double padding;

  final Widget child;
  final double? elevation;
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.all(padding),
      child: Card(
        elevation: elevation??4,
        child: InkWell(
          onTap: onPressed,
          child: Container(
              width: size * sizeXMultiplikator,
              height: size * sizeYMultiplikator,
              padding: EdgeInsets.all(padding),
              child: child),
        ),
      ),
    );
  }
}
