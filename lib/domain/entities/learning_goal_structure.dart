// @author Matthias Weigt 27.07.2022
// All rights reserved ©2022

import 'graphs/edge.dart';
import 'graphs/graph.dart';
import 'learning_goal.dart';
import 'learning_tree.dart';

/// This class represents a learning goal structure consisting of [LearningGoal]s connected with [Edge]s.
/// [LearningGoal]s of [LearningGoalStructure] are called [leaves] when they don't have successors.
/// A direct successor of a [LearningGoal] is a [LearningGoal] that is connected to the first [LearningGoal] by [Edge] and is the ending point of this connection.
/// [LearningGoal]s of [LearningGoalStructure] are called [trunks] when they don't have predecessor.
/// A direct predecessor of one [LearningGoal] is a [LearningGoal] that is connected to the first [LearningGoal] by [Edge] and is the starting point of this connection.
/// The grade of a [LearningGoal] is the maximum way between the [LearningGoal] and a leave.
class LearningGoalStructure extends Graph<LearningGoal> {

  /// Initializes all late instant variables.
  LearningGoalStructure(
      {required super.nodes, required super.edges, String? title})
      : _title = title ?? "-" {
    trunks = _trunks;
    leaves = _leaves;
    gradesById = _gradesById;
    learningGoalsByGrade = _learningGoalsByGrade;
    maxGrade = learningGoalsByGrade.length - 1;
  }

  /// The title of [LearningGoalStructure].
  final String? _title;

  /// The leaves of [LearningGoalStructure] represented by [id].
  late Set<String> leaves;

  /// Easy access to grades of [LearningGoal] by the [id] of [LearningGoal].
  late Map<String, int> gradesById;

  /// Easy access to all [LearningGoal]s that have a specific grade.
  late Map<int, Set<LearningGoal>> learningGoalsByGrade;

  /// The maximum grade of [LearningGoalStructure] is the longest way from one trunk to one leave.
  late int maxGrade;

  /// All trunks of the [LearningGoalStructure] represented by [id].
  late Set<String> trunks;

  /// Throws If [flag] == true.
  void flagCheck({required bool flag, required String name}) {
    if (flag) {
      throw StateError("$name  was true.");
    }
  }

  /// Returns the grade of the input [LearningGoal] and throws if [LearningGoal] is not part of [LearningGoalStructure].
  int getGradeOfGoal(LearningGoal learningGoal) {
    int? grade = gradesById[learningGoal.id];
    if (grade == null) {
      throw ArgumentError("Seems $learningGoal is not inside the tree");
    }
    return grade;
  }

  /// Returns one of the [trunks] of the [LearningGoalStructure] that contains the input [LearningGoal].
  LearningGoal getTrunk(LearningGoal learningGoal) {
    String id = learningGoal.id;
    LearningGoal output = learningGoal;
    while (true) {
      var set = getDirectPredecessors(output);
      if (set.isEmpty) {
        return output;
      }
      output = set.first;
      if (output.id == id) {
        throw _CyclicError();
      }
    }
  }

  /// Returns a [LearningTree] that is part of [LearningGoalStructure] where the input [LearningGoal] is the trunk.
  LearningTree getTreeBySuccessors(LearningGoal learningGoal) {
    var s = getSubGraphBySuccessors(learningGoal.id);
    return LearningTree(nodes: s.nodes, edges: s.edges);
  }

  /// Returns a sub-[LearningGoalStructure] that is part of [LearningGoalStructure].
  /// All predecessors of the input [LearningGoal] are taken into the sub-[LearningGoalStructure] and the input [LearningGoal] is the ending point.
  LearningGoalStructure getLearningGoalStructureByPredecessors(
      LearningGoal learningGoal) {
    var s = getSubGraphByPredecessors(learningGoal.id);
    return LearningGoalStructure(nodes: s.nodes, edges: s.edges);
  }

  /// Returns a set of all the direct successors of the input [LearningGoal].
  Set<LearningGoal> getDirectDependents(LearningGoal learningGoal) {
    return getDirectSuccessors(learningGoal);
  }

  /// Merges [structure] with [this].
  LearningGoalStructure add(LearningGoalStructure structure) {
    Set<LearningGoal> learningGoals = cloneNodes()
      ..addAll(structure.cloneNodes());
    Set<Edge> edges = cloneEdges()..addAll(structure.cloneEdges());
    return LearningGoalStructure(nodes: learningGoals, edges: edges);
  }

  /// Sets the + operator to [add].
  LearningGoalStructure operator +(LearningGoalStructure other) => add(other);

  /// The set of all [LearningGoal] of [LearningGoalStructure].
  Set<LearningGoal> get learningGoals => nodes;

  /// This function takes a function and uses it on every [LearningGoal] in [LearningGoalStructure].
  void onEveryLearningGoal(OnEveryLearningGoal onEveryLearningGoal) {
    for (LearningGoal learningGoal in learningGoals) {
      onEveryLearningGoal(learningGoal);
    }
  }

