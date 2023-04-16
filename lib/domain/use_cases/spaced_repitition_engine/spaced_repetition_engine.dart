// @author Matthias Weigt 04.04.23

import 'dart:math';

import 'package:mind_base_manager/domain/entities/learning_goals_and_structures/learning_goal.dart';

abstract class SpacedRepetitionEngine {
  static SpacedRepetitionEngine get instance =>
      _SpacedRepetitionEngineDefault();

  /// Tells if the [LearningGoal] should be tested again.
  bool shouldTestAgain(
      {required DateTime? lastCorrectlyTested,
      required int timesTestedCorrectlyStreak});
}

/// The default implementation of the [SpacedRepetitionEngine].
class _SpacedRepetitionEngineDefault extends SpacedRepetitionEngine {
  @override
  bool shouldTestAgain(
      {required DateTime? lastCorrectlyTested,
      required int timesTestedCorrectlyStreak}) {
    if (lastCorrectlyTested == null) return true;

    final int daysPassed =
        DateTime.now().difference(lastCorrectlyTested).inDays;
    int daysTilTestAgain = pow(2, timesTestedCorrectlyStreak) as int;
    if (daysPassed >= daysTilTestAgain) return true;

    return false;
  }
}
