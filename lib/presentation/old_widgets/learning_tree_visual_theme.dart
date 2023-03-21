// @author Matthias Weigt 27.07.2022
// All rights reserved ©2022
import 'package:flutter/material.dart';
import 'package:lean_ui_kit/theming/app_theme_access.dart';

abstract class LearningTreeVisualTheme {
  static final LearningTreeVisualTheme defaultStyle =
      _LearningTreeVisualThemeTestingV1();

  static final LearningTreeVisualTheme defaultConstruction =
      _LearningTreeVisualThemeConstructionV1();

  LearningGoalWidgetTheme get unTested;

  LearningGoalWidgetTheme get unControlled;

  LearningGoalWidgetTheme get controlled;

  LearningGoalWidgetTheme get keyLearningGoal;

  LearningGoalWidgetTheme get currentlyActive;

  LearningGoalWidgetTheme get shouldImprove;

  Color get defaultLineColor => AppThemeAccess.theme.primary;
}

class _LearningTreeVisualThemeTestingV1 extends LearningTreeVisualTheme {
  @override
  LearningGoalWidgetTheme get controlled => LearningGoalWidgetTheme(
      backgroundColor: Colors.green,
      iconColor: AppThemeAccess.theme.colorSet.white,
      iconData: Icons.check);

  @override
  LearningGoalWidgetTheme get keyLearningGoal => LearningGoalWidgetTheme(
      backgroundColor: Colors.orange,
      iconColor: controlled.iconColor,
      iconData: Icons.key);

  @override
  LearningGoalWidgetTheme get unControlled => LearningGoalWidgetTheme(
      backgroundColor: Colors.red,
      iconColor: controlled.iconColor,
      iconData: Icons.close);

  @override
  LearningGoalWidgetTheme get unTested => LearningGoalWidgetTheme(
      backgroundColor: AppThemeAccess.theme.primary,
      iconColor: controlled.iconColor,
      iconData: Icons.question_mark);

  @override
  LearningGoalWidgetTheme get currentlyActive => LearningGoalWidgetTheme(
      backgroundColor: controlled.iconColor,
      iconColor: AppThemeAccess.theme.primary,
      iconData: Icons.question_mark);

  @override
  LearningGoalWidgetTheme get shouldImprove => LearningGoalWidgetTheme(
      backgroundColor: const Color.fromARGB(255, 255, 193, 61),
      iconColor: controlled.iconColor,
      iconData: Icons.close);
}

class _LearningTreeVisualThemeConstructionV1 extends LearningTreeVisualTheme {
  @override
  LearningGoalWidgetTheme get controlled => unTested;

  @override
  LearningGoalWidgetTheme get keyLearningGoal => unTested;

  @override
  LearningGoalWidgetTheme get unControlled => unTested;

  @override
  LearningGoalWidgetTheme get unTested => LearningGoalWidgetTheme(
      backgroundColor: AppThemeAccess.theme.primary,
      iconColor: AppThemeAccess.theme.colorSet.white,
      iconData: Icons.star);

  @override
  LearningGoalWidgetTheme get currentlyActive => LearningGoalWidgetTheme(
      backgroundColor: AppThemeAccess.theme.colorSet.white,
      iconColor: AppThemeAccess.theme.primary,
      iconData: Icons.star);

  @override
  LearningGoalWidgetTheme get shouldImprove => unTested;
}

class LearningGoalWidgetTheme {
  LearningGoalWidgetTheme(
      {required this.backgroundColor,
      required this.iconColor,
      required this.iconData});

  final Color backgroundColor;
  final Color iconColor;
  final IconData iconData;
}
