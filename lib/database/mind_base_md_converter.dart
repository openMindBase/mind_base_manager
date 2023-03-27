// @author Matthias Weigt 21.03.23

import 'package:mind_base_manager/domain/entities/learning_goals_and_structures/learning_goal.dart';

abstract class MindBaseMdConverter{
  static MindBaseMdConverter? currentMindBaseMdConverter;

  /// Initializes the [MindBase]database in use.
  /// Must be called before accessing the database.
  static init(MindBaseMdConverter mindBaseMdConverter) => currentMindBaseMdConverter = mindBaseMdConverter;

  /// Access to the current [MindBase].
  static MindBaseMdConverter get instance{
    if(currentMindBaseMdConverter==null) {
      throw StateError("The MindBaseMdConverter is not initialized yet. Use MindBaseMdConverter.init for Initialization.");
    }
    return currentMindBaseMdConverter!;
  }

  /// Converts a List with lines of a markdown String to a [LearningGoal].
  LearningGoal fromMd(List<String> mdLines,String id);

  /// Converts a [LearningGoal] to a markdown string.
  String learningGoalToMd(LearningGoal learningGoal);

}