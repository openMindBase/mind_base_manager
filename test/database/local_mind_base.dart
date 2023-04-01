// @author Matthias Weigt 01.04.23

import 'package:flutter_test/flutter_test.dart';
import 'package:mind_base_manager/database/local_mind_base.dart';
import 'package:mind_base_manager/database/mind_base.dart';
import 'package:mind_base_manager/domain/entities/learning_goals_and_structures/knowledge_state.dart';
import 'package:mind_base_manager/domain/entities/learning_goals_and_structures/learning_goal.dart';
import 'package:mind_base_manager/domain/entities/persons/student_metadata.dart';

/// Tests for LocalMindBase.

void main() {
  test("Write totalKnowledgeState", () {
    MindBase m = LocalMindBase(
        pathRoot:
            "/Users/matthiasweigt/IdeaProjects/mind_base_manager/mind_bases/germany_school_math");
    KnowledgeState knowledgeState = KnowledgeState(
        controlledGoals: {LearningGoal(id: "a"), LearningGoal(id: "g")},
        improvementGoals: {LearningGoal(id: "b")},
        keyLearningGoals: {LearningGoal(id: "c")});

    StudentMetadata metadata = const StudentMetadata("hans");

    m.writeTotalKnowledgeState(
        studentMetadata: metadata, knowledgeState: knowledgeState);
  });
}
