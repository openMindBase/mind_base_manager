// @author Matthias Weigt 14.02.23

import 'package:flutter/material.dart';
import 'package:lean_ui_kit/other/lean_navigator.dart';
import 'package:lean_ui_kit/presentation/widgets/lean_space.dart';
import 'package:lean_ui_kit/presentation/widgets/lean_spaced_column.dart';

class AppPage extends StatelessWidget {
  const AppPage(
      {super.key,
        required this.title,
        required this.children,
        this.showFeedbackButton = true,
        this.showBackButton = false});

  final String title;
  final bool showBackButton;
  final List<Widget> children;
  final bool showFeedbackButton;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: double.infinity,
      height: double.infinity,
      child: SingleChildScrollView(
        child: LeanSpacedColumn(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              const LeanDY(y: 50),
              Row(
                children: [
                  if (showBackButton)
                    Padding(
                      padding: const EdgeInsets.only(left: 20),
                      child: FloatingActionButton(
                        heroTag: const SizedBox(),
                        onPressed: () => LeanNavigator.pop(context),
                        child: const Icon(Icons.arrow_back),
                      ),
                    ),
                  Expanded(
                    child: Text(
                      title,
                      style: Theme.of(context).textTheme.displayMedium,
                      textAlign: TextAlign.center,
                    ),
                  ),
                ],
              ),
              const Divider(),
              ...children
            ]),
      ),
    );
  }
}
