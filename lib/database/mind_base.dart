// @author Matthias Weigt 21.03.23

import 'package:flutter/material.dart';

import '../domain/entities/learning_goals_and_structures/knowledge_state.dart';
import '../domain/entities/learning_goals_and_structures/learning_goal.dart';
import '../domain/entities/persons/student_metadata.dart';
import '../domain/use_cases/learning_goal_collection.dart';

abstract class MindBase {
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
  Future<List<LearningGoal>> readAllLearningGoals({bool printStats = false});

  /// Reads all [LearningGoal]s.
  Future<Map<String, LearningGoal>> readAllLearningGoalsAsMap(
      {bool printStats = false});

  Future<LearningGoalCollection> readAllLearningGoalsAsLearningGoalCollection(
      {bool printStats = false});

  Image image(String id);

  /// Reads all [LearningGoal]s and adds the [KnowledgeState] of the student to it.
  /// If the [KnowledgeState] is available, the [LearningGoalCollection] is updated with it.
  Future<LearningGoalCollection>
      readAllLearningGoalsAsLearningGoalCollectionWithKnowledgeState(
          {required StudentMetadata metadata, bool printStats = false}) async {
    LearningGoalCollection learningGoalCollection =
        await readAllLearningGoalsAsLearningGoalCollection(
            printStats: printStats);
    KnowledgeState? totalKnowledgeState =
        await readTotalKnowledgeState(studentMetadata: metadata);
    if (totalKnowledgeState != null) {
      learningGoalCollection.updateWithKnowledgeState(totalKnowledgeState);
    }
    return learningGoalCollection;
  }

  /// Adds the [tag] to every [LearningGoal] depending on the [LearningGoal] represented by [id].
  Future<void> addTagToLearningGoal(String id, String tag);

  /// Saves the total [KnowledgeState] of the student.
  Future<void> writeTotalKnowledgeState(
      {required KnowledgeState knowledgeState,
      required StudentMetadata studentMetadata});

  /// Reads the total [KnowledgeState] of the student.
  Future<KnowledgeState?> readTotalKnowledgeState(
      {required StudentMetadata studentMetadata});

  /// Reads the total [KnowledgeState] of the student and adds [knowledgeState] to it.
  Future<void> addKnowledgeStateToTotalKnowledgeState(
      {required KnowledgeState knowledgeState,
      required StudentMetadata studentMetadata});

  /// Writes [learningGoal] to the database.
  Future<void> writeLearningGoal(LearningGoal learningGoal);

  /// Reads the [StudentMetadata] of the current student.
  Future<StudentMetadata?> readCurrentStudentMetadata();

  /// Writes the [StudentMetadata] of the current student.
  Future<void> writeCurrentStudentMetadata(StudentMetadata studentMetadata);
}