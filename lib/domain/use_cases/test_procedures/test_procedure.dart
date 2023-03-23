// @author Matthias Weigt 27.07.2022

import '../../entities/learning_goals_and_structures/learning_goal.dart';
import '../../entities/learning_goals_and_structures/learning_tree.dart';

/// This class is a model for a test procedure to test the [LearningGoal]s in a [LearningTree].
abstract class TestProcedure {

  /// The [LearningTree] to test.
  LearningTree learningTree;

  /// The [LearningGoal] that is tested right now.
  LearningGoal? _currentLearningGoal;

  TestProcedure(this.learningTree,{DateTime? startTime}):startingTime=startTime??DateTime.now();


  bool testingActive = true;

  DateTime startingTime;

  /// Function to reset the [TestProcedure].
  void reset();

  /// Easy access to the percentage of all [LearningGoal]s that are controlled within [LearningTree].
  double get totalControlLevel => learningTree.totalControlLevel;

  /// Sets the [LearningGoal.controlLevel] of the current [LearningGoal] to [controlLevel], if current [LearningGoal] has not been tested.
  void assignCurrentControlLevel(double controlLevel) {
    currentLearningGoal.assignControlLevel(controlLevel: controlLevel);
  }

  /// Should be called when the current [LearningGoal] was tested.
  /// Returns [true] if there is another [LearningGoal] in [learningTree] to test.
  /// Returns [false] at the end of the [TestProcedure].
  bool submitCurrentLearningGoal(double controlLevel);


  int secondsPassed() {
    return startingTime.difference(DateTime.now()).inSeconds*-1;
  }

  /// Sets the [_currentLearningGoal] to [learningGoal], if [learningGoal] != null.
  void assignCurrentLearningGoal(LearningGoal? learningGoal) {
    if (learningGoal != null) {
      _currentLearningGoal = learningGoal;
    }
  }

  // /// A List of buttons with the dependents to the current [LearningGoal].
  // List<LearningGoalButton> dependentsAsButtons(LearningGoalCallback onPressed){
  //   Set<LearningGoal> dependents = learningTree.getAllSuccessors(currentLearningGoal.id);
  //   List<LearningGoalButton> output= [];
  //   for(var v in dependents) {
  //     if(v.isControlled()) {
  //       continue;
  //     }
  //       output.add(LearningGoalButton(learningGoal: v, learningGoalCallback: onPressed));
  //   }
  //   return output;
  // }

  /// [topDown] == [true] : Sets the [LearningGoal.controlLevel] of every successor of the input [learningGoal] to 1 (controlled).
  /// [topDown] == [false] : Sets the [LearningGoal.controlLevel] of every predecessor of the input [learningGoal] to 1 (controlled).
  void markSubStructureControlLevel(
      {required LearningGoal learningGoal, required bool topDown}) {
    if (topDown) {
      markAllTopDownAsControlled(learningGoal);
    } else {
      markAllBottomUpAsNotControlled(learningGoal);
    }
  }

  /// Sets the [LearningGoal.controlLevel] of every successor of the input [learningGoal] to 1 (controlled).
  void markAllTopDownAsControlled(LearningGoal learningGoal) {
    learningTree.getTreeBySuccessors(learningGoal).assignControlLevel(level: 1);
  }

  /// Sets the [LearningGoal.controlLevel] of every predecessor of the input [learningGoal] to 1 (controlled).
  void markAllBottomUpAsNotControlled(LearningGoal learningGoal) {
    learningTree
        .getLearningGoalStructureByPredecessors(learningGoal)
        .assignControlLevel(level: 0);
  }

  void setCurrentLearningGoal(LearningGoal learningGoal) => _currentLearningGoal = learningGoal;

  /// Gets [_currentLearningGoal] if [_currentLearningGoal] has been initialized with [LearningGoal].
  /// Throws if [_currentLearningGoal] has not been initialized.
  LearningGoal get currentLearningGoal {
    if (_currentLearningGoal != null) {
      return _currentLearningGoal as LearningGoal;
    }
    testingActive = false;
    return learningTree.trunkGoal;
  }

  int get testsCount;
}
