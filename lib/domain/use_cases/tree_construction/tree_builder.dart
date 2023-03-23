// @author Matthias Weigt 27.07.2022
// All rights reserved ©2022

import 'package:mind_base_manager/domain/use_cases/tree_construction/tree_merging_assistant.dart';

import '../../entities/graphs/edge.dart';
import '../../entities/learning_goals_and_structures/learning_goal.dart';
import '../../entities/learning_goals_and_structures/learning_tree.dart';

/// Use this class to edit a [LearningTree].
class TreeBuilder {

  /// This constructor requires an input [startingGoal] that represents the [LearningTree] that [TreeBuilder] is editing.
  /// Calls [_setGoalIds] and [_setFocusGoal] for the [LearningTree] represented by [startingGoal].
  TreeBuilder.byGoal({required LearningGoal startingGoal})
      : _learningTree = LearningTree(nodes: {startingGoal}, edges: {}) {
    _setGoalIds();
    _setFocusGoal();
  }

  /// This constructor requires an input [learningTree] that will be the [LearningTree] that [TreeBuilder] is editing.
  /// Calls [_setGoalIds] and [_setFocusGoal] for [learningTree].
  TreeBuilder.byTree({required LearningTree learningTree})
      : _learningTree = learningTree {
    _setGoalIds();
    _setFocusGoal();
  }

  /// A set of all the ids that represent [LearningGoal]s in [LearningTree].
  late List<String> _goalIds;

  /// The focused [LearningGoal] in [LearningTree].
  /// You can set the focus to another [LearningGoal] with [_setFocusGoal].
  late LearningGoal _focusGoal;

  /// The [LearningTree] that [TreeBuilder] is editing.
  LearningTree _learningTree;

  /// The id that represents [_focusGoal].
  int _focusGoalIndex = 0;

  /// Getter for [_learningTree].
  LearningTree get() => _learningTree;

  /// Adds the input [edge] to the Set of [Edge]s stored in [_learningTree].
  void addEdge(Edge edge) {
    _updateLearningTree(LearningTree(
        nodes: nodes,
        edges: edges..add(edge),
        id: _learningTree.id,
        title: _learningTree.title));
  }

  void sort(double force) {
    _learningTree.sort(force);
  }

  void resetControlLevel() {
    for (var v in _learningTree.learningGoals) {
      v.resetControlLevel();
    }
  }

  /// Use this function if you want to add a [learningGoal] that is connected with an [Edge] to the trunk of [_learningTree]
  /// with [_addLearningGoalFromGoal] to [_learningTree].
  void addLearningGoal({required LearningGoal learningGoal}) {
    _addLearningGoalFromGoal(
        fromGoal: _learningTree.trunkGoal, newGoal: learningGoal);
  }

  /// Use this function if you want to add a [learningGoal] that is [Edge.x2] of an [Edge] where [_focusGoal] is [Edge.x1]
  /// with [_addLearningGoalFromGoal] to [_learningTree].
  void addLearningGoalFromFocusGoal({required LearningGoal learningGoal}) {
    _addLearningGoalFromGoal(fromGoal: _focusGoal, newGoal: learningGoal);
  }

  /// Use this function if you want to add a [learningGoal] that is [Edge.x1] of an [Edge] where [_focusGoal] is [Edge.x2]
  /// with [_addLearningGoalFromGoal] to [_learningTree].
  void addLearningGoalToFocusGoal({required LearningGoal learningGoal}) {
    if (_focusGoal == _learningTree.trunkGoal) {
      _addLearningGoalToGoal(newGoal: learningGoal, toGoal: _focusGoal);
      return;
    }
    _addLearningGoalFromGoal(
        fromGoal: _learningTree.trunkGoal, newGoal: learningGoal);
    addEdge(Edge.fromNodes(node1: learningGoal, node2: _focusGoal));
  }

  /// Deletes all transitive [Edge]s in the set of [Edge]s stored in [_learningTree].
  void cleanTransitivity() {
    _updateLearningTree(_learningTree.cleanTransitivity());
  }

  /// This function requires an input [learningGoal] and [edge].
  /// Adds the input [edge] to the Set of [Edge]s stored in [_learningTree].
  /// Adds the input [learningGoal] to the Set of [LearningGoal]s stored in [_learningTree].
  /// Adds the id that represents the input [learningGoal] to [_goalIds].
  void addLearningGoalAndEdge(
      {required LearningGoal learningGoal, required Edge edge}) {
    _updateLearningTree(
        LearningTree(nodes: nodes..add(learningGoal), edges: edges..add(edge),id: _learningTree.id,title: _learningTree.title));
    _goalIds.add(learningGoal.id);
  }

  /// Sets [_focusGoal] to the input [learningGoal] and [_focusGoalIndex] to the id representing the input [learningGoal].
  /// Throws if the input [learningGoal] is not part of [_learningTree].
  void setFocusGoal({required LearningGoal learningGoal}) {
    if (!_learningTree.contains(learningGoal.id)) {
      throw ArgumentError("Goal is not part of tree");
    }
    _focusGoal = learningGoal;
    _focusGoalIndex = _goalIds.indexOf(learningGoal.id);
  }