  /// Assigns a control [level] to every [LearningGoal] in [LearningGoalStructure].
  void assignControlLevel({required double level}) {
    onEveryLearningGoal(
        (learningGoal) => learningGoal.assignControlLevel(controlLevel: level));
  }

  /// A valid [LearningTree] has exactly one trunk.
  bool get validLearningTree => trunks.length == 1;

  /// Getter for all [LearningGoal]s in [LearningGoalStructure] that untested.
  Set<LearningGoal> get untestedLearningGoals {
    return filter((learningGoal) => !learningGoal.isAlreadyTested());
  }

  /// Getter for all [LearningGoal]s in [LearningGoalStructure] that are controlled.
  Set<LearningGoal> get controlledGoals {
    return filter((learningGoal) => learningGoal.isControlled());
  }

  String get title => _title ?? "";

  /// Will be set true if [_leaves] is called.
  bool _leavesSet = false;

  /// Will be set true if [_gradesById] is called.
  bool _gradesByIdSet = false;

  /// Will be set true if [_learningGoalsByGrade] is called.
  bool _learningGoalsByGradeSet = false;

  /// Will be set true if [_trunks] is called.
  bool _trunksSet = false;

  /// Returns the [leaves] of [LearningGoalStructure].
  /// Can only be called once and throws if called again.
  Set<String> get _leaves {
    flagCheck(flag: _leavesSet, name: "_leavesSet");
    Set<String> output = {};
    for (LearningGoal learningGoal in learningGoals) {
      if (getDirectSuccessors(learningGoal).isEmpty) {
        output.add(learningGoal.id);
      }
    }
    _leavesSet = true;
    return output;
  }

  /// Returns a Map that assigns a grade to every [LearningGoal] in [LearningGoalStructure] by the [id] of [LearningGoal].
  /// Can only be called once and throws if called again.
  Map<String, int> get _gradesById {
    flagCheck(flag: _gradesByIdSet, name: "_gradesSet");
    Map<String, int> output = {};
    int gradeIndex = -1;
    while (true) {
      gradeIndex++;
      int index = 0;
      if (gradeIndex == 0) {
        for (String s in leaves) {
          output[s] = gradeIndex;
        }
        continue;
      }
      Map<String, int> tempGrades = {};
      for (LearningGoal learningGoal in learningGoals) {
        Set<LearningGoal> tempGoals = getDirectSuccessors(learningGoal);
        if (output[learningGoal.id] != null || tempGoals.isEmpty) continue;
        int k = 0;
        for (LearningGoal temp in tempGoals) {
          if (output[temp.id] == null) {
            break;
          }
          k++;
        }
        if (k == tempGoals.length) {
          tempGrades[learningGoal.id] = gradeIndex;
          index++;
        }
      }
      if (index == 0) {
        _gradesByIdSet = true;
        return output;
      }
      for (String s in tempGrades.keys) {
        int? g = tempGrades[s];
        if (g != null) {
          output[s] = g;
        }
      }
    }
  }

  /// Returns a Map that assigns a grade to a set of [LearningGoal]s with exactly that grade in [LearningGoalStructure].
  /// Can only be called once and throws if called again.
  Map<int, Set<LearningGoal>> get _learningGoalsByGrade {
    flagCheck(flag: _learningGoalsByGradeSet, name: "_learningGoalsByGradeSet");
    Map<int, Set<LearningGoal>> output = {};
    for (LearningGoal learningGoal in learningGoals) {
      int grade = getGradeOfGoal(learningGoal);
      if (output[grade] == null) {
        output[grade] = <LearningGoal>{};
      }
      output[grade]?.add(learningGoal);
    }
    _learningGoalsByGradeSet = true;
    return output;
  }

  /// Returns a Set of all trunk [id]'s of [LearningGoalStructure].
  /// Can only be called once and throws if called again.
  Set<String> get _trunks {
    flagCheck(flag: _trunksSet, name: "_trunksSet");
    Set<String> output = {};
    for (LearningGoal learningGoal in learningGoals) {
      output.add(getTrunk(learningGoal).id);
    }
    _trunksSet = true;
    return output;
  }

  /// This function takes a filter and applys it on every [LearningGoal] in [LearningGoalStructure].
  /// Returns a set of filtered [LearningGoal]s.
  Set<LearningGoal> filter(LearningGoalFilter filter) {
    Set<LearningGoal> output = {};
    for (var v in learningGoals) {
      if (filter(v)) {
        output.add(v);
      }
    }
    return output;
  }
}

/// This error should be threw if the structure is cyclic.
class _CyclicError extends Error {
  static const errorMsg = "Structure seems to be cyclic.";

  @override
  String toString() => errorMsg;
}


/// This type definition is a function that should be used on every [LearningGoal] in [LearningGoalStructure].
typedef OnEveryLearningGoal = void Function(LearningGoal learningGoal);


/// This type definition is used to [filter] all [LearningGoal]s in [LearningGoalStructure].
typedef LearningGoalFilter = bool Function(LearningGoal learningGoal);