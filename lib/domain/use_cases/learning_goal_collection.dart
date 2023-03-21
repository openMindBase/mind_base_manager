// @author Matthias Weigt 21.03.23


import 'package:mind_base_manager/domain/entities/learning_goal.dart';

class LearningGoalCollection {
  LearningGoalCollection(this.learningGoalMap);


  final Map<String,LearningGoal> learningGoalMap;

  Map<String,LearningGoal> getAllDependentsOf(LearningGoal learningGoal) {
    Map<String,LearningGoal> output = {};
    _addLearningGoalToMapAndDependents(learningGoal, output);
    return output;
  }

  void _addLearningGoalToMapAndDependents(LearningGoal learningGoal,Map<String,LearningGoal> map) {
    if(map[learningGoal.id] != null) {
      return;
    }
    map[learningGoal.id] = learningGoal;
    for(var v in learningGoal.dependents) {
      if(learningGoalMap[v] == null) {
        return;
      }
      _addLearningGoalToMapAndDependents(learningGoalMap[v]!, map);
    }
  }




}
