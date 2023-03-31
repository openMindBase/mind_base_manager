// @author Matthias Weigt 31.03.23


import 'learning_goal.dart';

/// The pure representation of a knowledge state.
class KnowledgeState {

  KnowledgeState(
      {required this.controlledGoals, required this.improvementGoals, required this.keyLearningGoals});

  final Set<LearningGoal> controlledGoals;
  final Set<LearningGoal> improvementGoals;
  final Set<LearningGoal> keyLearningGoals;

  KnowledgeState operator +(KnowledgeState other) {
    return KnowledgeState(
        controlledGoals: controlledGoals..addAll(other.controlledGoals),
        improvementGoals: improvementGoals..addAll(other.improvementGoals),
        keyLearningGoals: keyLearningGoals..addAll(other.keyLearningGoals));
  }
}