  /// Removes a [LearningGoal] from [_learningTree] and reconnects dependents from [learningGoal] to the trunk.
  void removeGoal({required LearningGoal learningGoal}) {

    if(learningGoal.id == _learningTree.trunk) {
      return;
    }
    Set<Edge> edges = _learningTree.edges;
    Set<LearningGoal> dependents = _learningTree.getDirectSuccessors(learningGoal);
    edges.removeWhere((element) => element.x2==learningGoal.id||element.x1==learningGoal.id);
    for(var v in dependents) {
        edges.add(Edge(x1: _learningTree.trunk, x2: v.id));
    }
    Set<LearningGoal> goals = nodes..removeWhere((element) => element==learningGoal);
    _updateLearningTree(LearningTree(nodes: goals, edges: edges,title: _learningTree.title,id: _learningTree.id));
  }



  /// Returns [false] if [_focusGoalIndex] has reached the highest id representing a [LearningGoal] in [_goalIds].
  /// If not, [_focusGoalIndex] will be increased by one, [_focusGoal] will be set with [_setFocusGoal] and returns [true].
  bool nextGoal() {
    if (_focusGoalIndex == _goalIds.length - 1) {
      return false;
    }
    _focusGoalIndex++;
    _setFocusGoal();
    return true;
  }

  /// Returns [false] if [_focusGoalIndex] == 0.
  /// If not, [_focusGoalIndex] will be decreased by one, [_focusGoal] will be set with [_setFocusGoal] and returns [true].
  bool previousGoal() {
    if (_focusGoalIndex == 0) {
      return false;
    }
    _focusGoalIndex--;
    _setFocusGoal();
    return true;
  }

  /// Prints a string representation of [_learningTree].
  void printTree() {
    print(_learningTree);
  }

  /// Prints a string representation of "[_focusGoalIndex] : [_focusGoal]".
  void printFocusGoal() {
    print("$_focusGoalIndex:$_focusGoal");
  }

  /// Returns a set of all the direct successors of [_focusGoal] in [_learningTree].
  Set<LearningGoal> get directForwardDependents {
    return _learningTree.getDirectDependents(_focusGoal);
  }

  /// Returns a set of all the direct predecessors of [_focusGoal] in [_learningTree].
  Set<LearningGoal> get directBackwardDependents {
    return _learningTree.getDirectPredecessors(_focusGoal);
  }

  /// Returns a set of all the successors of [_focusGoal] in [_learningTree].
  Set<LearningGoal> get forwardDependents {
    return _learningTree.getAllSuccessors(_focusGoal.id);
  }

  /// Returns a set of all the predecessors of [_focusGoal] in [_learningTree].
  Set<LearningGoal> get backwardDependents {
    return _learningTree.getAllPredecessor(_focusGoal.id);
  }

  /// Gets a set of all [LearningGoal]s in [_learningTree].
  Set<LearningGoal> get nodes => _learningTree.nodes;

  /// Gets a set of all [Edge]s in [_learningTree].
  Set<Edge> get edges => _learningTree.edges;


  LearningGoal get focusGoal => _focusGoal;

  /// This function requires an input [fromGoal] and [newGoal].
  /// Adds the input [newGoal] to the Set of [LearningGoal]s stored in [_learningTree].
  /// Adds the [Edge] between the input [fromGoal] and [newGoal] to the Set of [Edge]s stored in [_learningTree].
  /// Adds the id that represents the input [newGoal] to [_goalIds].
  void _addLearningGoalFromGoal(
      {required LearningGoal fromGoal, required LearningGoal newGoal}) {
    addLearningGoalAndEdge(
        learningGoal: newGoal,
        edge: Edge.fromNodes(node1: fromGoal, node2: newGoal));
  }

  /// This function requires an input [newGoal] and [toGoal].
  /// Adds the input [newGoal] to the Set of [LearningGoal]s stored in [_learningTree].
  /// Adds the [Edge] between the input [newGoal] and [toGoal] to the Set of [Edge]s stored in [_learningTree].
  /// Adds the id that represents the input [newGoal] to [_goalIds].
  void _addLearningGoalToGoal(
      {required LearningGoal newGoal, required LearningGoal toGoal}) {
    addLearningGoalAndEdge(
        learningGoal: newGoal,
        edge: Edge.fromNodes(node1: newGoal, node2: toGoal));
  }

  /// Sets [_learningTree] to the input [learningTree].
  void _updateLearningTree(LearningTree learningTree) {
    _learningTree = learningTree;
  }

  void addLearningTree(LearningTree other) {
    LearningTree merged = TreeMergingAssistant.merge(
        [_learningTree, other], _learningTree.trunkGoal,
        overwriteId: _learningTree.id);
    _updateLearningTree(merged);
  }

  /// Sets [_focusGoal] to the [LearningGoal] in [_learningTree] that is represented by the id that is equal to [_focusGoalIndex].
  void _setFocusGoal() {
    _focusGoal = _learningTree.getNodeById(_goalIds[_focusGoalIndex]);
  }

  /// Fills [_goalIds] with all ids representing [LearningGoal]s in [_learningTree].
  void _setGoalIds() {
    _goalIds = _learningTree.ids.toList();
  }
}
