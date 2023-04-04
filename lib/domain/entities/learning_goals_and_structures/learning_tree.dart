// @author Matthias Weigt 27.07.2022
// All rights reserved ©2022

import 'package:mind_base_manager/domain/entities/learning_goals_and_structures/knowledge_state.dart';

import '../graphs/transitivity_cleaner.dart';
import 'learning_goal.dart';
import 'learning_goal_structure.dart';
import 'learning_tree_signature.dart';

/// A [LearningTree] is a [LearningGoalStructure] with exactly one [trunk].
class LearningTree extends LearningGoalStructure {
  /// This constructor validates the input with [_validateTrunkCount] and throws if input is not valid.
  LearningTree(
      {required super.nodes,
      required super.edges,
      super.title,
      this.id = "",
      LearningTreeSignature? learningTreeSignature})
      : _learningTreeSignature = learningTreeSignature {
    _validateTrunkCount();
    trunk = trunks.first;
  }

  LearningTree.byGoal({required LearningGoal learningGoal, this.id = ""})
      : super(nodes: {learningGoal}, edges: {}, title: learningGoal.title) {
    trunk = learningGoal.id;
  }

  /// The only trunk of the [LearningTree].
  /// Trunk definition: [LearningGoalStructure].
  late String trunk;
  final String id;

  LearningTreeSignature? _learningTreeSignature;

  LearningGoal get trunkGoal => getNodeById(trunk);

  /// A key [LearningGoal] is a controlled [LearningGoal] that has direct successors which are not controlled.
  bool isKeyLearningGoal(LearningGoal learningGoal) {
    if (learningGoal.isControlled() || learningGoal.shouldBeImproved()) {
      return false;
    }
    var set = getDirectDependents(learningGoal);
    for (var v in set) {
      if (!v.isControlled() && !v.shouldBeImproved()) {
        return false;
      }
    }
    return true;
  }

  LearningTree cleanTransitivity() {
    return LearningTree(
        nodes: nodes,
        edges: TransitivityCleaner(edges).get(),
        id: id,
        title: title);
  }

  /// A key [LearningGoal] is a controlled [LearningGoal] that has direct successors which are not controlled.
  Set<LearningGoal> get keyLearningGoals {
    return filter((learningGoal) => isKeyLearningGoal(learningGoal));
  }

  /// A set of [LearningGoal]s which should be improved.
  Set<LearningGoal> get shouldBeImprovedGoal {
    return filter((learningGoal) => learningGoal.shouldBeImproved());
  }

  /// Getter for the percentage of all [LearningGoal]s that are controlled.
  double get totalControlLevel => controlledGoals.length / learningGoals.length;

  int? keyLearningGoalIndex(LearningGoal learningGoal) {
    List<LearningGoal> keyLearningGoalList = sortedKeyLearningGoals;
    int? output;

    int i = 1;
    for (var v in keyLearningGoalList) {
      if (v == learningGoal) {
        output = i;
        break;
      }

      i++;
    }

    return output;
  }

  int? improvementLearningGoalIndex(LearningGoal learningGoal) {
    List<LearningGoal> improvementGoalList = sortedImprovementGoals;
    int? output;

    int i = 1;
    for (var v in improvementGoalList) {
      if (v == learningGoal) {
        output = i;
        break;
      }

      i++;
    }

    return output;
  }

  List<LearningGoal> get sortedKeyLearningGoals {
    List<LearningGoal> keyLearningGoalList = keyLearningGoals.toList();
    keyLearningGoalList.sort(
      (a, b) => a.id.compareTo(b.id),
    );
    return keyLearningGoalList;
  }

  List<LearningGoal> get sortedImprovementGoals {
    List<LearningGoal> shouldBeImprovedGoalList = shouldBeImprovedGoal.toList();
    shouldBeImprovedGoalList.sort(
      (a, b) => a.id.compareTo(b.id),
    );
    return shouldBeImprovedGoalList;
  }

  void resetControlLevelIf(LearningGoalBoolCallback learningGoalBoolCallback) {
    for (var v in learningGoals) {
      if (learningGoalBoolCallback(v)) {
        v.resetControlLevel();
      }
    }
  }

  LearningTreeSignature signature(
      {bool forceGenerateNew = false, double maxTries = 1000}) {
    if (_learningTreeSignature != null && !forceGenerateNew) {
      return _learningTreeSignature as LearningTreeSignature;
    }
    _learningTreeSignature =
        LearningTreeSignature.byTree(this).sort(maxTries: maxTries);
    return signature();
  }

  void sort(double force) {
    if (learningGoals.length < 7) {
      return;
    }

    _learningTreeSignature = signature().sort(maxTries: force);
  }

  double computePercentageControlled() {
    return filter((learningGoal) => learningGoal.isControlled()).length /
        totalGoalCount;
  }

  double computePercentageShouldBeImproved() {
    return filter((learningGoal) => learningGoal.shouldBeImproved()).length /
        totalGoalCount;
  }

  double computePercentageKeyLearningGoal() {
    return filter((learningGoal) => isKeyLearningGoal(learningGoal)).length /
        totalGoalCount;
  }

  double computePercentageUncontrolled() {
    return 1 -
        computePercentageControlled() -
        computePercentageKeyLearningGoal() -
        computePercentageShouldBeImproved();
  }

  /// Converts this [LearningTree] to an [KnowledgeState].
  KnowledgeState toKnowledgeState() {
    return KnowledgeState(
        controlledGoals: controlledGoals,
        improvementGoals: shouldBeImprovedGoal,
        keyLearningGoals: keyLearningGoals,
        tooHardGoals: tooHardGoals);
  }

  /// Computes all [LearningGoal]s that are not controlled and not key [LearningGoal]s.
  Set<LearningGoal> get tooHardGoals {
    return filter((learningGoal) =>
        !learningGoal.isControlled() && !isKeyLearningGoal(learningGoal));
  }

  int get totalGoalCount => learningGoals.length;

  /// Throws if there is more then one [trunk].
  void _validateTrunkCount() {
    if (trunks.length != 1) {
      throw ArgumentError(
          "Structure is not properly created. Has more then one trunk");
    }
  }
}

typedef LearningGoalBoolCallback = bool Function(LearningGoal learningGoal);
