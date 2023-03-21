// @author Matthias Weigt 27.07.2022
// All rights reserved ©2022
import 'dart:math';


import 'graphs/edge.dart';
import 'learning_goal.dart';
import 'learning_tree.dart';
import 'learning_tree_coordinates_generator.dart';
import 'learning_tree_signature_order_generator.dart';
import 'math/tuple.dart';

class LearningTreeSignature{
  LearningTreeSignature.byTree(LearningTree learningTree):edges=learningTree.edges,learningGoalsByGrade=_map(learningTree);

  LearningTreeSignature({required this.learningGoalsByGrade, required this.edges});

  final Map<int,List<LearningGoal>> learningGoalsByGrade;
  final Set<Edge> edges;



  static Map<int,List<LearningGoal>> _map(LearningTree learningTree) {
    Map<int,List<LearningGoal>> output = {};
    for(int i=0;i<=learningTree.maxGrade;i++) {
      output[i] = learningTree.learningGoalsByGrade[i]!.toList();
    }
    return output;
  }

  LearningTreeSignature swap({required int grade, required int pos1, required int pos2}) {
    if(grade>learningGoalsByGrade.length-1) {
      return this;
    }
    List<LearningGoal> tempGoals = List.from(learningGoalsByGrade[grade]!);
    LearningGoal temp = tempGoals[pos1];
    tempGoals[pos1] = tempGoals[pos2];
    tempGoals[pos2] = temp;
    Map<int,List<LearningGoal>>  map= {};
    for(var v in learningGoalsByGrade.keys) {
      if(v==grade) {
        map[v] = tempGoals;
        continue;
      }
      map[v] = learningGoalsByGrade[v] as List<LearningGoal>;
    }

    return LearningTreeSignature(learningGoalsByGrade: map, edges: edges);
  }

  LearningTreeSignature shuffle() {
    Map<int,List<LearningGoal>> output = {};
    for(int key in learningGoalsByGrade.keys) {
      List<LearningGoal> tempGoals = List.from(learningGoalsByGrade[key]!);
      tempGoals.shuffle();
      output[key] = tempGoals;
    }
    return LearningTreeSignature(learningGoalsByGrade: output, edges: edges);
  }


  LearningTreeSignature sort({double maxTries = 1000}) {
    return LearningTreeSignatureOrderGenerator.current.get(this,maxTries: maxTries);
  }

  /// Computes the cumulated length of all edges when [LearningTreeCoordinatesGenerator] used.
  double computeAmount() {
    Map<String,Tuple<double>> coordinates = LearningTreeCoordinatesGenerator(this).getCartesian();
    double total = 0;
    for(var v in edges) {
        Tuple<double> p1 = coordinates[v.x1] as Tuple<double>;
        Tuple<double> p2 = coordinates[v.x2] as Tuple<double>;
        total += sqrt((p1.x1-p2.x1)*(p1.x1-p2.x1)+(p1.x2-p2.x2)*(p1.x2-p2.x2));
    }
    return total;
  }

  @override
  String toString() {
    return 'LearningTreeSignature{learningGoalsByGrade: $learningGoalsByGrade}';
  }
}