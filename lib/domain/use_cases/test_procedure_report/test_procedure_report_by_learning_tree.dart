// @author Matthias Weigt 27.07.2022
// All rights reserved ©2022

import 'package:mind_base_manager/domain/use_cases/test_procedure_report/test_procedure_report.dart';

import '../../entities/learning_goals_and_structures/learning_goal.dart';
import '../../entities/learning_goals_and_structures/learning_tree.dart';
import '../../use_cases/test_procedures/test_procedure.dart';

/// This is a abstract class that represents a [TestProcedure] report.
/// Use this class for [TestProcedureReport] that involve a [LearningTree].
abstract class TestProcedureReportByLearningTree extends TestProcedureReport {
  TestProcedureReportByLearningTree(this.learningTree, {super.name}) {
    validateLearningTree();
  }

  /// The [LearningTree] of the [TestProcedure] that is reported.
  final LearningTree learningTree;

  /// Delegate for [LearningTree.keyLearningGoals].
  Set<LearningGoal> get keyLearningGoals => learningTree.keyLearningGoals;

  /// Delegate for [LearningTree.shouldBeImprovedGoal].
  Set<LearningGoal> get shouldBeImprovedGoal => learningTree.shouldBeImprovedGoal;

  /// Throws if there is an untested [LearningGoal] in the [LearningTree] of the [TestProcedure] that is reported.
  void validateLearningTree() {
    if (learningTree.untestedLearningGoals.length > 1) {
      throw ArgumentError(
          "Not all goals of ${learningTree.title} has been tested.");
    }
  }
}
