// @author Matthias Weigt 21.03.23

import 'package:mind_base_manager/database/mind_base_md_converter_default.dart';
import 'package:mind_base_manager/domain/entities/learning_goals_and_structures/knowledge_state.dart';
import 'package:mind_base_manager/domain/entities/learning_goals_and_structures/learning_goal.dart';

abstract class MindBaseMdConverter{
  static MindBaseMdConverter? currentMindBaseMdConverter;

  /// Initializes the [MindBase]database in use.
  /// Must be called before accessing the database.
  static init(MindBaseMdConverter mindBaseMdConverter) => currentMindBaseMdConverter = mindBaseMdConverter;

  /// Access to the current [MindBase].
  static MindBaseMdConverter get instance{
    currentMindBaseMdConverter ??= MindBaseMdConverterDefault();
    return currentMindBaseMdConverter!;
  }

  /// Converts a List with lines of a markdown String to a [LearningGoal].
  LearningGoal fromLearningGoalMd(List<String> mdLines, String id);

  /// Converts a [LearningGoal] to a markdown string.
  String learningGoalToMd(LearningGoal learningGoal);

  /// Converts a [LearningGoal] into a markdown string, that represents the metadata of the knowledge state of a controlled learningGoal.
  /// The metadata includes the id, the last time the learningGoal was tested and the number of times the learningGoal was controlled.
  String learningGoalKnowledgeStateOfControlledToMd(LearningGoal learningGoal);

  /// Converts a markdown string, that represents the metadata of the knowledge state of a controlled learningGoal, to a [LearningGoal].
  LearningGoal learningGoalKnowledgeStateOfControlledFromMd(
      List<String> mdFileAsList);

  /// Converts a [KnowledgeState] to a String representing a md file.
  String knowledgeStateToMd(KnowledgeState knowledgeState);

  /// Converts a String representing a md file to a [KnowledgeState].
  KnowledgeState knowledgeStateFromMd(String mdFileAsString);
}