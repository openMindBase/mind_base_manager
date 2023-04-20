// @author Matthias Weigt 04.04.23

import 'dart:math';

import 'package:mind_base_manager/domain/entities/learning_goals_and_structures/learning_goal.dart';

abstract class SpacedRepetitionEngine {
  static SpacedRepetitionEngine get instance =>
      _SpacedRepetitionEngineDefault();

  int daysTillTestAgain(int streak);

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

    if (timesTestedCorrectlyStreak > 100) {
      return false;
    }

    final int daysPassed =
        DateTime.now().difference(lastCorrectlyTested).inDays;
    int daysTilTestAgain = daysTillTestAgain(timesTestedCorrectlyStreak);
    if (daysPassed >= daysTilTestAgain) return true;

    return false;
  }

  @override
  int daysTillTestAgain(int streak) {
    return pow(2, streak) as int;
  }
}
