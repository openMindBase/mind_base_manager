// @author Matthias Weigt 21.03.23

import 'package:mind_base_manager/domain/entities/learning_goals_and_structures/learning_goal.dart';
import 'package:mind_base_manager/domain/entities/learning_goals_and_structures/learning_goal_structure.dart';
import 'package:mind_base_manager/domain/use_cases/learning_tree_builder.dart';
import 'package:mind_base_manager/domain/use_cases/spaced_repitition_engine/spaced_repetition_engine.dart';

import '../entities/learning_goals_and_structures/knowledge_state.dart';
import '../entities/learning_goals_and_structures/learning_tree.dart';

class LearningGoalCollection {
  LearningGoalCollection(this.learningGoalMap);

  /// The [LearningGoal]s that are contained in this collection.
  final Map<String, LearningGoal> learningGoalMap;

  /// Returns a [LearningGoalCollection] containing all [LearningGoal]s that are tagged with [tag].
  LearningGoalCollection filterByTag(String tag) {
    Map<String, LearningGoal> output = {};
    for (var v in learningGoalMap.values) {
      if (v.tags.contains(tag)) {
        output[v.id] = v;
      }
    }
    return LearningGoalCollection(output);
  }

  /// Builds a learning tree according to the [LearningGoal]s in [learningGoalMap].
  /// If the [LearningGoalStructure] has multiple roots. Only one root will be used for creating the LearningTree.
  LearningTree getLearningTree() {
    return LearningTreeBuilder.build(learningGoalMap.values);
  }

  /// Returns a [LearningGoalCollection] containing all [LearningGoal]s that are dependent on the [learningGoal].
  LearningGoalCollection getAllDependentsOf(LearningGoal learningGoal) {
    Map<String, LearningGoal> output = {};
    _addLearningGoalToMapAndDependents(learningGoal, output);
    return LearningGoalCollection(output);
  }

  /// Checks if the [LearningGoalCollection] contains the [learningGoal].
  bool contains(LearningGoal learningGoal) {
    for (var v in learningGoalMap.values) {
      if (learningGoal == v) {
        return true;
      }
    }
    return false;
  }

  /// Checks if the [LearningGoalCollection] contains the [title] of a [LearningGoal].
  bool containsTitle(String title) {
    for (var v in learningGoalMap.values) {
      if (title == v.title) {
        return true;
      }
    }
    return false;
  }

  /// Updates the [LearningGoal]s in the [LearningGoalCollection] with the [KnowledgeState]s in [knowledgeState].
  /// For example, if a [LearningGoal] is marked as "controlled" in [knowledgeState],
  /// the [LearningGoal] in the [LearningGoalCollection] will be marked as "controlled" as well.
  /// Important: [updateWithKnowledgeState] only updates controlled learning goals and uses spaced repetition based on the times
  /// a learning goal has been marked as "controlled" in a row.
  void updateWithKnowledgeState(KnowledgeState knowledgeState) {
    for (var controlledGoal in knowledgeState.controlledGoals) {
      if (learningGoalMap[controlledGoal.id] != null) {
        LearningGoal learningGoal = learningGoalMap[controlledGoal.id]!;
        learningGoal.lastCorrectlyTested = controlledGoal.lastCorrectlyTested;
        learningGoal.timesTestedCorrectlyStreak =
            controlledGoal.timesTestedCorrectlyStreak;
        if (!SpacedRepetitionEngine.instance.shouldTestAgain(
            lastCorrectlyTested: learningGoal.lastCorrectlyTested,
            timesTestedCorrectlyStreak:
                learningGoal.timesTestedCorrectlyStreak)) {
          learningGoal.setAsControlled(incrementTimesTestedCorrectly: false);
        }
      }
    }
  }

  /// Reads all tags within the [learningGoalMap] and lists them in the output.
  Set<String> tags() {
    Set<String> output = {};
    for (var v in learningGoalMap.values) {
      for (var tag in v.tags) {
        output.add(tag);
      }
    }
    return output;
  }

  void _addLearningGoalToMapAndDependents(
      LearningGoal learningGoal, Map<String, LearningGoal> map) {
    if (map[learningGoal.id] != null) {
      return;
    }
    map[learningGoal.id] = learningGoal;
    for (var v in learningGoal.dependents) {
      if (learningGoalMap[v] == null) {
        return;
      }
      _addLearningGoalToMapAndDependents(learningGoalMap[v]!, map);
    }
  }
}
