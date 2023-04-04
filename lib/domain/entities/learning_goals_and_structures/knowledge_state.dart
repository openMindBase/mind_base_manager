// @author Matthias Weigt 31.03.23


import 'learning_goal.dart';

/// The pure representation of a knowledge state.
class KnowledgeState {

  KnowledgeState(
      {required this.controlledGoals,
      required this.improvementGoals,
      required this.keyLearningGoals,
      required this.tooHardGoals});

  /// The [LearningGoal]s that are controlled by the student.
  final Set<LearningGoal> controlledGoals;

  /// The [LearningGoal]s that are in the improvement phase.
  final Set<LearningGoal> improvementGoals;

  /// The [LearningGoal]s that are in the key learning phase.
  final Set<LearningGoal> keyLearningGoals;

  /// The [LearningGoal]s that are too hard for the student.
  final Set<LearningGoal> tooHardGoals;

  KnowledgeState operator +(KnowledgeState other) {
    return KnowledgeState(
        controlledGoals: controlledGoals..addAll(other.controlledGoals),
        improvementGoals: improvementGoals..addAll(other.improvementGoals),
        keyLearningGoals: keyLearningGoals..addAll(other.keyLearningGoals),
        tooHardGoals: tooHardGoals..addAll(other.tooHardGoals));
  }

  /// Getter for a List<LearningGoal> of all LearningGoals within this [KnowledgeState].
  List<LearningGoal> get allLearningGoals => controlledGoals.toList()
    ..addAll(improvementGoals)
    ..addAll(keyLearningGoals)
    ..addAll(tooHardGoals);

  /// Removes the [learningGoal] from all sets.
  void removeLearningGoal(LearningGoal learningGoal) {
    controlledGoals.removeWhere((element) => element == learningGoal);
    improvementGoals.removeWhere((element) => element == learningGoal);
    keyLearningGoals.removeWhere((element) => element == learningGoal);
    tooHardGoals.removeWhere((element) => element == learningGoal);
  }

  /// Updates this [KnowledgeState] with the [other] [KnowledgeState].
  /// The [other] [KnowledgeState] is subtracted from this [KnowledgeState] and then added to it.
  /// This means, than all [LearningGoals]s in this which are also in [other] are replaced by the [LearningGoals]s in [other].
  KnowledgeState update(KnowledgeState other) {
    KnowledgeState output = clone();
    for (var v in other.allLearningGoals) {
      output.removeLearningGoal(v);
    }
    return output + other;
  }

  /// Clones this [KnowledgeState].
  KnowledgeState clone() {
    return KnowledgeState(
        controlledGoals: controlledGoals,
        improvementGoals: improvementGoals,
        keyLearningGoals: keyLearningGoals,
        tooHardGoals: tooHardGoals);
  }
}
