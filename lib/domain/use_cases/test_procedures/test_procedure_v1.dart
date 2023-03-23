// Author = Matthias Weigt
// Date = 22.04.2022
// All rights reserved ©2022


import 'package:mind_base_manager/domain/use_cases/test_procedures/test_procedure.dart';


import '../../entities/learning_goals_and_structures/learning_goal.dart';
import '../../entities/learning_goals_and_structures/learning_tree.dart';

/// This [TestProcedure] always tests the [LearningGoal] in [TestProcedure.learningTree] with the highest value to be tested.
class TestProcedureV1 extends TestProcedure {
  TestProcedureV1(LearningTree learningTree, {super.startTime})
      : super(learningTree) {
    assignCurrentLearningGoal(_findBestLearningGoal());
  }

  /// The percentage of all [LearningGoal]s that are controlled.
  double controlPercentage = 0.0;

  /// The count of [LearningGoal]s that have been tested so far.
  int _testsCount = 0;

  /// Should be called when the current [LearningGoal] was tested.
  /// Returns [true] if there is another [LearningGoal] in [TestProcedure.learningTree] to test.
  /// Returns [false] at the end of the [TestProcedureV1].
  @override
  bool submitCurrentLearningGoal(double controlLevel) {
    _testsCount++;
    assignCurrentControlLevel(controlLevel);
    _updatePercentage(currentLearningGoal.isControlled());
    if (!currentLearningGoal.shouldBeImproved()) {
      markSubStructureControlLevel(
          learningGoal: currentLearningGoal,
          topDown: currentLearningGoal.isControlled());
    }

    LearningGoal? learningGoal = _findBestLearningGoal();
    assignCurrentLearningGoal(learningGoal);
    if (learningGoal == null) {
      testingActive = false;
    }
    return learningGoal != null;
  }

  /// Function to reset the [TestProcedureV1] by resetting [controlPercentage],
  /// [_testsCount] and the [LearningGoal.controlLevel] of every [LearningGoal] in [TestProcedure.learningTree].
  @override
  void reset() {
    testingActive = true;
    controlPercentage = 0;
    _testsCount = 0;
    learningTree.onEveryLearningGoal(
        (learningGoal) => learningGoal.resetControlLevel());
    assignCurrentLearningGoal(_findBestLearningGoal());
  }

  /// Finds the next untested [LearningGoal] in [TestProcedure.learningTree] that has the highest value to be tested.
  /// The Value of a [LearningGoal] is:
  /// (number of untested successors of [LearningGoal] * [controlPercentage]) + (number of untested predecessors * (1 - [controlPercentage])
  LearningGoal? _findBestLearningGoal() {
    LearningGoal? bestLearningGoal;
    double bestValue = 0;
    for (LearningGoal learningGoal in learningTree.learningGoals.toList()
      ..sort(
        (a, b) => a.id.compareTo(b.id),
      )) {
      if (learningGoal.isAlreadyTested()) {
        continue;
      }
      if (learningTree.trunk == learningGoal.id) {
        if (learningTree.untestedLearningGoals.length > 1) {
          continue;
        }
        learningGoal.assignControlLevel(controlLevel: 1);
        return null;
      }

      final int countWhenControlled = _getCountWhenControlled(learningGoal);
      final int countWhenNotControlled =
          _getCountWhenNotControlled(learningGoal);

      double value = (countWhenControlled +
              countWhenNotControlled -
              (countWhenControlled > countWhenNotControlled
                  ? countWhenControlled - countWhenNotControlled
                  : countWhenNotControlled - countWhenControlled))
          .toDouble();
      if (value > bestValue) {
        bestValue = value;
        bestLearningGoal = learningGoal;
      }
    }
    return bestLearningGoal;
  }

  /// Returns the number of untested successors of the input [learningGoal].
  int _getCountWhenControlled(LearningGoal learningGoal) {
    return learningTree
        .getTreeBySuccessors(learningGoal)
        .filter((learningGoal) => !learningGoal.isAlreadyTested())
        .length;
  }

  /// Returns the number of untested predecessors of the input [learningGoal].
  int _getCountWhenNotControlled(LearningGoal learningGoal) {
    return learningTree
        .getLearningGoalStructureByPredecessors(learningGoal)
        .filter((learningGoal) => !learningGoal.isAlreadyTested())
        .length;
  }

  @override
  int get testsCount => _testsCount;

  /// Should be called after testing a [LearningGoal].
  /// Updates the [controlPercentage] depending on whether the [LearningGoal] is [controlled] or not.
  void _updatePercentage(bool controlled) {
    controlPercentage =
        (controlPercentage * (_testsCount - 1) + (controlled ? 1 : 0)) /
            _testsCount;
  }
}
