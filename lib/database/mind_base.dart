// @author Matthias Weigt 21.03.23


import '../domain/entities/learning_goal.dart';

abstract class MindBase{
  static MindBase? currentMindBase;

  /// Initializes the [MindBase]database in use.
  /// Must be called before accessing the database.
  static init(MindBase mindBase) => currentMindBase = mindBase;

  /// Access to the current [MindBase].
  static MindBase get instance{
    if(currentMindBase==null) {
      throw StateError("The MindBase is not initialized yet. Use MindBase.init for Initialization.");
    }
    return currentMindBase!;
  }



  /// Reads a single [LearningGoal] by the id of the goal.
  Future<LearningGoal> readLearningGoal(String id);

  /// Reads all [LearningGoal]s.
  Future<List<LearningGoal>> readAllLearningGoals({bool printStats=false});

  /// Reads all [LearningGoal]s.
  Future<Map<String,LearningGoal>> readAllLearningGoalsAsMap({bool printStats=false});

}