// @author Matthias Weigt 21.03.23

import 'package:mind_base_manager/domain/entities/learning_goals_and_structures/learning_goal.dart';
import 'package:mind_base_manager/domain/entities/learning_goals_and_structures/learning_goal_structure.dart';
import 'package:mind_base_manager/domain/use_cases/learning_tree_builder.dart';

import '../entities/learning_goals_and_structures/learning_tree.dart';

class LearningGoalCollection {
  LearningGoalCollection(this.learningGoalMap);

  final Map<String, LearningGoal> learningGoalMap;

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

  LearningGoalCollection getAllDependentsOf(LearningGoal learningGoal) {
    Map<String, LearningGoal> output = {};
    _addLearningGoalToMapAndDependents(learningGoal, output);
    return LearningGoalCollection(output);
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
