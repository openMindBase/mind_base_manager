// @author Matthias Weigt 06.09.2022

import '../../entities/graphs/edge.dart';
import '../../entities/learning_goals_and_structures/learning_goal.dart';
import '../../entities/learning_goals_and_structures/learning_goal_structure.dart';
import '../../entities/learning_goals_and_structures/learning_tree.dart';

/// Helps for different kinds of Merging.
class TreeMergingAssistant {
  static LearningTree merge(
      List<LearningGoalStructure> structures, LearningGoal learningGoal,
      {String? overwriteId}) {
    if (structures.length == 1) {
      return LearningTree(
          nodes: structures[0].nodes,
          edges: structures[0].edges,
          title: learningGoal.title,
          id: overwriteId ?? learningGoal.id);
    }

    LearningGoalStructure output = structures[0];
    for (int i = 1; i < structures.length; i++) {
      output += structures[i];
    }
    bool learningGoalIsPart = output.nodes.contains(learningGoal);
    if (learningGoalIsPart) {
      output = LearningGoalStructure(
          nodes: output.nodes,
          edges: output.edges
            ..add(Edge(x1: learningGoal.id, x2: structures[1].trunks.first)),
          title: output.title);
      LearningTree t = output.getTreeBySuccessors(learningGoal);
      return LearningTree(
          id: overwriteId ?? learningGoal.id,
          nodes: t.nodes,
          edges: t.edges,
          title: learningGoal.title);
    }
    Set<Edge> newEdges = {};
    for (var v in output.trunks) {
      newEdges.add(Edge(x1: learningGoal.id, x2: v));
    }
    return LearningTree(
        nodes: output.nodes..add(learningGoal),
        edges: output.edges..addAll(newEdges),
        title: learningGoal.title,
        id: overwriteId ?? learningGoal.id);
  }
}
