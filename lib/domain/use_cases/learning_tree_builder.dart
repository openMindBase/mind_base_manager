// @author Matthias Weigt 21.03.23


import 'package:mind_base_manager/domain/entities/learning_goals_and_structures/learning_goal_structure.dart';

import '../entities/graphs/edge.dart';
import '../entities/learning_goals_and_structures/learning_goal.dart';
import '../entities/learning_goals_and_structures/learning_tree.dart';

class LearningTreeBuilder {

  static LearningTree build(Iterable<LearningGoal> learningGoals) {
    Set<Edge> edges = {};

    for(var v in learningGoals) {
        for(var dependent in v.dependents) {
            edges.add(Edge(x1: v.id, x2: dependent));
        }
    }
    LearningGoalStructure l = LearningGoalStructure(nodes: learningGoals.toSet(), edges: edges);
    return l.getTreeBySuccessors(l.getNodeById(l.trunks.first));
  }

}