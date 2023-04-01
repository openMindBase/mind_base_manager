// @author Matthias Weigt 01.04.23

import 'package:flutter_test/flutter_test.dart';
import 'package:mind_base_manager/database/mind_base_md_converter_default.dart';
import 'package:mind_base_manager/domain/entities/learning_goals_and_structures/knowledge_state.dart';
import 'package:mind_base_manager/domain/entities/learning_goals_and_structures/learning_goal.dart';

/// Creates tests for [MindBaseMdConverterDefault].
void main() {
  KnowledgeState knowledgeState = KnowledgeState(
      controlledGoals: {LearningGoal(id: "a"), LearningGoal(id: "g")},
      improvementGoals: {LearningGoal(id: "b")},
      keyLearningGoals: {LearningGoal(id: "c")});

  MindBaseMdConverterDefault converter = MindBaseMdConverterDefault();

  test(
    "KnowledgeState to md",
    () {
      String mdString = converter.knowledgeStateToMd(knowledgeState);
      print(mdString);
    },
  );
}
